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
    invisble: true
    wallops: false
  admins: ['.*!.*@your.host.here'] # admin prefix (regexes)
  channels: ['#mediavida'] # channels to log upon connection (even before service auths)
  db: "/var/bot/nerdobot.sqlite3" # database file
  plugins: [ # enabled plugins
    'quotes',
    'say',
    'raw',
    'spy',
    'hi',
    'q'
    ]
  greetings: [ # random greetings for the 'hi' plugin (a list of functions!)
    (bot, channel) ->
      bot.me 'says hi', channel
    , (bot, channel) ->
      bot.me "is pleased to be in #{channel}!", channel
    , (bot, channel) ->
      bot.me "doesn't follow the laws of robotics...", channel
    , (bot, channel) ->
      bot.me 'is going to kill you', channel
    , (bot, channel) ->
      bot.say 'hi!', channel
    , (bot, channel) ->
      bot.say 'did you miss me?', channel
    , (bot, channel) ->
      bot.say "I'm back!", channel
    , (bot, channel) ->
      bot.say "what's that smell?", channel
      bot.say "wooops, sorry, it's me", channel
    , (bot, channel) ->
      bot.say "no, I won't !help you", channel
    ]
  q:
    service: # the Q service data
      nick: 'Q'
      user: 'TheQBot'
      host: 'CServe.quakenet.org'
    user: 'nerdobot'
    pass: 'password'
    hash: '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8' # remove 'pass' if you use this
    channels: ['#mv.nerd'] # channels to log AFTER Q authing
