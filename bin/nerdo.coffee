#!/usr/bin/env coffee

clc = require 'cli-color'
Bot = require('../lib/bot').Bot
config = require process.argv[2] or process.env.NERDO_CONFIG or '../config'

bot = new Bot(config)

bot.events.on 'connected', ->
  console.log clc.bold.greenBright '- Connected! -\n'
bot.events.on 'throttled', (waiting) ->
  console.log clc.bold.yellowBright "\n- Throttled, waiting #{waiting} seconds... -\n"
bot.events.on 'end', ->
  console.log clc.bold.redBright '\n- Disconnected :( -\n'

bot.connect()
