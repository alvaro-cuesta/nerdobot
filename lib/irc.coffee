net = require('net')
EventEmitter = require('events').EventEmitter

module.exports.parse = parse = (message) ->
  if message[0] == ':'
    end = message.indexOf ' '
    prefix = message[1..end-1]
    message = message[end+1..]

  end = message.indexOf ' '
  command = message[0..end-1]
  message = message[end+1..]

  end = message.indexOf ':'
  if end >= 0
    if end isnt 0
      params = message[..end-2].split(' ')
    message = message[end+1..]
  else
    params = message.split(' ')
    message = undefined

  prefix: prefix
  command: command
  params: params
  trailing: message

module.exports.parse_prefix = parse_prefix = (prefix) ->
  match = prefix.match /^(.*)!(\S+)@(\S+)/
  if match
    nick: match[1]
    user: match[2]
    host: match[3]
  else
    null

module.exports.Client = class Client
  constructor: (@config) ->
    @events = new EventEmitter()
    @server = new EventEmitter()
    @nick = @config.user.nick
    @channels = []

  connect: () ->
    @socket = net.connect @config.socket, () =>
      @socket.on 'data', (data) =>
        for message in data.split '\r\n'
          if message != ''
            @events.emit 'raw', message
            @data parse(message)
      @socket.on 'end', () =>
        @events.emit 'end'

      @raw "NICK #{@config.user.nick}"
      modes = 0
      modes += 1<<2 if @config.user.wallops
      modes += 1<<3 if @config.user.invisible
      @raw "USER #{@config.user.login} #{modes} * :#{@config.user.realname}"
      @events.emit 'connected'

    @socket.setEncoding @config.connection.encoding

  data: (message) ->
    switch message.command
      when 'PING'
        @raw "PONG :#{message.trailing}"
      when '001'
        @events.emit 'welcome'
      when 'PRIVMSG'
        who = parse_prefix(message.prefix)
        if message.params[0] != @config.user.nick
          channel = message.params[0]
        @events.emit 'message', who, message.trailing, channel
      when 'NOTICE'
        who = parse_prefix(message.prefix) if message.prefix?
        @events.emit 'notice', who, message.trailing, message.params[0]
      when 'JOIN'
        who = parse_prefix(message.prefix)
        if who == @nick
          @channels.unshift message.trailing
        for channel in message.params
          @events.emit 'join', who, channel

    @server.emit message.command,
      message.prefix,
      message.params,
      message.trailing
    @events.emit 'parsed', message

  raw: (message) ->
    @socket.write message + '\r\n'
    @events.emit 'out', parse message

  join: (channel) -> @raw "JOIN #{channel}"
  say: (message, to) -> @raw "PRIVMSG #{to} :#{message}"
  me: (message, to) -> @say("\x01ACTION #{message}\x01", to)
  notice: (message, to) -> @raw "NOTICE #{to} :#{message}"

  color: (foreground, background) ->
    fore = @COLORS.indexOf foreground
    color = "\x03#{fore}"
    if background?
      back = @COLORS.indexOf background
      color += ",#{back}"
    color
  BOLD: "\x02"
  UNDERLINE: "\x1f"
  RESET: "\x0f"
  COLORS: [
    'white',
    'black',
    'blue',
    'green',
    'red',
    'brown',
    'purple',
    'orange',
    'yellow',
    'light green',
    'teal',
    'cyan',
    'light blue',
    'pink',
    'grey',
    'light grey'
    ]
