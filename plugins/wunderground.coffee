request = require 'request'
util = require '../lib/util'

module.exports = (apikey) ->

  searchURL = (location) ->
    "http://api.wunderground.com/api/#{apikey}/forecast/lang:EN/q/autoip/#{location}.json"
  infoURL = (zmw) ->
    "http://api.wunderground.com/api/#{apikey}/forecast/lang:EN/q/zmw:#{zmw}.json"

  banner = (message) =>
    "#{@color 'blue'}#{@BOLD}Weather#{@RESET} - #{message}"

  @addCommand 'wunderground',
    args: '<location>'
    description: 'Weather forecast'
    aliases: ['weather']
    (from, location, channel) =>
      if not channel?
        @notice from.nick, 'That command only works in channels'
        return

      if not location?
        @notice from.nick, 'You should specify a location!'
        return

      success = (data) =>
        [weekday, month, day] = [
            data.date.weekday,
            data.date.monthname,
            util.lpad data.date.day, 2
        ]
        [date, high, low, condition, wind, wind_d, hum, snow] = [
          "#{weekday}, #{month} #{day}",
          data['high']['celsius'],
          data['low']['celsius'],
          data['conditions'],
          data['avewind']['kph'],
          data['avewind']['dir'],
          data['avehumidity'],
          data['snow_allday']['in']
        ]
        @say channel,
          banner "#{@BOLD}#{location}#{@RESET} @ #{date}:" +
          "#{@BOLD}" +
          "#{@color 'red'} #{high}#{@RESET}#{@BOLD} /" +
          "#{@color 'blue'} #{low}#{@RESET} "
        @say channel,
          "#{condition}, #{wind}kph #{wind_d} wind, #{hum}% " +
          "humidity and #{snow}% probability of snowing."

      failure = (err) =>
        @say channel,
          banner "#{@BOLD}#{err}#{@RESET}"

      request
        url: searchURL location
        json: true
        (err, res, data) ->
          if err?
            failure "Couldn't connect..."
            return

          if data.response.error? and data.response.error['type'] is 'querynotfound'
            failure "#{location} is not a valid location..."
            return

          if data.response.results?
            zmw = data.response.results[0]['zmw']
            request
              url: infoURL zmw
              json: true
              (err, res, data) ->
                if err?
                  failure "Couldn't connect..."
                  return
                if data.response.error? and data.response.error['type'] is 'querynotfound'
                  failure "#{location} is not a valid location..."
                  return
                success data.forecast.simpleforecast.forecastday[0]
            return

          success data.forecast.simpleforecast.forecastday[0]

  name: 'Wunderground Weather API'
  description: 'Returns weather (today+tomorrow) for the most approximate city'
  version: '0.5'
  authors: [
    'Tunnecino @ arrogance.es'
  ]
