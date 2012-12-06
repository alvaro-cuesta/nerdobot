module.exports = (bot) ->
  bot.events.on 'parsed', (message) -> console.log message
