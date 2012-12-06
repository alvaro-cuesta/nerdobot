module.exports = (bot) ->
  bot.commands.on 'raw', (from, command, to) ->
    if command? and command != ''
      bot.raw command
    else
      bot.raw "NOTICE #{from.nick} :What should I do?"
