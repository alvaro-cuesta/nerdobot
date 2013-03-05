request = require 'request'

URL = 'http://www.reddit.com/r/tgirls/.json?'

module.exports = ->
  @addCommand 'dicks',
    description: 'Return random shemale picture from Reddit',
    help: 'Search is done in tgirls'
    (from, message, channel) =>
      if not channel?
        @notice from, 'Dicks only works in a channel!'
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

  name: 'Dicks'
  description: 'Dicks for BH99s happiness '
  version: '0.0.1'
  authors: ['blzkz & MVDeveloper']
