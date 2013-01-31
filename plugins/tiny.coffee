request = require('request')

module.exports = (bot, apikey) ->

  songURL = (query) ->
    query = query.replace /\s/g, '+'
    "http://tinysong.com/b/#{query}?format=json&key=#{apikey}"

  banner = (message) ->
    "#{bot.color 'blue'}#{bot.BOLD}TinySong#{bot.RESET} - #{message}"

  bot.addCommand 'song',
    args: '<search terms>'
    description: 'Search TinySong (GrooveShark)'
    aliases: ['tiny']
    (from, query, channel) ->
      if not channel?
        bot.notice from.nick, 'That command only works in channels'
        return
      if not query?
        bot.notice from.nick, 'You should specify a search query!'
        return

      request
        url: songURL query
        json: true
        (err, res, data) ->
          if err?
            bot.say channel,
              banner "#{bot.BOLD}Couldn't connect...#{bot.RESET}"
            return

          if not data.SongName?
            bot.say channel,
              banner "#{bot.BOLD}No results...#{bot.RESET}"
            return

          [name, artist, url] = [data.SongName, data.ArtistName, data.Url]
          bot.say channel,
            banner "#{bot.BOLD}#{name}#{bot.RESET} " +
              "(#{bot.UNDERLINE}#{artist}#{bot.RESET}) - " +
              "#{bot.UNDERLINE}#{bot.color 'blue'}#{url}#{bot.RESET}"

  name: 'TinySong Search'
  description: 'Return the first TinySong search result.'
  version: '0.5'
  authors: [
    'Tunnecino @ arrogance.es'
  ]
