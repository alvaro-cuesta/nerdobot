request = require('request')

module.exports = (bot, apikey) ->
  
  songURL = (query) ->
    "http://tinysong.com/b/#{query}?format=json&key=#{apikey}"
  
  banner = (message) ->
    "#{bot.color 'blue'}#{bot.BOLD}TinySong#{bot.RESET} - "

  bot.commands.on 'song', (from, message, channel) ->
    if not channel?
      bot.notice from.nick, 'That command only works in channels'
      return
    if not message?
      bot.notice from.nick, 'You should specify a search query!'
      return

    request
      url: songURL message.replace(/\s/g, '+')
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
          "(#{bot.UNDERLINE}#{artist}#{bot.RESET}) - #{url}"

  name: 'TinySong Search'
  description: 'Return the first TinySong search result.'
  version: '0.5'
  authors: [
    'Tunnecino @ arrogance.es'
  ]
