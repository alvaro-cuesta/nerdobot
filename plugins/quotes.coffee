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
        timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL);"
      bot.commands.on 'addquote', (from, message, to) ->
        if to?
          end = message.indexOf ' '
          nick = message.slice 0, end
          quote = message.slice end + 1

          db.run(
            "INSERT INTO quotes (channel, nick, quote) VALUES ($channel, $nick, $quote);",
            $channel: to
            $nick: nick
            $quote: quote
            , (err) ->
              if err
                bot.raw "Error inserting quote: #{err}", to
              else
                bot.say "Quote #{this.lastID} inserted!", to)
        else
          bot.notice "That will only work in channels, idiot...", from.nick

     bot.commands.on 'quote', (from, message, to) ->
      if to? and to != ''
        db.get "SELECT * FROM quotes WHERE channel = ? ORDER BY RANDOM() LIMIT 1;",
          to,
          (err, row) ->
            if err
              bot.say "Error selecting quote: #{err}", to
            else
              bot.say "#{row.timestamp} | #{row.nick}: #{row.quote}", to
      else
        if message? and message != ''
          db.get "SELECT * FROM quotes WHERE channel = ? ORDER BY RANDOM() LIMIT 1;",
            message.split(' ')[0],
            (err, row) ->
              if err
                bot.say "Error selecting quote: #{err}", from.nick
              else
                bot.say "#{row.timestamp} | #{row.nick}: #{row.quote}", from.nick
        else
          db.get "SELECT * FROM quotes ORDER BY RANDOM() LIMIT 1;",
            (err, row) ->
              if err
                bot.say "Error selecting quote: #{err}", from.nick
              else
                bot.say "#{row.timestamp} | #{row.nick}@#{row.channel}: #{row.quote}", from.nick
