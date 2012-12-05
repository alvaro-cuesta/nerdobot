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