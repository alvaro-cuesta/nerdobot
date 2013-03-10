request = require('request')

module.exports = (apikey) ->

  songURL = (query) ->
    query = encodeURIComponent query
    "http://tinysong.com/b/#{query}?format=json&key=#{apikey}"

  banner = (message) =>
    "#{@color 'blue'}#{@BOLD}TinySong#{@RESET} - #{message}"

  @addCommand 'tinysong',
    args: '<search terms>'
    description: 'Search TinySong (GrooveShark)'
    (from, query, channel) =>
      if not channel?
        @notice from.nick, 'That command only works in channels'
        return
      if not query?
        @notice from.nick, 'You should specify a search query!'
        return

      request
        url: songURL query
        json: true
        (err, res, data) =>
          if err?
            @say channel,
              banner "#{@BOLD}Couldn't connect...#{@RESET}"
            return

          if not data.SongName?
            @say channel,
              banner "#{@BOLD}No results...#{@RESET}"
            return

          [name, artist, url] = [data.SongName, data.ArtistName, data.Url]
          @say channel,
            banner "#{@BOLD}#{name}#{@RESET} " +
              "(#{@UNDERLINE}#{artist}#{@RESET}) - " +
              "#{@UNDERLINE}#{@color 'blue'}#{url}#{@RESET}"

  name: 'TinySong Search'
  description: 'Return the first TinySong search result.'
  version: '0.5'
  authors: [
    'Tunnecino @ arrogance.es'
  ]
