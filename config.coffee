module.exports =
  socket:
    port: 6667
    host: 'irc.quakenet.org'
    #localAddress: '0.0.0.0'
  connection:
    encoding: 'utf8'
  user:
    nick: 'nerdobot'
    login: 'nerdobot'
    #pass: 'password'
    realname: 'NerdoBot'
  admins: [
    '.*!.*@184\.Red-80-36-134\.staticIP\.rima-tde\.net'
    ]
  channels: ['#mv.nerd']
  db: "/home/kaod/projects/coffee/nerdo/nerdobot.sqlite3"
  plugins: [
    'quotes',
    'say',
    'raw',
#    'debug',
    'spy',
    'hi'
    ]
  greetings: [
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
