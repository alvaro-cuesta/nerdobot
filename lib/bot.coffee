util = require './util'
irc = require './irc'
EventEmitter = require('events').EventEmitter

module.exports.Bot = class Bot extends irc.Client
  constructor: (config) ->
    super(config)

    @plugins = {}
    @time = true

    @commands = new EventEmitter()
    # Emits commands issues by users
    #   command -> from, args, channel
    #     channel is undefined in private messages

    @events.on 'welcome', () =>
      @join channel for channel in @config.channels

    @events.on 'message', (from, message, channel) =>
      @parseCommand from, message, channel

    # Load plugins
    for own plugin, config of config.plugins
      commands = {}

      botInstance = Object.create this
      botInstance.addCommand = (command, aliases, description, help, cb) =>
        commands[command] =
          aliases: aliases
          description: description
          help: help
          cb: cb
        @commands.on command, cb
        @commands.on alias, cb for alias in aliases

      meta = require('../plugins/' + plugin)(botInstance, config)
      # = {name, version, descriptioni, authors}
      if meta
        @plugins[plugin] = meta
        @plugins[plugin].commands = commands
        console.log "#{meta.name} v#{meta.version} - #{meta.description}"
      else
        console.log "Error loading '#{plugin}'"

    # Command help
    @commands.on 'help', ({nick}, command, to) =>
      to ?= nick

      if command?
        for plugin, meta of @plugins
          for comm, info of meta.commands
            if command == comm
              @say to,
                "#{@BOLD}#{@color 'red'}#{@config.prefix}#{command}#{@RESET}" +
                " - #{info.description}"
              @say to, " #{info.help}"
              if info.aliases? and info.aliases.length > 0
                @say to, " #{@BOLD}Aliases:#{@RESET} #{info.aliases}"
              return
        @notice nick, "Unknown command #{@BOLD}#{@config.prefix}#{command}#{@RESET}"
      else
        @say to, "#{@BOLD}#{@color 'red'}Available commands:#{@RESET}"
        for plugin, meta of @plugins
          for comm, info of meta.commands
            @say to, " #{@BOLD}#{@config.prefix}#{comm}#{@RESET} - #{info.description}"

  # Parse messages looking for client commands
  parseCommand: (from, message, channel) ->
    antiflood = =>
      setTimeout =>
        @time = true
      , @config.timeout

    if message[0] == @config.prefix
      [command, rest] = util.split message[1..], ' '
      if not command? or command == ''
        return

      args = rest if rest != ''

      if @commands.listeners(command).length > 0
        if @time == true
          @time = false
          @commands.emit command, from, args, channel
          antiflood()

      else
        @notice from.nick, "Unknown command #{@BOLD}#{@config.prefix}#{command}#{@RESET}"
