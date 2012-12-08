util = require '../lib/util'

module.exports = (bot) ->
  bot.commands.on 'say', (from, message, to) ->
    if message? and message != ''
      [a, b] = util.split message, ' '

      if b? and b != ''
        [dest, msg] = [a, b]
      else if to? and a? and a != ''
        [dest, msg] = [to, a]
      else
        bot.notice 'Say what?', from.nick
        return

      bot.say msg, dest
    else
      bot.notice 'Say what?', from.nick
