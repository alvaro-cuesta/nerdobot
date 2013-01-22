module.exports = (bot) ->
  bot.addCommand 'raw', [],
    'Send a raw command to IRC server',
    'ARGS: <command>',
    (from, command) ->
      if command? and command != ''
        bot.raw command
      else
        bot.notice from.nick, "What should I do?"

  name: 'Raw'
  description: 'Send raw IRC commands to server'
  version: '0.1'
  authors: ['Álvaro Cuesta']
