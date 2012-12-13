Sandbox = require 'sandbox'  # TODO: bugged!
util = require 'util'
MAX_LOGS = 5

sayOutput = (bot, to) -> (out) ->
  # TODO: Remove whitespace in output
  #       Limit output characters
  bot.say to, " #{bot.BOLD}=#{bot.RESET} #{out.result}"

  return unless out.console.length > 0

  con = "[ "
  con += (util.inspect(log) for log in out.console[..MAX_LOGS]).join ', '

  if out.console.length > MAX_LOGS
    con += ', ...'

  con += " ]"
  bot.say to, "#{bot.BOLD}>>#{bot.RESET} #{con}"

module.exports = (bot, {coffee}) ->
  s = new Sandbox()

  readBlock = (nick, readOn, end_pattern, cb) ->
    do ->
      buffer = ''
      message = (from, msg, to) ->
        if from.nick == nick and msg != end_pattern and to == readOn
          buffer += "#{msg}\n"
      end = (from, trailing, to) ->
        if from.nick == nick and to == readOn
          cb buffer
          bot.events.removeListener 'message', message
          bot.commands.removeListener end_pattern, end

      bot.events.on 'message', message
      bot.commands.on end_pattern, end

  bot.commands.on 'eval', ({nick}, trailing, to) ->
    s.run trailing, sayOutput(bot, to ? nick)

  bot.commands.on '!eval', ({nick}, trailing, to) ->
    to ?= nnick
    bot.say to,
      " #{bot.color 'red'}! Reading JavaScript block from #{nick}#{bot.RESET}"
    readBlock nick, to, '!end', (buffer) ->
      s.run buffer, sayOutput(bot, to)

  if coffee
    cs = require 'coffee-script'
    bot.commands.on 'coff', ({nick}, trailing, to) ->
      js = cs.compile trailing, bare: true
      s.run js, sayOutput(bot, to ? nick)

    bot.commands.on '!coff', ({nick}, trailing, to) ->
      to ?= nick
      bot.say to,
        " #{bot.color 'red'}! Reading CoffeeScript block from #{nick}#{bot.RESET}"
      readBlock nick, to, '!end', (buffer) ->
        js = cs.compile buffer, bare: true
        s.run js, sayOutput(bot, to ? nick)

  name: 'Eval'
  description: 'Evaluate sandboxed code using !eval (CoffeeScript optional)'
  version: '0.1'
  authors: ['Álvaro Cuesta']
