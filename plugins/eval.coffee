Sandbox = require 'sandbox'  # TODO: bugged!
util = require 'util'

MAX_CHARS = 128
MAX_LOGS = 30

module.exports = ({coffee}) ->
  sayOutput = (to) => (out) =>
    stdout = out.result.replace(/[\r|\n]/g, '')
    if stdout.length > MAX_CHARS
      stdout = stdout[...MAX_CHARS] + "... #{@BOLD}(output truncated)#{@RESET}"
    @say to, " #{@BOLD}=#{@RESET} #{stdout}"

    return unless out.console.length > 0

    con = "[ "
    con += (util.inspect(log) for log in out.console[...MAX_LOGS]).join ', '

    if out.console.length > MAX_LOGS
      con += ', ...'

    con += " ]"

    con = con.replace(/[\r|\n]/g, '')
    if con.length > MAX_CHARS
      con = con[...MAX_CHARS] + "... #{@BOLD}(output truncated)#{@RESET}"
    @say to, "#{@BOLD}>>#{@RESET} #{con}"

  s = new Sandbox()

  readBlock = (nick, readOn, end_pattern, cb) =>
    do =>
      buffer = ''
      message = (from, msg, to) ->
        if from.nick == nick and msg != end_pattern and to == readOn
          buffer += "#{msg}\n"
      end = (from, trailing, to) =>
        if from.nick == nick and to == readOn
          cb buffer
          @events.removeListener 'message', message
          @commands.removeListener end_pattern, end

      @events.on 'message', message
      @commands.on end_pattern, end

  @addCommand 'eval',
    args: '<js code>'
    aliases: ['js']
    description: 'Evaluate JavaScript code'
    ({nick}, trailing, to) =>
      s.run trailing, sayOutput to ? nick

  @addCommand "#{@config.prefix}eval",
    aliases: ["#{@config.prefix}js"]
    description: 'Evaluate a block of JavaScript code',
    help: "When done, write #{@config.prefix}#{@config.prefix}end and the full block will be executed"
    ({nick}, trailing, to) =>
      to ?= nnick
      @say to,
        " #{@color 'red'}! Reading JavaScript block from #{nick}#{@RESET}"
      readBlock nick, to, "#{@config.prefix}end", (buffer) =>
        s.run buffer, sayOutput to

  if coffee
    cs = require 'coffee-script'
    @addCommand 'coffee',
      args: '<cs code>'
      aliases: ['coff']
      description: 'Evaluate CoffeeScript code'
      ({nick}, trailing, to) =>
        to ?= nick
        try
          js = cs.compile trailing, bare: true
          s.run js, sayOutput to
        catch error
          @say to, " #{@BOLD}=#{@RESET} '#{error}'"

    @addCommand "#{@config.prefix}coffee",
      aliases: ["#{@config.prefix}coff"]
      description: 'Evaluate a block of CoffeeScript code'
      help: "When done, write #{@config.prefix}#{@config.prefix}end and the full block will be executed"
      ({nick}, trailing, to) =>
        to ?= nick
        @say to,
          " #{@color 'red'}! Reading CoffeeScript block from #{nick}#{@RESET}"
        readBlock nick, to, "#{@config.prefix}end", (buffer) =>
          try
            js = cs.compile trailing, bare: true
            s.run js, sayOutput to
          catch error
            @say to, " #{@BOLD}=#{@RESET} '#{error}'"

  name: 'Eval'
  description: 'Evaluate sandboxed code using !eval (CoffeeScript optional)'
  version: '0.1'
  authors: ['Álvaro Cuesta']
