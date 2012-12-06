module.exports = (bot) ->
  bot.commands.on 'say', (from, message, to) ->
    if message? and message != ''
      end = message.indexOf ' '
      to = message.slice 0, end
      message = message.slice end + 1
      if to? and to != '' and message? and message != ''
        bot.raw "PRIVMSG #{to} :#{message}"
      else
        bot.raw "NOTICE #{from.nick} :Say what?"
    else
      bot.raw "NOTICE #{from.nick} :Say what?"
