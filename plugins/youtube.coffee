request = require('request')

searchURL = (q) ->
  "http://gdata.youtube.com/feeds/api/videos?q=#{q}&max-results=1&v=2&alt=json"
watchURL = (v) ->
  "http://youtube.com/watch?v=#{v}"

module.exports = (bot) ->

  banner = (message) ->
    "#{bot.BOLD}You#{bot.color 'white', 'red'}Tube#{bot.RESET} - #{message}"

  sendMsg = (content, channel) ->
    links = JSON.stringify(content.id['$t']).split ':'
    [title, link, views] = [
      content.title['$t'],
      watchURL(links[3].replace '"', ''),
      content.yt$statistics['viewCount']
    ]
    bot.say channel,
      banner "#{bot.BOLD}#{title}#{bot.RESET} - #{link} - " +
        "#{bot.UNDERLINE}#{views}#{bot.RESET} views"

  sendErr = (err, channel) ->
    bot.say channel, banner "#{bot.BOLD}#{err}#{bot.RESET}"

  bot.addCommand 'youtube',
    args: '<search terms>'
    description: 'YouTube search'
    aliases: ['yt']
    (from, query, channel) ->
      if not channel?
        bot.notice from.nick, 'That command only works in channels'
        return
      if not query?
        bot.notice from.nick, 'You should specify a search query!'
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
