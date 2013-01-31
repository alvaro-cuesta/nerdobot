util = require '../lib/util'

module.exports = ->
  @events.on 'message', (from, message, channel) ->
    util.log "[#{if channel? then channel else 'QUERY'}] #{from.nick}: #{message}"

  name: 'Spy'
  description: "See channel and private messages in nerdobot's console"
  version: '0.1'
  authors: ['Álvaro Cuesta']
