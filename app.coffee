irc = require('./irc')
config = require('./config')

client = new irc.Client(config)

client.events.on 'connected', () ->
  console.log 'Connected'

client.events.on 'welcome', () ->
  client.raw 'JOIN #mv.nerd'

client.events.on 'end', () ->
  console.log 'Disconnected'

handleCommand = (from, command, trailing) ->
  switch command
    when 'say'
      if trailing? and trailing != ''
        end = trailing.indexOf ' '
        to = trailing.slice 0, end
        message = trailing.slice end + 1
        if to? and to != '' and message? and message != ''
          client.raw "PRIVMSG #{to} :#{message}"
    when 'raw'
      if trailing? and trailing != ''
        client.raw trailing
    else
      client.raw "NOTICE #{from.nick} :Unknown command #{command}"

messageCallback = (from, message) ->
  if message.charAt(0) == '!'
    end = message.indexOf ' '
    if end > 0
      command = message.slice 1, end
      trailing = message.slice end + 1
    else
      command = message.slice 1
    handleCommand(irc.parse_prefix(from), command, trailing)

client.events.on 'private', (from, message) ->
  console.log "#{from}: #{message}"
  messageCallback(from, message)

client.events.on 'channel', (channel, from, message) ->
  console.log "#{from}@#{channel}: #{message}"
  messageCallback(from, message)

client.connect()
