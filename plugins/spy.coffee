util = require '../lib/util'
clc = require 'cli-color'

module.exports = ->

  message_cb = (from, message, recipient) ->
    msgIn = if recipient? then clc.yellowBright recipient else clc.redBright 'QUERY'
    console.log "[#{msgIn}] #{clc.bold from.nick}: #{util.escape message}"

  notice_cb = (from, message, recipient) ->
    msgIn = clc.yellowBright recipient ? 'NOTICE'
    fromNick = from?.nick ? 'SERVER'
    prefix = (clc.bold.magentaBright '{') + msgIn + (clc.bold.magentaBright '}')
    console.log clc.magenta "#{prefix} #{clc.bold fromNick}: #{util.escape message}"

  @events.on 'message', message_cb
  @events.on 'notice', notice_cb

  unload: =>
    @events.removeListener 'message', message_cb
    @events.removeListener 'notice', notice_cb
  name: 'Spy'
  description: "See channel and private messages in nerdobot's console"
  version: '0.1'
  authors: ['Álvaro Cuesta']
