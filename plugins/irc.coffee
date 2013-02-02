util = require '../lib/util'

module.exports = ->
  @addCommand 'say',
    args: '<to, optional> <message>'
    description: 'Make the bot say something'
    (from, message, channel) =>
      if message?
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

  @addCommand 'asay',
    args: '<message>'
    description: 'Make the bot say something in all channels'
    (from, message, channel) =>
      if message?
        @say message
      else
        @notice from.nick, 'Say what?'

  @addCommand 'me',
    args: '<to, optional> <message>'
    description: 'Make the bot do something'
    (from, message, channel) =>
      if message?
        if channel?
          [dest, msg] = [channel, message]
        else
          [a, b] = util.split message, ' '
          if b? and b != ''
            [dest, msg] = [a, b]
          else
            @notice from.nick, 'Do what?'
            return
        @me dest, msg
      else
        @notice from.nick, 'Do what?'

  @addCommand 'ame',
    args: '<message>'
    description: 'Make the bot do something in all channels'
    (from, message, channel) =>
      if message?
        @me message
      else
        @notice from.nick, 'Do what?'

  @addCommand 'nick',
    args: '<list of nicks>'
    description: "Change the bot's nickname, trying nicks on <list> one by one"
    ({nick}, message, to) =>
      to ?= nick
      if message?
        @setNick message.split(' '), (err) =>
          @say to, "#{@color 'red'}#{@BOLD}ERROR:#{@RESET} #{err}" if err

  name: 'IRC'
  description: 'Generic IRC commands'
  version: '0.2'
  authors: ['Álvaro Cuesta']
