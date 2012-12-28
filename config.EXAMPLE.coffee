module.exports =
  socket:
    port: 6667
    host: 'irc.quakenet.org'
    localAddress: '0.0.0.0'
  connection:
    encoding: 'utf8'
  user:
    nick: 'nerdobot'
    login: 'nerdobot'
    pass: 'password'
    realname: 'NerdoBot'
    invisible: true
    wallops: false
  admins: ['.*!.*@your.host.here'] # admin prefix (regexes)
  channels: ['#mediavida'] # channels to log upon connection (even before service auths)
  db: "/var/bot/nerdobot.sqlite3" # database file
<<<<<<< HEAD
  timeout: 3000
  plugins: [ # enabled plugins
    'quotes',
    'say',
    'raw',
    'spy',
    'hi',
    'q'
=======
  plugins:
    quotes: '/opt/nerdo/nerdobot.sqlite3'
    say: {}
    raw: {}
    debug: {}
    spy: {}
    hi: [
      (bot, channel) ->
        bot.me channel, 'says hi'
      , (bot, channel) ->
        bot.me channel, "is pleased to be in #{channel}!"
      , (bot, channel) ->
        bot.me channel, "doesn't follow the laws of robotics..."
      , (bot, channel) ->
        bot.me channel, 'is going to kill you'
      , (bot, channel) ->
        bot.say channel, 'hi!'
      , (bot, channel) ->
        bot.say channel, 'did you miss me?'
      , (bot, channel) ->
        bot.say channel, "I'm back!"
      , (bot, channel) ->
        bot.say channel, "what's that smell?"
        bot.say channel, "wooops, sorry, it's me"
      , (bot, channel) ->
        bot.say channel, "no, I won't !help you"
>>>>>>> 7904270e17384f546b8dd2a9eefda5f9a92384e5
    ]
    q:
      service:
        nick: 'Q'
        user: 'TheQBot'
        host: 'CServe.quakenet.org'
      user: 'nerdobot'
      pass: 'password'
      hash: '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8' # remove 'pass' if you use this
      channels: ['#mv.nerd'] # channels to log AFTER Q authing
    gitpush:
      allowed: ['207.97.227.253', '50.57.128.197', '108.171.174.178', '127.0.0.1']
      path: '/'
      port: 9999
      repositories: [
        name: 'nerdobot'
        owner: 'alvaro-cuesta'
        to: ['#mv.nerd']
      ]
