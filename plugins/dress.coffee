request = require 'request'

URL = 'http://www.reddit.com/r/littleblackdress+tightdresses.json?'

module.exports = ->
  @addCommand 'dress',
    description: 'Return random sexy dress picture from Reddit',
    help: 'Search is done in littleblackdress and tightdresses'
    (from, message, channel) =>
      if not channel?
        @notice from, 'Dress only works in a channel!'
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

  name: 'Dress'
  description: 'Nice dresses '
  version: '0.1'
  authors: ['Foxandxss']