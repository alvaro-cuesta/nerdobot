util = require 'util'

module.exports.escape = escape = (string) ->
  inspect = util.inspect string
  inspect[1..inspect.length-2]

module.exports.log = (string) -> console.log escape string

module.exports.split = (string, split) ->
  end = string.indexOf split
  if end > 0
    [string[0..end-1], string[end+split.length..]]
  else if end == 0
    [undefined, string[split.length..]]
  else
    [string[0..], undefined]
