util = require './util'
irc = require './irc'
EventEmitter = require('events').EventEmitter

module.exports.Bot = class Bot extends irc.Client
  constructor: (config) ->
    super(config)

    @express = express()
    @express.use express.bodyParser()
    server = @express.listen config.http-port ? 9999
    @events.on 'end', -> server.close()

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

      meta = require('../plugins/' + plugin)(botInstance, config)
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
            if command == cmd
              helpMsg = "#{@BOLD}#{@color 'red'}#{@config.prefix}#{command}#{@RESET}"
              helpMsg += ' ' + info.args if info.args?
              helpMsg += ' - ' + info.description if info.description?

              @say to, helpMsg

              if info.help?
                @say to, " #{info.help}"

              if info.aliases? and info.aliases.length > 0
                @say to, " #{@BOLD}Aliases:#{@RESET} #{'!' + info.aliases.join ', !'}"

              return

        @notice nick, "Unknown command #{@BOLD}#{@config.prefix}#{command}#{@RESET}"
      else
        commands = []
        for _, meta of @plugins
          for cmd, _ of meta.commands
            commands.push cmd

        @say to, "#{@BOLD}#{@color 'red'}Available commands:#{@RESET} #{'!' + (commands.join ', !')}"
        @say to, " Type #{@BOLD}!help <command>#{@BOLD} for detailed instructions."

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
