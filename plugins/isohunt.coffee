# API IsoHunt: http://ca.isohunt.com/forum/viewtopic.php?p=433527#433527
# API ou.gd: http://ou.gd/pages/api.php

request = require('request')

ROWS = 3 # number of results to return from ISOHunt query

searchURL = (query) ->
  ihq = query.replace /\s/g, '+'
  "http://ca.isohunt.com/js/json.php?ihq=#{ihq}&rows=#{ROWS}&sort=seeds"
fileURL = (guid) ->
  "http://isohunt.com/download/#{guid}/file.torrent"
shortenURL = (url) ->
  "http://ou.gd/api.php?format=json&action=shorturl&url=#{url}"

module.exports = (bot, shorten) ->

  banner = (message) ->
    "#{bot.BOLD}#{bot.color 'blue'}ISOHunt Torrent Search#{bot.RESET}" +
    " - #{message}"

  itemBanner = (item, link) ->
    title = item['title'].replace /<(.|\n)*?>/g, ""
    "\"#{title}\" - #{link} " +
    "(#{item['size']}) Ratio:#{bot.BOLD}" +
    "#{bot.color 'green'} #{item['Seeds']}#{bot.RESET}#{bot.BOLD} /" +
    "#{bot.color 'red'} #{item['leechers']}#{bot.RESET}"

  bot.addCommand 'isohunt', ['torrent', 't'],
    'Search torrents in ISOHunt',
    'ARGS: <search terms>',
    (from, query, channel) ->
      if not channel?
        bot.notice from.nick, 'That command only works in channels'
        return

      if not query?
        bot.notice from.nick, 'You should specify a search query!'
        return

      doURL = (item) ->
        link = fileURL item.guid
        if shorten
          request
            url: shortenURL link
            json: true
            (err, res, data) ->
              if not err? and data? and data['status'] is 'success'
                link = data['shorturl']

              bot.say channel, itemBanner(item, link)
        else
          bot.say channel, itemBanner(item, link)

      failure = (err) ->
        bot.say channel, banner "#{bot.BOLD}#{err}#{bot.RESET}"

      request
        url: searchURL query
        json: true
        (err, res, data) ->
          if err?
            failure "Couldn't connect..."
            return

          if not data.items?
            failure "No results..."
            return

          bot.say channel,
            banner "#{bot.BOLD}#{query}#{bot.RESET} - top seeded results (up to #{ROWS})"
          doURL item for item in data.items.list

  name: 'ISOHunt Search'
  description: "Returns ISOHunt's top results."
  version: '0.3'
  authors: [
    'Tunnecino @ arrogance.es'
  ]
