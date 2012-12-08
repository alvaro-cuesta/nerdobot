module.exports = (bot, greetings) ->
  bot.events.on 'join', (who, channel) ->
    if who.nick == bot.nick
      random = greetings[Math.floor(Math.random() * greetings.length)]
      random(bot, channel)

  name: 'Hi'
  description: 'Greets randomly upon joining any channel'
  version: '0.1'
  authors: ['Álvaro Cuesta']
