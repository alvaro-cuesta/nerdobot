util = require '../lib/util'

module.exports = ->
  @addCommand 'say',
    args: '<to, optional> <message>'
    description: 'Make the bot say something'
    (from, message, channel) =>
      if message? and message != ''
        if channel?
          [dest, msg] = [channel, message]
        else
          [a, b] = util.split message, ' '
          if b? and b != ''
            [dest, msg] = [a, b]
          else
            @notice from.nick, 'Say what?'
            return

        @say dest, msg
      else
        @notice from.nick, 'Say what?'

  @addCommand 'nick',
    args: '<list of nicks>'
    description: "Change the bot's nickname, trying nicks on <list> one by one"
    ({nick}, message, to) =>
      to ?= nick
      if message? and message != ''
        @setNick message.split(' '), (err) =>
          @say to, "#{@color 'red'}#{@BOLD}ERROR:#{@RESET} #{err}" if err

  name: 'IRC'
  description: 'Generic IRC commands'
  version: '0.2'
  authors: ['Álvaro Cuesta']
