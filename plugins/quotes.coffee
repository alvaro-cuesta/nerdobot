sqlite3 = require('sqlite3')

module.exports = (bot) ->
  db = new sqlite3.cached.Database bot.config.db, (err) ->
    if err
      console.log "Error opening #{bot.config.db}: #{err}"
      console.log "Disabling quote system!"
    else
      db.run "CREATE TABLE IF NOT EXISTS quotes (
        channel VARCHAR NOT NULL,
        nick VARCHAR NOT NULL,
        quote VARCHAR NOT NULL,
        by VARCHAR NOT NULL,
        timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL);"
      bot.commands.on 'addquote', (from, message, to) ->
        if not message?
          bot.notice "Tell me the quote, moron!", from.nick
          return

        if not to?
          bot.notice "That will only work in channels, idiot...", from.nick
          return

        end = message.indexOf ' '
        nick = message[0..end]
        quote = message[end+1..]

        if not nick? or nick == ''
          bot.notice "Tell me the quote, moron!", from.nick
          return

        if end <= 0 or not quote? or quote == ''
          bot.notice "So... what did #{nick} say?", from.nick
          return

        db.run(
          "INSERT INTO quotes (channel, nick, quote, by)
           VALUES ($channel, $nick, $quote, $by);",
          $channel: to
          $nick: nick
          $quote: quote
          $by: from.nick
          , (err) ->
            if err
              bot.say "\x02Error inserting quote:\x0f #{err}", to
            else
              bot.say "Quote inserted! \x02(#{this.lastID})\x0f", to)

      bot.commands.on 'quote', (from, message, to) ->
        fields = [
          'rowid',
          'nick',
          'quote',
          'by',
          "strftime('%Y-%m-%d %H:%M', timestamp, 'localtime') as timestamp"]

        if to? and to != ''
          whereClause = "WHERE channel = '#{to}'"
          replyTo = to
        else
          replyTo = from.nick
          if message? and message != ''
            whereClause = "WHERE channel = '#{message.split(' ')[0]}'"
          else
            whereClause = ''
            fields.unshift 'channel'

        db.get(
          "SELECT #{fields.join ', '} FROM quotes #{whereClause} ORDER BY RANDOM() LIMIT 1;"
          (err, row) ->
            bot.say (if err then "Error selecting quote: #{err}" else
              "#{bot.UNDERLINE}#{row.timestamp}#{bot.RESET} - #{row.by} " +
              "#{bot.BOLD}(#{row.rowid})#{bot.RESET} | #{bot.color 'red'}#{row.nick}" +
              if row.channel? then "#@{row.channel}" else '' +
              "#{bot.RESET}: #{row.quote}")
              , replyTo)
