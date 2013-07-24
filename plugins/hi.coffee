module.exports = (greetings) ->
  join_cb = (who, channel) =>
      if who.nick == @nick
        rand = Math.floor Math.random() * greetings.length
        greetings[rand].apply this, [channel]

  @events.on 'join', join_cb

  unload: =>
    @events.removeListener 'join', join_cb
  name: 'Hi'
  description: 'Greets randomly upon joining any channel'
  version: '0.1'
  authors: ['Álvaro Cuesta']
