util = require '../lib/util'

module.exports = (bot) ->
  bot.commands.on 'say', (from, message, channel) ->
    if message? and message != ''
      if channel?
        [dest, msg] = [channel, message]
      else
        [a, b] = util.split message, ' '
        if b? and b != ''
          [dest, msg] = [a, b]
        else
          bot.notice from.nick, 'Say what?'
          return

      bot.say dest, msg
    else
      bot.notice from.nick, 'Say what?'

  name: 'Say'
  description: 'Command to say things'
  version: '0.1'
  authors: ['Álvaro Cuesta']
