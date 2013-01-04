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
      meta = require('../plugins/' + plugin)(this, config)
      # = {name, version, descriptioni, authors}
      if meta
        @plugins[plugin] = meta
        console.log "#{meta.name} v#{meta.version} - #{meta.description}"
      else
        console.log "Error loading '#{plugin}'"

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
