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
        vars = {
          title: item['title']
          link: "http://isohunt.com/download/#{item['guid']}/file.torrent"
          size: item['size']
          seeds: item['Seeds']
          leechers: item['leechers']
        }

        doURL vars.link, vars, channel

    doURL = (link, vars) ->
      request
        url: "http://ou.gd/api.php?format=json&action=shorturl&url=#{link}"
        json: true
        , (err, res, data) ->
            if err?
              cb = link
            if not data?
              cb = link
            else if data['status'] isnt 'success'
              cb = link
            else
              cb = data['shorturl']

            title = vars['title'].replace /<(.|\n)*?>/g, ""
            bot.say channel,
              "\"#{title}\" - #{cb} " +
              "(#{vars['size']}) Ratio:#{bot.BOLD}" +
              "#{bot.color 'green'} #{vars['seeds']}#{bot.RESET}#{bot.BOLD} /" +
              "#{bot.color 'red'} #{vars['leechers']}#{bot.RESET}"

    sendErr = (err) ->
      bot.say channel, 
        "#{bot.BOLD}#{bot.color 'blue'}ISOHunt Torrent Search #{bot.RESET}" +
        "- #{bot.BOLD}#{err}#{bot.RESET}"

  bot.commands.on 'torrent', search
  bot.commands.on 't', search
  bot.commands.on 'isohunt', search

  name: 'ISOHunt Search'
  description: 'Devuelve los tres primeros resultados de ISOHunt.'
  version: '0.1'
  authors: [
    'Tunnecino @ arrogance.es',
  ]