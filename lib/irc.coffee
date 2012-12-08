util = require './util'
net = require('net')
EventEmitter = require('events').EventEmitter

# Parse an IRC command into {prefix, command, [params], trailing}
# prefix, params and trailing may be undefined
module.exports.parse = parse = (message) ->
  [prefix, message] = util.split message[1..], ' ' if message[0] == ':'
  [message, trailing] = util.split message, ' :'
  [command, params] = util.split message, ' '

  prefix: prefix
  command: command
  params: params.split ' ' if params
  trailing: trailing

# Parse an IRC prefix into {nick, user, host}
module.exports.parse_prefix = parse_prefix = (prefix) ->
  match = prefix.match /^(.*)!(\S+)@(\S+)/
  if match
    nick: match[1]
    user: match[2]
    host: match[3]

# IRC client class
module.exports.Client = class Client
  constructor: (@config) ->
    @nick = @config.user.nick
    @channels = []

    @events = new EventEmitter()
    # Emits:
    #  connected
    #  end
    #  welcome
    #  message -> from, msg, channel
    #    if channel = undefined, it's a private message
    #  notice -> from, msg, to
    #  join -> who, channel
    #  in -> parsed_message
    #  out -> parsed_message

    @server = new EventEmitter()
    # Emits server commands -> prefix, [params], trailing

  connect: ->
    @socket = net.connect @config.socket, =>
      # ON CONNECTION
      @events.emit 'connected'

      # Receive chunks in a buffer, splitting by \r\n
      buffer = ''
      @socket.on 'data', (chunk) =>
        buffer += chunk;
        while buffer != ''
          offset = buffer.indexOf '\r\n'
          return if offset < 0

          if offset > 0
            @message parse buffer[0..offset-1]

          buffer = buffer[offset+2..]

      @socket.on 'end', => @events.emit 'end'

      # Auth to IRC server
      @raw "NICK #{@config.user.nick}"
      modes = 0
      modes += 1<<2 if @config.user.wallops
      modes += 1<<3 if @config.user.invisible
      @raw "USER #{@config.user.login} #{modes} * :#{@config.user.realname}"

    @socket.setEncoding @config.connection.encoding

  # Parse server message
  message: (message) ->
    @events.emit 'in', message

    @server.emit message.command,
      message.prefix,
      message.params,
      message.trailing

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
        if who.nick == @nick
          @channels.unshift message.trailing
        for channel in message.params
          @events.emit 'join', who, channel

  # IRC actions
  raw: (message) ->
    @events.emit 'out', parse message
    @socket.write message + '\r\n'

  join: (channel) ->
    @raw "JOIN #{channel}"

  say: (message, to) ->
    @raw "PRIVMSG #{to} :#{message}"

  me: (message, to) ->
    @say "\x01ACTION #{message}\x01", to

  notice: (message, to) ->
    @raw "NOTICE #{to} :#{message}"

  # IRC control characters (color, bold...)
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
