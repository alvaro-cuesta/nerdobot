request = require 'request'

URL = 'http://www.reddit.com/r/legalteens+nipples+gonewild+nsfw+nsfw_gif+tits+realgirls/.json?'

module.exports = (bot) ->
  bot.commands.on 'tits', (from, message, channel) ->
    if not channel?
      bot.notice from, 'Tits only works in a channel!'
      return

    request
      url: URL
      json: true
      (err, res, data) ->
        if err?
          bot.say channel, 'Error: '+ err
          return
        if not res.statusCode == 200
          bot.say channel, 'Error, response code: '+ res.statusCode
          return
        if not data?
          bot.say channel, 'Error: no data'
          return

        num = Math.floor Math.random() * data.data.children.length
        link = data.data.children[num].data.url
        bot.say channel,
          "#{bot.UNDERLINE}#{bot.color 'blue'}#{link}#{bot.RESET}"

  name: 'Tits'
  description: 'Tits or get the fuck out '
  version: '0.1'
  authors: ['blzkz']
  
