util = require './util'
net = require('net')
EventEmitter = require('events').EventEmitter

DEFAULT_THROTTLE = 10000

# Parse an IRC command into [prefix, command, [params], trailing]
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
    @throttleTime = @config.throttle ? DEFAULT_THROTTLE

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

      @throttleTime = @config.throttle ? DEFAULT_THROTTLE

      # Receive chunks in a buffer, splitting by \r\n
      buffer = ''
      @socket.on 'data', (chunk) =>
        buffer += chunk;
        while buffer != ''
          offset = buffer.indexOf '\r\n'
          return if offset < 0

          @message parse buffer[0...offset] if offset > 0

          buffer = buffer[offset+2..]

      @socket.on 'end', => @events.emit 'end'

      # Auth to IRC server

      # Try nicks until one of them is available
      if Array.isArray @config.user.nick
        nicklist = @config.user.nick
      else
        nicklist = [@config.user.nick]

      i = 0
      @raw "NICK :#{nicklist[i++]}"
      usedListener = =>
        if nicklist[i]?
          @raw "NICK :#{nicklist[i++]}"
        else
          plural = if nicklist.length > 1 then 'are' else 'is'
          throw "NICK_ERR: Couldn't change nick, [#{nicklist}] #{plural} taken"
      welcomeListener = =>
        @server.removeListener '433', usedListener
        @events.removeListener 'welcome', welcomeListener

      @server.on '433', usedListener
      @events.on 'welcome', welcomeListener
      @events.on 'end', welcomeListener

      # Usermodes
      modes = 0
      modes += 1<<2 if @config.user.wallops
      modes += 1<<3 if @config.user.invisible

      # Username
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
        @nick = message.params[0]
      when 'NICK'
        @nick = message.trailing if @nick == message.prefix.nick
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
        message.params = [message.trailing] if message.trailing?
        console.log @channels
        for channel in message.params
          @channels.push channel if who.nick == @nick
          console.log channel
          @events.emit 'join', who, channel
        console.log @channels
      when 'ERROR'
        if message.trailing == 'Your host is trying to (re)connect too fast -- throttled'
          setTimeout (=> @connect()), @throttleTime *= 2

  # IRC actions
  raw: (message) ->
    @events.emit 'out', parse message
    @socket.write message + '\r\n'

  setNick: (nick, cb) ->
    if Array.isArray nick
      nicklist = nick
    else
      nicklist = [nick]

    do (i = 0, nicklist) =>
      @raw "NICK :#{nicklist[i++]}"

      usedListener = =>
        if nicklist[i]? #and nicklist[i] != @nick
          @raw "NICK :#{nicklist[i++]}"
        else
          plural = if nicklist.length > 1 then 'are' else 'is'
          finish "Couldn't change nick, [#{nicklist}] #{plural} taken"
      throttleListener = (_, [current, tried], msg) =>
        finish "Changing nick to #{tried} - #{msg}"
      nickListener = (_, _0, acceptedNick) =>
        finish() if acceptedNick == nicklist[i-1]
      finish = (err) =>
        @server.removeListener '433', usedListener
        @server.removeListener '438', throttleListener
        @server.removeListener 'NICK', nickListener
        cb err

      @server.on '433', usedListener
      @server.on '438', throttleListener
      @server.on 'NICK', nickListener

  join: (channels) ->
    if not Array.isArray channels
      channels = [channels]

    @raw "JOIN #{channels.join ' '}"

  broadcastHelper: (args) ->
    args = [].slice.call(args) ? []
    switch args.length
      when 2
        [recipients, message] = args
        if not Array.isArray recipients
          recipients = [recipients]

        return [recipients, message]
      when 1
        return [@channels, args[0]]

  say: ->
    [recipients, message] = (@broadcastHelper arguments) ? []
    @raw "PRIVMSG #{to} :#{message}" for to in recipients if recipients?

  me: ->
    [recipients, message] = (@broadcastHelper arguments) ? []
    @say recipients, "\x01ACTION #{message}\x01" if recipients?

  notice: ->
    [recipients, message] = (@broadcastHelper arguments) ? []
    @raw "NOTICE #{to} :#{message}" for to in recipients if recipients?

  # IRC control characters (color, bold...)
  color: (foreground, background) ->
    fore = @COLORS.indexOf foreground
    color = "\x03#{fore}"
    if background?
      back = @COLORS.indexOf background
      color += ",#{back}"
    color

  stripControl: (string) ->
    string = string.replace /[\x02|\x1f|\x0f]/g, ''
    string = string.replace /\x03[0-9][0-9]?(,[0-9][0-9]?)?/g, ''
    string

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
