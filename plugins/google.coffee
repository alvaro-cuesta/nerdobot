request = require 'request'

searchURL = (q) ->
  q = encodeURIComponent q
  "http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=#{q}"

module.exports = ->

  banner = (message) =>
    "#{@BOLD}#{@color 'blue'}G#{@color 'red'}o" +
    "#{@color 'yellow'}o#{@color 'blue'}g" +
    "#{@color 'green'}l#{@color 'red'}e" +
    "#{@RESET} - #{message}"

  google = (postfix) => (from, query, channel) =>
    if not channel?
      @notice from.nick, 'That command only works in channels'
      return

    if not query?
      @notice from.nick, 'You should specify a search query!'
      return

    failure = (err) =>
      @say channel, banner "#{@BOLD}#{err}#{@RESET}"

    request
      url: searchURL "#{query} #{postfix}"
      json: true
      (err, res, data) =>
        if err?
          failure "Couldn't connect..."
          return

        if not data.responseStatus? or data.responseStatus != 200
          failure 'Bad response!'
          return

        data = data.responseData

        if not data.results.length > 0
          failure 'No results...'
          return

        link = decodeURIComponent data.results[0].url
        title = decodeURIComponent data.results[0].title
          .replace('<b>', @BOLD)
          .replace('</b>', @BOLD)
          .replace(/<(.|\n)*?>/g, "")
        results = data.cursor.resultCount

        @say channel,
          banner "#{@UNDERLINE}#{@color 'blue'}#{link}#{@RESET}" +
            " - \"#{title}\" (#{results} results)"

  @addCommand 'google',
    args: '<search terms>'
    aliases: ['g']
    description: 'Google Search'
    google ''

  @addCommand 'wiki',
    args: '<search terms>',
    aliases: ['w']
    description: 'Wikipedia Search'
    google 'site:en.wikipedia.org'

  name: 'Google Search'
  description: 'Returns the first Google result.'
  version: '0.1'
  authors: ['Álvaro Cuesta']
