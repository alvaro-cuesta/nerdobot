module.exports = (bot) ->
  bot.commands.on 'say', (from, message, to) ->
    if message? and message != ''
      end = message.indexOf ' '
      to = message.slice 0, end
      message = message.slice end + 1
      if to? and to != '' and message? and message != ''
        bot.say message, to
      else
        bot.notice 'Say what?', from.nick
    else
      bot.notice 'Say what?', from.nick
