Bot = require('./lib/bot.coffee').Bot
config = require('./config')

bot = new Bot(config)

bot.events.on 'connected', () ->
  console.log 'Connected'

bot.events.on 'end', () ->
  console.log 'Disconnected'

bot.events.on 'private', (from, message) ->
  console.log "#{from}: #{message}"

bot.events.on 'channel', (channel, from, message) ->
  console.log "#{from}@#{channel}: #{message}"

bot.commands.on 'say', (from, message, to) ->
  if message? and message != ''
    end = message.indexOf ' '
    to = message.slice 0, end
    message = message.slice end + 1
    if to? and to != '' and message? and message != ''
      bot.raw "PRIVMSG #{to} :#{message}"

bot.commands.on 'raw', (from, command, to) ->
  if command? and command != ''
    bot.raw command

bot.connect()
