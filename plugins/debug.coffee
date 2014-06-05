util = require 'util'
clc = require 'cli-color'

module.exports = ->
  array2str = (params) ->
    if params
      params = (clc.greenBright param for param in params)
      "[#{params.join ', '}]"
    else
      '[]'

  in_cb = ({prefix, command, params, trailing}) ->
    console.log clc.bold.blue('<-'),
      "#{clc.bold command}, " +
      "#{array2str params}, " +
      util.inspect(trailing) +
      clc.yellow(" (#{prefix})")

  out_cb = ({_, command, params, trailing}) ->
    console.log clc.bold.red('->'),
      "#{clc.bold command}, " +
      "#{array2str params}, " +
      util.inspect trailing

  @events.on 'in', in_cb
  @events.on 'out', out_cb

  unload: =>
    @events.removeListener 'in', in_cb
    @events.removeListener 'out', out_cb
  name: 'Debug'
  description: "Show in/out communication in nerdobot's console"
  version: '0.1'
  authors: ['Álvaro Cuesta']
