$ = require('jquery');

module.exports = (bot) ->

  bot.commands.on 'yt', (from, message, channel) ->
    if !channel
      bot.notice from.nick, 'Este comando solo funciona en un canal!'
    else
      if !message
        bot.notice from.nick, 'Debes de indicarme una búsqueda!'
      else
        msg = message.replace(/\s/g, "%22")
        $.getJSON("http://gdata.youtube.com/feeds/api/videos?q=#{msg}&orderby=relevance&max-results=1&v=2&alt=json", 
          (data) ->
            if data.feed.openSearch$totalResults['$t'] == 0
              bot.say channel, "#{bot.BOLD}You#{bot.color 'white', 'red'}Tube#{bot.RESET} - #{bot.BOLD}Sin resultados...#{bot.RESET}"
            else
              content = data.feed.entry[0]
              links = JSON.stringify(content.id['$t'])
              links = links.split ':'
              [title, link, views] = [content.title['$t'], 'http://youtube.com/watch?v='+links[3].replace('"', ''), content.yt$statistics['viewCount']]
              bot.say channel, "#{bot.BOLD}You#{bot.color 'white', 'red'}Tube#{bot.RESET} - #{bot.BOLD}#{title}#{bot.RESET} - #{link} - #{bot.UNDERLINE}#{views}#{bot.RESET} visitas"
        )

  bot.commands.on 'youtube', (from, message, channel) ->
    if !channel
      bot.notice from.nick, 'Este comando solo funciona en un canal!'
    else
      if !message
        bot.notice from.nick, 'Debes de indicarme una búsqueda!'
      else
        msg = message.replace(/\s/g, "%22")
        $.getJSON("http://gdata.youtube.com/feeds/api/videos?q=#{msg}&orderby=relevance&max-results=1&v=2&alt=json", 
          (data) ->
            if data.feed.openSearch$totalResults['$t'] == 0
              bot.say channel, "#{bot.BOLD}You#{bot.color 'white', 'red'}Tube#{bot.RESET} - #{bot.BOLD}Sin resultados...#{bot.RESET}"
            else
              content = data.feed.entry[0]
              links = JSON.stringify(content.id['$t'])
              links = links.split ':'
              [title, link, views] = [content.title['$t'], 'http://youtube.com/watch?v='+links[3].replace('"', ''), content.yt$statistics['viewCount']]
              bot.say channel, "#{bot.BOLD}You#{bot.color 'white', 'red'}Tube#{bot.RESET} - #{bot.BOLD}#{title}#{bot.RESET} - #{link} - #{bot.UNDERLINE}#{views}#{bot.RESET} visitas"
        )

  name: 'Youtube Seach'
  description: 'Devuelve el primer resultado en youtube.'
  version: '0.1'
  authors: [
    'Tunnecino @ arrogance.es',
  ]