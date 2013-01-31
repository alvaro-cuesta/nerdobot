request = require 'request'

searchURL = (q) ->
  "http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=#{q}"

module.exports = (bot) ->

  banner = (message) ->
    "#{bot.BOLD}#{bot.color 'blue'}G#{bot.color 'red'}o" +
    "#{bot.color 'yellow'}o#{bot.color 'blue'}g" +
    "#{bot.color 'green'}l#{bot.color 'red'}e" +
    "#{bot.RESET} - #{message}"

  google = (postfix) -> (from, query, channel) ->
    if not channel?
      bot.notice from.nick, 'That command only works in channels'
      return

    if not query?
      bot.notice from.nick, 'You should specify a search query!'
      return

    failure = (err) ->
      bot.say channel, banner "#{bot.BOLD}#{err}#{bot.RESET}"

    request
      url: searchURL "#{query} #{postfix}"
      json: true
      (err, res, data) ->
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

        link = data.results[0].url
        title = data.results[0].title
          .replace('<b>', bot.BOLD)
          .replace('</b>', bot.BOLD)
          .replace(/<(.|\n)*?>/g, "")
        results = data.cursor.resultCount

        bot.say channel,
          banner "#{bot.UNDERLINE}#{bot.color 'blue'}#{link}#{bot.RESET}" +
            " - \"#{title}\" (#{results} results)"

  bot.addCommand 'google',
    args: '<search terms>'
    aliases: ['g']
    description: 'Google Search'
    google ''

  bot.addCommand 'wiki',
    args: '<search terms>',
    aliases: ['w']
    description: 'Wikipedia Search'
    google 'site:en.wikipedia.org'

  name: 'Google Search'
  description: 'Returns the first Google result.'
  version: '0.1'
  authors: ['Álvaro Cuesta']
