module.exports = (greetings) ->

  @events.on 'join', (who, channel) =>
    if who.nick == @nick
      rand = Math.floor Math.random() * greetings.length
      greetings[rand].apply this, [channel]

  name: 'Hi'
  description: 'Greets randomly upon joining any channel'
  version: '0.1'
  authors: ['Álvaro Cuesta']
