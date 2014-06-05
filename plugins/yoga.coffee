request = require 'request'

URL = 'http://www.reddit.com/r/yogapants/.json?'

module.exports = ->
  @addCommand 'yoga',
    description: 'Yoga pants are like WonderBra for asses',
    help: 'Search is done in yogapants'
    (from, message, channel) =>
      if not channel?
        @notice from, 'Yoga pants only works in a channel!'
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

  name: 'Yoga pants'
  description: 'Yoga pants are like WonderBra for asses'
  version: '1.0'
  authors: ['blzkz', 'Pirado_IV', 'Tunnecino @ ignitae.com']
