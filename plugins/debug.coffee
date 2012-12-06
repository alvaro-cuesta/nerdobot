util = require '../lib/util'
nutil = require 'util'

module.exports = (bot) ->
  bot.events.on 'parsed', (parsed) ->
    {prefix, command, params, trailing} = parsed
    text = " <- [#{prefix}, #{command}, #{params? and '['+params.join(', ')+']'}, #{trailing}]"
    util.log text
