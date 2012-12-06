Bot = require('./lib/bot').Bot
config = require('./config')

bot = new Bot(config)

bot.events.on 'connected', () -> console.log 'Connected'
bot.events.on 'end', () -> console.log 'Disconnected'

bot.connect()
