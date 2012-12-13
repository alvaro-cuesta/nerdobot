Sandbox = require 'sandbox'  # TODO: bugged!
MAX_LOGS = 5

callback = (bot, to) -> (out) ->
  # TODO: Remove whitespace in output
  #       Limit output characters
  bot.say to, "#{bot.BOLD}=#{bot.RESET} #{out.result}"
  bot.say to, ">> #{log}" for log in out.console[0..MAX_LOGS-1]
  if out.console.length > MAX_LOGS
    bot.say to, "... #{bot.BOLD}(console output was truncated)#{bot.RESET}"

module.exports = (bot, {coffee}) ->
  s = new Sandbox()

  bot.commands.on 'eval', ({nick}, trailing, to) ->
    s.run trailing, callback(bot, to ? nick)

  if coffee
    cs = require 'coffee-script'
    bot.commands.on 'coff', ({nick}, trailing, to) ->
      js = cs.compile trailing, bare:true
      s.run js, callback(bot, to ? nick)

  name: 'Eval'
  description: 'Evaluate sandboxed code using !eval (CoffeeScript optional)'
  version: '0.1'
  authors: ['Álvaro Cuesta']
