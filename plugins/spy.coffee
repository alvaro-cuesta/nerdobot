util = require '../lib/util'
clc = require 'cli-color'

module.exports = ->
  @events.on 'message', (from, message, recipient) ->
    msgIn = if recipient? then clc.yellowBright recipient else clc.redBright 'QUERY'
    console.log "[#{msgIn}] #{clc.bold from.nick}: #{util.escape message}"

  @events.on 'notice', (from, message, recipient) ->
    msgIn = clc.yellowBright recipient ? 'NOTICE'
    fromNick = from?.nick ? 'SERVER'
    prefix = (clc.bold.magentaBright '{') + msgIn + (clc.bold.magentaBright '}')
    console.log clc.magenta "#{prefix} #{clc.bold fromNick}: #{util.escape message}"

  name: 'Spy'
  description: "See channel and private messages in nerdobot's console"
  version: '0.1'
  authors: ['Álvaro Cuesta']
