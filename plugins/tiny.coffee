request = require('request')

module.exports = (bot, apikey) ->

  bot.commands.on 'song', (from, message, channel) ->
    if not channel?
      bot.notice from.nick, 'Este comando solo funciona en un canal!'
    else
      if not message?
        bot.notice from.nick, 'Debes de indicarme una búsqueda!'
      else
        msg = message.replace /\s/g, "+"
        request {url: "http://tinysong.com/b/#{msg}?format=json&key=#{apikey}"
          , json: true}, (err, res, data) ->
            if not err?
              if data.SongName?
                [name, artist, url] = [data.SongName, data.ArtistName, data.Url]
                bot.say channel,
                  "#{bot.color 'blue'}#{bot.BOLD}TinySong" +
                  "#{bot.RESET} - #{bot.BOLD}#{name}#{bot.RESET} " +
                  "(#{bot.UNDERLINE}#{artist}#{bot.RESET}) - #{url}"
              else
                bot.say channel, 
                  "#{bot.color 'blue'}#{bot.BOLD}TinySong" +
                  "#{bot.RESET} - #{bot.BOLD}Sin resultados...#{bot.RESET}"
            else
              bot.say channel, 
                "#{bot.color 'blue'}#{bot.BOLD}TinySong" +
                "#{bot.RESET} - #{bot.BOLD}Sin conexión a TinySong#{bot.RESET}"

  name: 'TinySong Search'
  description: 'Devuelve el primer resultado de búsqueda en Tiny Song.'
  version: '0.3'
  authors: [
    'Tunnecino @ arrogance.es',
  ]