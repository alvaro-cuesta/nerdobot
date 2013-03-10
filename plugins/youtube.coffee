request = require('request')

watchURL = (v) ->
  "http://youtu.be/#{v}"

module.exports = ({results, random, options}) ->

  results ?= 1
  random ?= false

  searchURL = (q) ->
    q = encodeURIComponent q

    if options?
      query = '&' + ("#{k}=#{v}" for k, v of options).join '&'
    else
      query = ''

    "http://gdata.youtube.com/feeds/api/videos?q=#{q}&v=2&alt=json#{query}"

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

          if not data?.feed?
            console.log data
            sendErr "ERROR: empty feed!", channel
            return

          if data.feed.openSearch$totalResults['$t'] is 0
            sendErr "No results...", channel
            return

          videos = data.feed.entry
          videos = videos.sort -> 0.5 - Math.random() if random

          sendMsg video, channel for video in videos[...results]

  name: 'Youtube Search'
  description: 'Returns the first YouTube result.'
  version: '0.5'
  authors: [
    'Tunnecino @ arrogance.es',
    'Álvaro Cuesta'
  ]
