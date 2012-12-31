request = require('request')

module.exports = (bot) ->

  sendMsg = (content, channel) ->
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

  sendErr = (err, channel) ->
    bot.say channel, 
      "#{bot.BOLD}You#{bot.color 'white', 'red'}Tube#{bot.RESET}" + 
      "- #{bot.BOLD}#{err}#{bot.RESET}"

  bot.commands.on 'yt', (from, message, channel) ->
    if err?
      return
    if not channel?
      bot.notice from.nick, 'Este comando solo funciona en un canal!'
      return
    if not message?
      bot.notice from.nick, 'Debes de indicarme una búsqueda!'
      return

    request 
      url: "http://gdata.youtube.com/feeds/api/videos?q=#{message}"+
        "&max-results=1&v=2&alt=json"
      json: true
    , (err, res, data) ->
        if err?
          sendErr "Sin conexión a Youtube...", channel
          return

        if data.feed.openSearch$totalResults['$t'] is 0
          sendErr "Sin resultados...", channel
          return

        sendMsg data.feed.entry[0], channel

  bot.commands.on 'youtube', (from, message, channel) ->
    if err?
      return
    if not channel?
      bot.notice from.nick, 'Este comando solo funciona en un canal!'
      return
    if not message?
      bot.notice from.nick, 'Debes de indicarme una búsqueda!'
      return

    request 
      url: "http://gdata.youtube.com/feeds/api/videos?q=#{message}"+
      "&max-results=1&v=2&alt=json"
      json: true
    , (err, res, data) ->
        if err?
          sendErr "Sin conexión a Youtube...", channel
          return

        if data.feed.openSearch$totalResults['$t'] is 0
          sendErr "Sin resultados...", channel
          return

        sendMsg data.feed.entry[0], channel

  name: 'Youtube Seach'
  description: 'Devuelve el primer resultado en youtube.'
  version: '0.4'
  authors: [
    'Tunnecino @ arrogance.es',
  ]