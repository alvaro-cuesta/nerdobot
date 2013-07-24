util = require '../lib/util'
sqlite3 = require('sqlite3')
clc = require 'cli-color'

isInt = (n) ->
  !isNaN(parseInt(n)) and isFinite(n)

module.exports = (file) ->
  db = new sqlite3.cached.Database file, (err) =>
    if err
      console.log clc.redBright "Error opening deatbase #{file}: #{err}"
      console.log clc.yellowBright "Disabling quote system!"
      return

    # Initialize DB tables if not present
    db.run "CREATE TABLE IF NOT EXISTS quotes (
      channel VARCHAR NOT NULL,
      nick VARCHAR NOT NULL,
      quote VARCHAR NOT NULL,
      by VARCHAR NOT NULL,
      timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL);"

    # Index quotes by channel
    db.run "CREATE INDEX IF NOT EXISTS qchannel on quotes (channel)"

    # COMMAND !addquote <quote>
    #  only works in channels
    @addCommand 'addquote',
      args: '<nick> <quote>'
      description: 'Add a quote'
      (from, message, channel) =>
        if not channel?
          @notice from.nick, "That will only work in channels, idiot..."
          return

        if not message?
          @notice from.nick, "Tell me the quote, moron!"
          return

        [nick, quote] = util.split message, ' '

        if not nick? or nick == ''
          @notice from.nick, "Tell me the quote, moron!"
          return

        if not quote? or quote == ''
          @notice from.nick, "So... what did #{nick} say?"
          return

        bot = this
        db.run "INSERT INTO quotes (channel, nick, quote, by)
           VALUES ($channel, $nick, $quote, $by);",
          $channel: channel
          $nick: nick
          $quote: quote
          $by: from.nick
        , (err) ->
          if err
            bot.say channel, "\x02Error inserting quote:\x0f #{err}"
          else
            bot.say channel, "Quote inserted! \x02(#{@lastID})\x0f"

    # SELECT string of fields for !quote
    FIELDS = [
      'rowid',
      'channel',
      'nick',
      'quote',
      'by',
      "strftime('%Y-%m-%d %H:%M', timestamp, 'localtime') as timestamp"]
      .join ', '

    quote_cb = (to, chn) =>
      (err, row) =>
        if err
          @say to, "Error selecting quote: #{err}"
          return

        if not row?
          @say to, 'Quote not found'
          return

        @say to,
          "#{@UNDERLINE}#{row.timestamp}#{@RESET} - #{row.by} " +
          "#{@BOLD}(#{row.rowid})#{@RESET} | #{@color 'red'}#{row.nick}" +
          (if not (chn? or chn == replyTo) then "@#{row.channel}" else '') +
          "#{@RESET}: #{row.quote}"

    # COMMAND !quote <channel> <number> (both optional)
    @addCommand 'quote',
      args: '<channel, only in queries, optional> <number, optional>'
      description: 'Print quotes'
      (from, message, channel) =>
        # Parse arguments
        if message?
          args = message.split ' '
          switch args.length
            when 2
              chn = args[0]
              num = parseInt args[1]
            when 1
              arg = args[0]
              if isInt arg
                num = parseInt arg
              else
                chn = arg
            else
              return

        if channel?
          chn ?= channel
          replyTo = channel
        else
          replyTo = from.nick

        # SELECT's extra clause
        clause = ''
        if chn? or num?
          clause  = 'WHERE '
          clause += 'channel = $channel' if chn?
          if num?
            clause += ' AND ' if chn
            clause += 'rowid = $id'

        clause += ' ORDER BY RANDOM() LIMIT 1' if not num?

        db.get "SELECT #{FIELDS} FROM quotes #{clause};",
          $channel: chn
          $id: num
          , (quote_cb replyTo, chn)

    # COMMAND !searchquote <word>
    @addCommand 'searchquote',
      args: '<query>'
      description: 'Search quotes by text'
      (from, query, channel) =>
        if channel?
          chn = channel
          replyTo = channel
        else
          replyTo = from.nick

        if not query?
          @say replyTo, "Search #{@BOLD}what#{@RESET} !?"
          return

        clause = if chn? then 'AND channel = $channel' else ''

        db.get "SELECT #{FIELDS} FROM quotes WHERE quote LIKE $query #{clause} ORDER BY RANDOM() LIMIT 1",
          $channel: chn
          $query: query
          , (quote_cb replyTo, chn)

    # COMMAND !nickquote <nick>
    @addCommand 'nickquote',
      args: '<nick>'
      description: 'Search quotes by nick'
      (from, nick, channel) =>
        if channel?
          replyTo = channel
        else
          replyTo = from.nick

        nick ?= from.nick

        clause = 'WHERE nick = $nick'
        clause += ' AND channel = $channel' if channel?

        db.get "SELECT #{FIELDS} FROM quotes #{clause} ORDER BY RANDOM() LIMIT 1",
          $nick: nick
          $channel: channel
          , (quote_cb replyTo, channel)

  name: 'Quotes'
  description: 'Add and print/browse quotes'
  version: '0.2'
  authors: ['Álvaro Cuesta']
