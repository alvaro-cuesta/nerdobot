irc = require('./irc')
EventEmitter = require('events').EventEmitter

module.exports.Bot = class Bot extends irc.Client
  constructor: (config) ->
    super(config)
    @commands = new EventEmitter()

    @events.on 'welcome', () =>
      for channel in @config.channels
        @raw 'JOIN ' + channel

    @events.on 'private', (from, message) =>
      @parseMessage from, message
    @events.on 'channel', (from, message, to) =>
      @parseMessage from, message, to

    for plugin in config.plugins
      require('../plugins/' + plugin)(this)

  parseMessage: (from, message, to) ->
    if message.charAt(0) == '!'
      end = message.indexOf ' '
      if end > 0
        command = message.slice 1, end
        trailing = message.slice end + 1
      else
        command = message.slice 1

      from = irc.parse_prefix(from)

      if @commands.listeners(command).length > 0
        @commands.emit command, from, trailing, to
      else
        @raw "NOTICE #{from.nick} :Unknown command #{command}"
