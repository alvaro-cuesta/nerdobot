util = require '../lib/util'

module.exports = (bot) ->
  bot.commands.on 'say', (from, message, channel) ->
    if message? and message != ''
      [a, b] = util.split message, ' '

      if b? and b != ''
        [dest, msg] = [a, b]
      else if channel? and a? and a != ''
        [dest, msg] = [channel, a]
      else
        bot.notice 'Say what?', from.nick
        return

      bot.say msg, dest
    else
      bot.notice 'Say what?', from.nick

  name: 'Say'
  description: 'Command to say things'
  version: '0.1'
  authors: ['Álvaro Cuesta']
