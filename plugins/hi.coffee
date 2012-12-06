module.exports = (bot) ->
  bot.events.on 'join', (who, channel) ->
    if who.nick == bot.nick
      rand = Math.floor(Math.random() * bot.config.greetings.length)
      bot.config.greetings[rand](bot, channel)
