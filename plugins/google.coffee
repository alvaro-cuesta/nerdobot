request = require 'request'

searchURL = (q) ->
  q = encodeURIComponent q
  "http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=#{q}"

module.exports = (results) ->

  googleBanner = (message) =>
    "#{@BOLD}#{@color 'blue'}G#{@color 'red'}o" +
    "#{@color 'yellow'}o#{@color 'blue'}g" +
    "#{@color 'green'}l#{@color 'red'}e" +
    "#{@RESET}#{message}"

  wikipediaBanner = (message) =>
    "#{@BOLD}#{@color 'black'}Wikipedia#{@RESET}#{message}"

  formatResult = (result) =>

    link = decodeURIComponent result.url
    title = decodeURIComponent result.title
      .replace(/%/g, '%25')
      .replace(/<b>/g, @BOLD)
      .replace(/<\/b>/g, @BOLD)
      .replace(/<(.|\n)*?>/g, '')

    "#{@UNDERLINE}#{@color 'blue'}#{link}#{@RESET} - \"#{title}\""

  google = (postfix, banner = googleBanner) => (from, query, channel) =>
    if not channel?
      @notice from.nick, 'That command only works in channels'
      return

    if not query?
      @notice from.nick, 'You should specify a search query!'
      return

    failure = (err) =>
      @say channel, banner " - #{@BOLD}#{err}#{@RESET}"

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

        if not data.results.length
          failure 'No results...'
          return

        res = data.results
        count = data.cursor.resultCount

        if results > 1
          @say channel,
            banner " #{@BOLD}Search#{@RESET} - #{count} results"
          @say channel, formatResult result for result in res[...results]
        else
          @say channel, banner " - #{formatResult res[0]} (#{count} results)"

  @addCommand 'google',
    args: '<search terms>'
    description: 'Google Search'
    google '', googleBanner

  @addCommand 'wikipedia',
    args: '<search terms>',
    description: 'Wikipedia Search'
    google 'site:en.wikipedia.org', wikipediaBanner

  name: 'Google Search'
  description: 'Returns the first Google result.'
  version: '0.2'
  authors: ['Álvaro Cuesta']
