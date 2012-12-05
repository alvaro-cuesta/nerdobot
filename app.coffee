Bot = require('./lib/bot').Bot
config = require('./config')

bot = new Bot(config)

bot.events.on 'connected', () ->
  console.log 'Connected'

bot.events.on 'end', () ->
  console.log 'Disconnected'

#bot.events.on 'parsed', (message) ->
#  console.log message

bot.events.on 'private', (from, message) ->
  console.log "#{from}: #{message}"

bot.events.on 'channel', (from, message, channel) ->
  console.log "#{from}@#{channel}: #{message}"

bot.commands.on 'say', (from, message, to) ->
  if message? and message != ''
    end = message.indexOf ' '
    to = message.slice 0, end
    message = message.slice end + 1
    if to? and to != '' and message? and message != ''
      bot.raw "PRIVMSG #{to} :#{message}"
    else
      bot.raw "NOTICE #{from.nick} :Say what?"
  else
    bot.raw "NOTICE #{from.nick} :Say what?"

bot.commands.on 'raw', (from, command, to) ->
  if command? and command != ''
    bot.raw command
  else
    bot.raw "NOTICE #{from.nick} :What should I do?"

sqlite3 = require('sqlite3')
db = new sqlite3.cached.Database config.db, (err) ->
  if err
    console.log "Error opening #{config.db}: #{err}"
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
              bot.raw "PRIVMSG #{to} :Error inserting quote: #{err}"
            else
              bot.raw "PRIVMSG #{to} :Quote #{this.lastID} inserted!")
      else
        bot.raw "NOTICE #{from.nick} :That will only work in channels, idiot..."

   bot.commands.on 'quote', (from, message, to) ->
    if to? and to != ''
      db.get "SELECT * FROM quotes WHERE channel = ? ORDER BY RANDOM() LIMIT 1;",
        to,
        (err, row) ->
          if err
            bot.raw "PRIVMSG #{to} :Error selecting quote: #{err}"
          else
            bot.raw "PRIVMSG #{to} :#{row.timestamp} | #{row.nick}: #{row.quote}"
    else
      if message? and message != ''
        db.get "SELECT * FROM quotes WHERE channel = ? ORDER BY RANDOM() LIMIT 1;",
          message.split(' ')[0],
          (err, row) ->
            if err
              bot.raw "PRIVMSG #{from.nick} :Error selecting quote: #{err}"
            else
              bot.raw "PRIVMSG #{from.nick} :#{row.timestamp} | #{row.nick}: #{row.quote}"
      else
        db.get "SELECT * FROM quotes ORDER BY RANDOM() LIMIT 1;",
          (err, row) ->
            console.log row
            if err
              bot.raw "PRIVMSG #{from.nick} :Error selecting quote: #{err}"
            else
              bot.raw "PRIVMSG #{from.nick} :#{row.timestamp} | #{row.nick}@#{row.channel}: #{row.quote}"

bot.connect()
