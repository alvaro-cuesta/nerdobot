module.exports = (bot) ->
  bot.events.on 'message', (from, message, channel) ->
    if channel
      console.log "[#{channel}] #{from.nick}: #{message}"
    else
      console.log "[QUERY] #{from.nick}: #{message}"
