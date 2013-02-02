request = require('request')

searchURL = (q) ->
  q = encodeURIComponent q
  "http://gdata.youtube.com/feeds/api/videos?q=#{q}&max-results=1&v=2&alt=json"
watchURL = (v) ->
  "http://youtu.be/#{v}"

module.exports = ->

  banner = (message) =>
    "#{@BOLD}You#{@color 'white', 'red'}Tube#{@RESET} - #{message}"

  sendMsg = (content, channel) =>
    links = JSON.stringify(content.id['$t']).split ':'
    [title, link, views] = [
      content.title['$t'],
      watchURL(links[3].replace '"', ''),
      content.yt$statistics['viewCount']
    ]
    @say channel,
      banner "#{@BOLD}#{title}#{@RESET} - " +
        "#{@UNDERLINE}#{@color 'blue'}#{link}#{@RESET} - " +
        "#{@UNDERLINE}#{views}#{@RESET} views"

  sendErr = (err, channel) =>
    @say channel, banner "#{@BOLD}#{err}#{@RESET}"

  @addCommand 'youtube',
    args: '<search terms>'
    description: 'YouTube search'
    aliases: ['yt']
    (from, query, channel) =>
      if not channel?
        @notice from.nick, 'That command only works in channels'
        return
      if not query?
        @notice from.nick, 'You should specify a search query!'
        return

      request
        url: searchURL query
        json: true
        (err, res, data) ->
          if err?
            sendErr "Couldn't connect...", channel
            return

          if data.feed.openSearch$totalResults['$t'] is 0
            sendErr "No results...", channel
            return

          sendMsg data.feed.entry[0], channel

  name: 'Youtube Search'
  description: 'Returns the first YouTube result.'
  version: '0.4'
  authors: [
    'Tunnecino @ arrogance.es'
  ]
