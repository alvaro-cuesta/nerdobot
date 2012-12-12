EventEmitter = require('events').EventEmitter
express = require 'express'

module.exports = (bot, config) ->
  ps = new PushServer(config)

  app = express()
  app.use express.bodyParser()
  app.post config.path, ps.handler
  app.listen config.port ? 9999

  ps.on 'push', (branch, payload) ->
    for repo in config.repositories \
        when repo.name == payload.repository.name \
        and repo.owner == payload.repository.owner.name
      for to in repo.to
        bot.say "#{bot.color 'red'}#{payload.pusher.name}#{bot.RESET} pushed " +
          "#{bot.color 'green'}#{payload.commits.length} commits#{bot.RESET} " +
          "to #{bot.BOLD}#{repo.owner}/#{repo.name}" +
          (if branch? then "/#{branch}" else '') + "#{bot.RESET} <- " +
          "#{bot.color 'blue'}#{bot.UNDERLINE}#{payload.compare}#{bot.RESET}"
        , to

  name: 'GitPush'
  description: 'GitHub push notifications plugin for nerdobot'
  version: '0.1'
  authors: ['Álvaro Cuesta']

class PushServer extends EventEmitter
  constructor: (@config) ->
    super()
    @handler = (req, res) =>
      if req.connection.remoteAddress not in @config.allowed
        res.send 403
        return

      if req.method != 'POST' or not req.body.payload?
        res.send 400
        return

      payload = JSON.parse req.body.payload

      match = payload.ref.match /^refs\/heads\/(.*)$/
      if not match?
        res.send 200
        return

      @emit 'push', match[1], payload
      res.send 200
