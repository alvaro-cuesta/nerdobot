request = require('request')

module.exports = (bot, apikey) ->

  success = (data, channel, message) ->
    [fecha, alta, baja, condition, wind, wind_d, hum, snow] = [
      data['date']['weekday'] + ", " +
        data['date']['day'] + " de " +
        data['date']['monthname'],
      data['high']['celsius'],
      data['low']['celsius'],
      data['conditions'],
      data['avewind']['kph'],
      data['avewind']['dir'],
      data['avehumidity'],
      data['snow_allday']['in']
    ]
    bot.say channel,
      "#{bot.color 'blue'}#{bot.BOLD}El Tiempo" +
      "#{bot.RESET} - #{bot.BOLD}#{message}#{bot.RESET} @ #{fecha}:" +
      "#{bot.BOLD}" +
      "#{bot.color 'red'} #{alta}#{bot.RESET}#{bot.BOLD} /" +
      "#{bot.color 'blue'} #{baja}#{bot.RESET} "
    bot.say channel,
      "#{condition}, un viento de #{wind} kph #{wind_d}, una humedad " +
      "del #{hum}% y #{snow}% de posibilidad de nevada."

  failure = (data, channel) ->
    bot.say channel, 
      "#{bot.color 'blue'}#{bot.BOLD}El Tiempo" +
      "#{bot.RESET} - #{bot.BOLD}#{data}#{bot.RESET}"

  bot.commands.on 'tiempo', (from, message, channel) ->
    if err?
      return
    if not channel?
      bot.notice from.nick, 'Este comando solo funciona en un canal!'
      return
    if not message?
      bot.notice from.nick, 'Debes de indicarme una búsqueda!'
      return
    request 
      url: "http://api.wunderground.com/api/#{apikey}/forecast"+
      "/lang:SP/q/autoip/#{message}.json"
      json: true
    , (err, res, data) ->
        if err?
          failure "Sin conexión al servidor...", channel
          return

        if data.response.error? and data.response.error['type'] is 'querynotfound'
          failure "#{message} no es un lugar válido...", channel
          return   

        if data.response.results?
          zmw = data.response.results[0]['zmw']
          request 
            url: "http://api.wunderground.com/api/#{apikey}/"+
            "forecast/lang:SP/q/zmw:#{zmw}.json"
            json: true
          , (err, res, data) ->
              if err?
                failure "Sin conexión al servidor...", channel
                return
              if data.response.error? and data.response.error['type'] is 'querynotfound'
                failure "#{message} no es un lugar válido...", channel
                return
              success data.forecast.simpleforecast.forecastday[0], channel, message
          return

        success data.forecast.simpleforecast.forecastday[0], channel, message

  name: 'Wunderground Weather API'
  description: 'Devuelve el tiempo para hoy, y mañana de la ciudad indicada ' +
    '(la más aproximada).'
  version: '0.4'
  authors: [
    'Tunnecino @ arrogance.es',
  ]