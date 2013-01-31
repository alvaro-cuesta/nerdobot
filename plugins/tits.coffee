request = require 'request'

URL = 'http://www.reddit.com/r/legalteens+nipples+gonewild+nsfw+nsfw_gif+tits+realgirls/.json?'

module.exports = ->
  @addCommand 'tits',
    description: 'Return random tit picture from Reddit',
    help: 'Search is done in legalteens, nipples, gonewild, nsfw, nsfw_gif, tits, realgirls'
    (from, message, channel) =>
      if not channel?
        @notice from, 'Tits only works in a channel!'
        return

      request
        url: URL
        json: true
        (err, res, data) =>
          if err?
            @say channel, 'Error: '+ err
            return
          if not res.statusCode == 200
            @say channel, 'Error, response code: '+ res.statusCode
            return
          if not data?
            @say channel, 'Error: no data'
            return

          num = Math.floor Math.random() * data.data.children.length
          link = data.data.children[num].data.url
          @say channel,
            "#{@UNDERLINE}#{@color 'blue'}#{link}#{@RESET}"

  name: 'Tits'
  description: 'Tits or get the fuck out '
  version: '0.1'
  authors: ['blzkz']
