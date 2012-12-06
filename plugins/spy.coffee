module.exports = (bot) ->
  bot.events.on 'private', (from, message) ->
    console.log "#{from}: #{message}"

  bot.events.on 'channel', (from, message, channel) ->
    console.log "#{from}@#{channel}: #{message}"
