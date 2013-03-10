module.exports = ->
  @addCommand 'raw',
    args: '<command>',
    description: 'Send a raw command to the IRC server'
    (from, command) =>
      if command?
        @raw command
      else
        @notice from.nick, "What should I do?"

  name: 'Raw'
  description: 'Send raw IRC commands to server'
  version: '0.1'
  authors: ['Álvaro Cuesta']
