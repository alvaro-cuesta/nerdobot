crypto = require 'crypto'

module.exports = (bot, config) ->
  {nick, user, host} = config.service

  if config.pass?
    console.log "[Q] WARNING! Your password is stored as plaintext in your config file"
    console.log "[Q]          Please, consider storing it SHA-1 hashed as key 'hash'."

  # Ask for challeng when welcome to IRC server
  bot.events.on 'welcome', ->
    bot.say "#{nick}@#{host}", 'CHALLENGE'

  # Check for challenge responses
  bot.events.on 'notice', (who, notice, to) ->
    # Only parse service messages
    if who? and to == bot.nick and who.nick == nick and who.user == user and who.host == host
      split = notice.split ' '

      # Challenge arrived
      if split[0] == 'CHALLENGE'
          [challenge, algorithms...] = split[1..]
          if 'HMAC-SHA-1' in algorithms
            passHash = config.hash
            passHash ?= crypto.createHash('sha1').update(config.pass).digest('hex')
            userLow = config.user.toLowerCase()

            k = crypto.createHash('sha1').update("#{userLow}:#{passHash}").digest('hex')
            response = crypto.createHmac('sha1', k).update(challenge).digest('hex')

            bot.say "#{nick}@#{host}", "CHALLENGEAUTH #{config.user} #{response} HMAC-SHA-1"
          else
            console.log "[Q] None of the algorithms is supported: #{algorithms.join ', '}"

      # Challenge accepted, set mode +x (hidden host)
      else if notice == "You are now logged in as #{config.user}."
        bot.raw "MODE #{bot.nick} +x"

  # Mode +x set = hidden host --- join channels
  bot.server.on '396', (from, params, trailing) ->
    if trailing == 'is now your hidden host'
        bot.join channel for channel in config.channels

  name: 'Q'
  description: 'Q authentication using CHALLENGEAUTH'
  version: '0.1'
  authors: ['Álvaro Cuesta']
