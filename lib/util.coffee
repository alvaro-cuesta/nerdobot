util = require 'util'

# Escape control characters from a string so '\x01' gets printed
module.exports.escape = escape = (string) ->
  inspect = util.inspect string
  inspect[1..inspect.length-2]

# Log string pre-escaping it
module.exports.log = (string) -> console.log escape string

# Split a string in two
module.exports.split = (string, pattern) ->
  idx = string.indexOf pattern
  if idx > 0
    [string[0..idx-1], string[idx+pattern.length..]]
  else if idx == 0
    [undefined, string[pattern.length..]]
  else
    [string[0..], undefined]
