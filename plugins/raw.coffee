module.exports = (bot) ->
  bot.commands.on 'raw', (from, command, to) ->
    if command? and command != ''
      bot.raw command
    else
      bot.notice "What should I do?", from.nick
