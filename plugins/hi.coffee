module.exports = (bot) ->
  bot.events.on 'join', (who, channel) ->
    if who.nick == bot.nick
      bot.me 'says hi', channel
