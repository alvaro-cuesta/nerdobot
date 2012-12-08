irc = require('./irc')
EventEmitter = require('events').EventEmitter

module.exports.Bot = class Bot extends irc.Client
  constructor: (config) ->
    super(config)
    @commands = new EventEmitter()
    @plugins = {}

    @events.on 'welcome', () =>
      @join channel for channel in @config.channels
    @events.on 'message', (from, message, to) =>
      @parseCommand from, message, to

    for own plugin, config of config.plugins
      meta = require('../plugins/' + plugin)(this, config)
      if meta
        @plugins[plugin] = meta
        console.log "#{meta.name} #{meta.version} - #{meta.description}"
      else
        console.log "Error loading '#{plugin}'"

  parseCommand: (from, message, to) ->
    if message[0] == '!'
      end = message.indexOf ' '
      if end > 0
        command = message[1..end-1]
        trailing = message[end+1..]
      else
        command = message[1..]

      if @commands.listeners(command).length > 0
        @commands.emit command, from, trailing, to
      else
        @notice "Unknown command #{command}", from.nick
