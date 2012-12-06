util = require 'util'

module.exports.escape = escape = (string) ->
  inspect = util.inspect string
  inspect[1..inspect.length-2]

module.exports.log = (string) -> console.log escape string
