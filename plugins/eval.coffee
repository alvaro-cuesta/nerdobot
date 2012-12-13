Sandbox = require 'sandbox'  # TODO: bugged!
MAX_LOGS = 5

sayOutput = (bot, to) -> (out) ->
  # TODO: Remove whitespace in output
  #       Limit output characters
  bot.say to, "#{bot.BOLD}=#{bot.RESET} #{out.result}"
  for log in out.console[0..MAX_LOGS-1]
    bot.say to, "#{bot.BOLD}>>#{bot.RESET} #{log}"
  if out.console.length > MAX_LOGS
    bot.say to, "... #{bot.BOLD}(console output was truncated)#{bot.RESET}"

module.exports = (bot, {coffee}) ->
  s = new Sandbox()

  readBlock = (nick, end_pattern, cb) ->
    do ->
      buffer = ''
      message = (from, msg, to) ->
        if from.nick == nick and msg != end_pattern
          buffer += "#{msg}\n"
      end = (from, trailing, to) ->
        if from.nick == nick
          cb buffer
          bot.events.removeListener 'message', message
          bot.commands.removeListener 'eval!', end

      bot.events.on 'message', message
      bot.commands.on end_pattern, end

  bot.commands.on 'eval', ({nick}, trailing, to) ->
    s.run trailing, sayOutput(bot, to ? nick)

  bot.commands.on '!eval', ({nick}, trailing, to) ->
    bot.say to ? nick,
      " #{bot.color 'red'}! Reading JavaScript block from #{nick}#{bot.RESET}"
    readBlock nick, '!end', (buffer) ->
      console.log 'end'
      s.run buffer, sayOutput(bot, to ? nick)

  if coffee
    cs = require 'coffee-script'
    bot.commands.on 'coff', ({nick}, trailing, to) ->
      js = cs.compile trailing, bare: true
      s.run js, sayOutput(bot, to ? nick)

    bot.commands.on '!coff', ({nick}, trailing, to) ->
      bot.say to ? nick,
        " #{bot.color 'red'}! Reading CoffeeScript block from #{nick}#{bot.RESET}"
      readBlock nick, '!end', (buffer) ->
        js = cs.compile buffer, bare: true
        s.run js, sayOutput(bot, to ? nick)

  name: 'Eval'
  description: 'Evaluate sandboxed code using !eval (CoffeeScript optional)'
  version: '0.1'
  authors: ['Álvaro Cuesta']
