request = require('request')

module.exports = (bot) ->

  search = (from, message, channel) ->
    if not channel?
      bot.notice from.nick, 'Este comando solo funciona en un canal!'
      return
    if not message?
      bot.notice from.nick, 'Debes de indicarme una búsqueda!'
      return

    msg = message.replace /\s/g, "+"
    request 
      url: "http://ca.isohunt.com/js/json.php?ihq=#{msg}&rows=3&sort=seeds"
      json: true
      , (err, res, data) ->
        if err?
          sendErr "Sin conexión a ISOHunt..."
          return

        if not data.items?
          sendErr "Sin resultados..."
          return

        sendMsg data, message

    sendMsg = (data, message) ->
      bot.say channel, 
        "#{bot.BOLD}#{bot.color 'blue'}ISOHunt Torrent Search #{bot.RESET}" +
        "- #{bot.BOLD}#{message}#{bot.RESET} - los 3 resultados con mas seeds"
      for item in data.items.list
        doURL "http://isohunt.com/download/#{item['guid']}/file.torrent", item

    doURL = (link, item) ->
      request
        url: "http://ou.gd/api.php?format=json&action=shorturl&url=#{link}"
        json: true
        , (err, res, data) ->
          if err?
            enl = link
          if not data?
            enl = link
          else if data['status'] isnt 'success'
            enl = link
          else
            enl = data['shorturl']

          title = item['title'].replace /<(.|\n)*?>/g, ""
          bot.say channel,
            "\"#{title}\" - #{enl} " +
            "(#{item['size']}) Ratio:#{bot.BOLD}" +
            "#{bot.color 'green'} #{item['Seeds']}#{bot.RESET}#{bot.BOLD} /" +
            "#{bot.color 'red'} #{item['leechers']}#{bot.RESET}"

    sendErr = (err) ->
      bot.say channel, 
        "#{bot.BOLD}#{bot.color 'blue'}ISOHunt Torrent Search #{bot.RESET}" +
        "- #{bot.BOLD}#{err}#{bot.RESET}"

  bot.commands.on 'torrent', search
  bot.commands.on 't', search
  bot.commands.on 'isohunt', search

  name: 'ISOHunt Search'
  description: 'Devuelve los tres primeros resultados de ISOHunt. ' +
    'API IsoHunt: http://ca.isohunt.com/forum/viewtopic.php?p=433527#433527 ' +
    'API ou.gd: http://ou.gd/pages/api.php'
  version: '0.2'
  authors: [
    'Tunnecino @ arrogance.es',
  ]
