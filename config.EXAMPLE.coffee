greetings = [
  (channel) ->
    @me channel, 'says hi'
  , (channel) ->
    @me channel, "is pleased to be in #{channel}!"
  , (channel) ->
    @me channel, "doesn't follow the laws of robotics..."
  , (channel) ->
    @me channel, 'is going to kill you'
  , (channel) ->
    @say channel, 'hi!'
  , (channel) ->
    @say channel, 'did you miss me?'
  , (channel) ->
    @say channel, "I'm back!"
  , (channel) ->
    @say channel, "what's that smell?"
    @say channel, "wooops, sorry, it's me"
  , (channel) ->
    @say channel, "no, I won't !help you"
  , (channel) ->
    @say channel, "mi no abla espagniolo"
]

module.exports =
  socket:
    port: 6667
    host: 'irc.quakenet.org'
    localAddress: '0.0.0.0'
  connection:
    encoding: 'utf8'
  user:
    nick: ['nerdobot', 'nerdobot_', 'nerdobot__']
    login: 'nerdobot'
    pass: 'password'
    realname: 'NerdoBot'
    invisible: true
    wallops: false
  throttle: 15000 # first throttle time (increments *= 2 per throttle)
  channels: ['#mediavida'] # channels to log upon connection (even before service auths)
  prefix: '!'
  timeout: 1000 # Antiflood ms time
  plugins:
    debug: {}
    dice: {}
    eval:
      coffee: true
    gitpush:
      allowed: ['207.97.227.253', '50.57.128.197', '108.171.174.178', '127.0.0.1']
      path: '/'
      port: 9999
      repositories: [
        name: 'nerdobot'
        owner: 'alvaro-cuesta'
        to: ['#mv.nerd']
      ]
    google: 1
    help:
      hidden: ['raw', 'say', 'asay', 'me', 'ame', 'nick']
      banner: " Contribute to \x02nerdobot\x0f! Visit \x032\x1fhttps://github.com/alvaro-cuesta/nerdobot\x0f for instructions."
    hi: greetings
    irc: {}
    isohunt:
      results: 3
      shorten: false
    q:
      service:
        nick: 'Q'
        user: 'TheQBot'
        host: 'CServe.quakenet.org'
      user: 'nerdobot'
      pass: 'password'
      hash: '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8' # remove 'pass' if you use this
      channels: ['#mv.nerd'] # channels to log AFTER Q authing
    quotes: '/opt/nerdo/nerdobot.sqlite3'
    raw: {}
    spy: {}
    tinysong: 'api-key'
    tits: {}
    wunderground: 'api-key'
    youtube:
      results: 1
      random: false
      options:
        region: 'US'
        'max-results': 1
        'paid-content': false
        safeSearch: 'none'
  aliases:
    dice: ['d']
    eval: ['js']
    'eval-block': ['jsb']
    coffee: ['coff']
    'coffee-block': ["coffb"]
    google: ['g']
    wikipedia: ['wiki', 'w']
    isohunt: ['torrent', 't']
    tinysong: ['song', 'tiny']
    wunderground: ['weather']
    youtube: ['yt']
  whitelist:
    raw: [] # only users in group 'admin' can run this command
    nick: []
    say: ['talker']
    me: ['talker']
    asay: ['broadcaster']
    ame: ['broadcaster']
    'eval-block': ['developer']
    'coff-block': ['developer']
  users:
    alvaro: ['admin']
    Tunner: ['talker', 'broadcaster']
    'nerdobot-dev': ['talker']
