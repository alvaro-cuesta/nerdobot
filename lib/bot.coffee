irc = require('./irc')
EventEmitter = require('events').EventEmitter

module.exports.Bot = class Bot extends irc.Client
  constructor: (config) ->
    super(config)
    @commands = new EventEmitter()

    @events.on 'welcome', () =>
      @join channel for channel in @config.channels
    @events.on 'message', (from, message, to) =>
      @parseCommand from, message, to

    for plugin in config.plugins
      require('../plugins/' + plugin)(this)

  parseCommand: (from, message, to) ->
    if message.charAt(0) == '!'
      end = message.indexOf ' '
      if end > 0
        command = message.slice 1, end
        trailing = message.slice end + 1
      else
        command = message.slice 1

      if @commands.listeners(command).length > 0
        @commands.emit command, from, trailing, to
      else
        @notice "Unknown command #{command}", from.nick
