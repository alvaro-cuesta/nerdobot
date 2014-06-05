request = require 'request'

URL = 'http://www.reddit.com/r/yogapants/.json?'

module.exports = (bot) ->
  bot.commands.on 'yoga', (from, message, channel) ->
    if not channel?
      bot.notice from, 'Yoga pants only works in a channel!'
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
          "[NSFW] #{bot.UNDERLINE}#{bot.color 'blue'}#{link}#{bot.RESET}"

  name: 'Yoga pants'
  description: 'Yoga pants are like WonderBra for asses'
  version: '1.0'
  authors: ['blzkz', 'Pirado_IV']
