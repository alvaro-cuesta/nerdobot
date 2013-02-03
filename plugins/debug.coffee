util = require 'util'
clc = require 'cli-color'

module.exports = ->
  array2str = (params) ->
    if params
      params = (clc.greenBright param for param in params)
      "[#{params.join ', '}]"
    else
      '[]'

  @events.on 'in', ({prefix, command, params, trailing}) ->
    console.log clc.bold.blue('<-'),
      "#{clc.bold command}, " +
      "#{array2str params}, " +
      util.inspect(trailing) +
      clc.yellow(" (#{prefix})")

  @events.on 'out', ({_, command, params, trailing}) ->
    console.log clc.bold.red('->'),
      "#{clc.bold command}, " +
      "#{array2str params}, " +
      util.inspect trailing

  name: 'Debug'
  description: "Show in/out communication in nerdobot's console"
  version: '0.1'
  authors: ['Álvaro Cuesta']
