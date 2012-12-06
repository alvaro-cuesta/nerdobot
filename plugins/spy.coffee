util = require '../lib/util'

module.exports = (bot) ->
  bot.events.on 'message', (from, message, channel) ->
    util.log "[#{if channel? then channel else 'QUERY'}] #{from.nick}: #{message}"
