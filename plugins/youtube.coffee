request = require('request')

module.exports = (bot) ->

  bot.commands.on 'yt', (from, message, channel) ->
    if not channel?
      bot.notice from.nick, 'Este comando solo funciona en un canal!'
    else
      if not message?
        bot.notice from.nick, 'Debes de indicarme una búsqueda!'
      else
        request {url: "http://gdata.youtube.com/feeds/api/videos?q=#{message}"+
          "&max-results=1&v=2&alt=json", json: true}, (err, res, data) ->
            if not err?
              if data.feed.openSearch$totalResults['$t'] is 0
                bot.say channel, 
                  "#{bot.BOLD}You#{bot.color 'white', 'red'}Tube#{bot.RESET}" + 
                  "- #{bot.BOLD}Sin resultados...#{bot.RESET}"
              else
                content = data.feed.entry[0]
                links = JSON.stringify(content.id['$t'])
                links = links.split ':'
                [title, link, views] = [
                  content.title['$t'], 
                  'http://youtube.com/watch?v='+links[3].replace('"', ''), 
                  content.yt$statistics['viewCount']
                ]
                bot.say channel, 
                  "#{bot.BOLD}You#{bot.color 'white', 'red'}Tube#{bot.RESET}" +
                  "- #{bot.BOLD}#{title}#{bot.RESET} - #{link} - " +
                  "#{bot.UNDERLINE}#{views}#{bot.RESET} visitas"
            else
              bot.say channel, 
                "#{bot.BOLD}You#{bot.color 'white', 'red'}Tube#{bot.RESET}" + 
                "- #{bot.BOLD}Sin conexión a YouTube#{bot.RESET}"

  bot.commands.on 'youtube', (from, message, channel) ->
    if not channel?
      bot.notice from.nick, 'Este comando solo funciona en un canal!'
    else
      if not message?
        bot.notice from.nick, 'Debes de indicarme una búsqueda!'
      else
        request {url: "http://gdata.youtube.com/feeds/api/videos?q=#{message}"+
          "&max-results=1&v=2&alt=json", json: true}, (err, res, data) ->
            if not err?
              if data.feed.openSearch$totalResults['$t'] is 0
                bot.say channel, 
                  "#{bot.BOLD}You#{bot.color 'white', 'red'}Tube#{bot.RESET}" + 
                  "- #{bot.BOLD}Sin resultados...#{bot.RESET}"
              else
                content = data.feed.entry[0]
                links = JSON.stringify(content.id['$t'])
                links = links.split ':'
                [title, link, views] = [
                  content.title['$t'], 
                  'http://youtube.com/watch?v='+links[3].replace('"', ''), 
                  content.yt$statistics['viewCount']
                ]
                bot.say channel, 
                  "#{bot.BOLD}You#{bot.color 'white', 'red'}Tube#{bot.RESET}" +
                  "- #{bot.BOLD}#{title}#{bot.RESET} - #{link} - " +
                  "#{bot.UNDERLINE}#{views}#{bot.RESET} visitas"
            else
              bot.say channel, 
                "#{bot.BOLD}You#{bot.color 'white', 'red'}Tube#{bot.RESET}" + 
                "- #{bot.BOLD}Sin conexión a YouTube#{bot.RESET}"

  name: 'Youtube Seach'
  description: 'Devuelve el primer resultado en youtube.'
  version: '0.3'
  authors: [
    'Tunnecino @ arrogance.es',
  ]