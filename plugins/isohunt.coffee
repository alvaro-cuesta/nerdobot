# API IsoHunt: http://ca.isohunt.com/forum/viewtopic.php?p=433527#433527
# API ou.gd: http://ou.gd/pages/api.php

request = require('request')

fileURL = (guid) ->
  "http://isohunt.com/download/#{guid}/file.torrent"
shortenURL = (url) ->
  url = encodeURIComponent q
  "http://ou.gd/api.php?format=json&action=shorturl&url=#{url}"

module.exports = ({results, shorten}) ->

  results ?= 3

  searchURL = (q) ->
    q = encodeURIComponent q
    "http://ca.isohunt.com/js/json.php?ihq=#{q}&rows=#{results}&sort=seeds"

  banner = (message) =>
    "#{@BOLD}#{@color 'blue'}ISOHunt Torrent Search#{@RESET} - #{message}"

  itemBanner = (item, link) =>
    title = item['title'].replace /<(.|\n)*?>/g, ""
    "\"#{title}\" - #{@UNDERLINE}#{@color 'blue'}#{link}" +
    "#{@RESET} (#{item['size']}) Ratio:#{@BOLD}" +
    "#{@color 'green'} #{item['Seeds']}#{@RESET}#{@BOLD} /" +
    "#{@color 'red'} #{item['leechers']}#{@RESET}"

  @addCommand 'isohunt',
    args: '<search terms>'
    description: 'Search torrents in ISOHunt'
    (from, query, channel) =>
      if not channel?
        @notice from.nick, 'That command only works in channels'
        return

      if not query?
        @notice from.nick, 'You should specify a search query!'
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

              @say channel, itemBanner(item, link)
        else
          @say channel, itemBanner(item, link)

      failure = (err) =>
        @say channel, banner "#{@BOLD}#{err}#{@RESET}"

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

          @say channel,
            banner "#{@BOLD}#{query}#{@RESET} - top seeded results (up to #{rows})"
          doURL item for item in data.items.list

  name: 'ISOHunt Search'
  description: "Returns ISOHunt's top results."
  version: '0.3'
  authors: [
    'Tunnecino @ arrogance.es'
  ]
