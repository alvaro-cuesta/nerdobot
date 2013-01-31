module.exports = (greetings) ->

  @events.on 'join', (who, channel) ->
    if who.nick == @nick
      sayFn = greetings[Math.floor(Math.random() * greetings.length)]
      sayFn channel

  name: 'Hi'
  description: 'Greets randomly upon joining any channel'
  version: '0.1'
  authors: ['Álvaro Cuesta']
