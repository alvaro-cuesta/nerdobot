apikey = ''
$ = require('jquery');

module.exports = (bot) ->

  bot.commands.on 'song', (from, message, channel) ->
    if !channel
      bot.notice from.nick, 'Este comando solo funciona en un canal!'
    else
      if !message
        bot.notice from.nick, 'Debes de indicarme una búsqueda!'
      else
        msg = message.replace(" ", "+")
        $.getJSON("http://tinysong.com/b/#{msg}?format=json&key=#{apikey}", 
          (data) ->
            if(data.SongName)
              [name, artist, url] = [data.SongName, data.ArtistName, data.Url]
              bot.say channel, "#{bot.color 'blue'}#{bot.BOLD}TinySong#{bot.RESET} - #{bot.BOLD}#{name}#{bot.RESET} (#{bot.UNDERLINE}#{artist}#{bot.RESET}) - #{url}"
            else
              bot.say channel, "#{bot.color 'blue'}#{bot.BOLD}TinySong#{bot.RESET} - #{bot.BOLD}Sin resultados...#{bot.RESET}"
        )

  name: 'TinySong Search'
  description: 'Devuelve el primer resultado de búsqueda en Tiny Song.'
  version: '0.1'
  authors: [
    'Tunnecino @ arrogance.es',
  ]