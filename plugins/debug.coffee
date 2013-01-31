util = require '../lib/util'
nutil = require 'util'

module.exports = ->
  array2str = (params) ->
    if params then "[#{params.join ', '}]" else '[]'

  @events.on 'in', ({prefix, command, params, trailing}) ->
    util.log " <- [#{prefix}, #{command}, #{array2str params}, #{trailing}]"

  @events.on 'out', ({_, command, params, trailing}) ->
    util.log " -> [#{command}, #{array2str params}, #{trailing}]"

  name: 'Debug'
  description: "Show in/out communication in nerdobot's console"
  version: '0.1'
  authors: ['Álvaro Cuesta']
