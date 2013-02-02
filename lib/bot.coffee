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
      botInstance.addCommand = (command, meta, cb) =>
        commands[command] = meta
        @commands.on command, cb
        @commands.on alias, cb for alias in meta.aliases if meta.aliases?

      meta = require('../plugins/' + plugin).apply botInstance, [config]
      # = {name, version, description, authors}
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
        command = command[1..] if command[0] == @config.prefix

        for _, meta of @plugins
          for cmd, info of meta.commands
            if command == cmd or (info.aliases? and command in info.aliases)
              helpMsg = "#{@BOLD}#{@color 'red'}#{@config.prefix}#{cmd}#{@RESET}"
              helpMsg += ' ' + info.args if info.args?
              helpMsg += ' - ' + info.description if info.description?

              @say to, helpMsg

              if info.help?
                @say to, " #{info.help}"

              if info.aliases? and info.aliases.length > 0
                @say to, " #{@BOLD}Aliases:#{@RESET} #{@config.prefix + info.aliases.join ", #{@config.prefix}"}"

              return

        @notice nick, "Unknown command #{@BOLD}#{@config.prefix}#{command}#{@RESET}"
      else
        commands = []
        for _, meta of @plugins
          for cmd, _ of meta.commands
            commands.push cmd

        commands.sort (a, b) ->
          return 1 if a > b
          return -1 if a < b
          0

        @say to, "#{@BOLD}#{@color 'red'}Available commands:#{@RESET} #{@config.prefix + commands.join ", #{@config.prefix}"}"
        @say to, " Type #{@BOLD}#{@config.prefix}help <command>#{@BOLD} for detailed instructions."

  # Parse messages looking for client commands
  parseCommand: (from, message, channel) ->
    antiflood = =>
      setTimeout =>
        @time = true
      , @config.timeout

    [command, rest] = util.split message, ' '
    if not command? or command == ''
      return

    command = @stripControl command

    if command[0] == @config.prefix
      command = command[1..]

      args = rest if rest != ''

      if @commands.listeners(command).length > 0
        if @time == true
          @time = false
          @commands.emit command, from, args, channel
          antiflood()

      else
        @notice from.nick, "Unknown command #{@BOLD}#{@config.prefix}#{command}#{@RESET}"
