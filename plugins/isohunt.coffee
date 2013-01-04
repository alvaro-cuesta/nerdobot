# API IsoHunt: http://ca.isohunt.com/forum/viewtopic.php?p=433527#433527
# API ou.gd: http://ou.gd/pages/api.php

request = require('request')

ROWS = 3 # number of results to return from ISOHunt query

isoSearchURL = (ihq) ->
  "http://ca.isohunt.com/js/json.php?ihq=#{ihq}&rows=#{ROWS}&sort=seeds"
isoFileURL = (guid) ->
  "http://isohunt.com/download/#{guid}/file.torrent"
shortenURL = (url) ->
  "http://ou.gd/api.php?format=json&action=shorturl&url=#{url}"
banner = (message) ->
  "#{bot.BOLD}#{bot.color 'blue'}ISOHunt Torrent Search#{bot.RESET}" +
  " - #{message}"
itemBanner = (item, link) ->
  title = item['title'].replace /<(.|\n)*?>/g, ""
  "\"#{title}\" - #{link} " +
  "(#{item['size']}) Ratio:#{bot.BOLD}" +
  "#{bot.color 'green'} #{item['Seeds']}#{bot.RESET}#{bot.BOLD} /" +
  "#{bot.color 'red'} #{item['leechers']}#{bot.RESET}"
              
module.exports = (bot, shorten) ->

  search = (from, message, channel) ->
    if not channel?
      bot.notice from.nick, 'That command only works in channels'
      return
    if not message?
      bot.notice from.nick, 'You should specify a search query!'
      return

    request 
      url: isoSearchURL message.replace(/\s/g, "+")
      json: true
      , (err, res, data) ->
        if err?
          sendErr "Couldn't connect..."
          return

        if not data.items?
          sendErr "No results..."
          return

        sendMsg data, message

    sendMsg = (data, message) ->
      bot.say channel, 
        banner "#{bot.BOLD}#{message}#{bot.RESET} - top #{ROWS} seeded results"
      doURL item for item in data.items.list

    doURL = (item) ->
      link = isoFileURL item.guid
      if shorten
        request
          url: shortenURL link
          json: true
          , (err, res, data) ->
            if not err? and data? and data['status'] is 'success'
              link = data['shorturl']

            bot.say channel, itemBanner(item, link)
      else
        bot.say channel, itemBanner(item, link)

    sendErr = (err) ->
      bot.say channel, 
        banner "#{bot.BOLD}#{err}#{bot.RESET}"

  bot.commands.on 'torrent', search
  bot.commands.on 't', search
  bot.commands.on 'isohunt', search

  name: 'ISOHunt Search'
  description: "Returns ISOHunt's top results."
  version: '0.3'
  authors: [
    'Tunnecino @ arrogance.es',
  ]
