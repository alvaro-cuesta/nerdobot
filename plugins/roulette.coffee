
module.exports = ->

  command = @config.prefix + "roulette"

  game = []

  help = (from) =>
    @say from.nick, 
      banner "How to play?"

  banner = (message) =>
    "#{@BOLD}#{@color 'red'}Russian Roullete#{@RESET} - #{message}"

  render = (bullets) =>
    drum = "#{@color 'yellow', 'black'}#{@BOLD}"

    for num in [1..bullets]
      drum += "|"
      drumn = _i

    total = 6 - drumn

    if total
      drum += "#{@color 'white'}"

    for num in [total..1]
      drum += "|"

    drum += " #{@RESET}"

  @addCommand 'roulette',
    description: 'Play the Russian Roullete and di... live if you can'
    help: 'Use the command roullete help to learn how to play'
    (from, message, channel) =>

      shot = (from) =>
        if not game[channel]?
          game[channel] =
            bullets: 6
            channel: channel

        if game[channel].bullets is 1
          @say game[channel].channel,
            banner "Nobody died this time..."
          @me game[channel].channel,
            "Reloads the gun..."
          game[channel]['bullets'] = 6

        running = game[channel]

        num = Math.floor(Math.random() * 1.28)

        @me running.channel,
          "gives #{from.nick} the gun..."

        if num is 1
          @say running.channel,
            "#{@color 'red'}#{@BOLD}BOOM! HeadShot...#{@RESET} We have the " +
            "brains of #{@BOLD}#{from.nick}#{@RESET} on all around the " +
            "#{@BOLD}#{running.channel}#{@RESET}."
          @me running.channel,
            "Reloads the gun..."

          game[channel]['bullets'] = 6
        else
          game[channel]['bullets'] = running.bullets-1
          running = game[channel]

          @say running.channel,
            "#{@color 'green'}#{@BOLD}Click!#{@RESET} Oh #{@BOLD}#{from.nick}," +
            "#{@RESET} you're a Lucky Bastard... #{render running.bullets} " +
            "bullets remaining..."

      reload = (from) =>
        if not game[channel]?
          game[channel] =
            bullets: 6
            channel: channel

        @me game[channel].channel,
            "Reloads the gun..."
        
        game[channel]['bullets'] = 6

      switch message
        when "help"
          help from

        when "reload"
          reload from

        when "shot"
          shot from

        else
          @say channel,
            banner "Hola"

  name: 'Russian Roulette Game'
  description: 'Play the Russian Roullete and di... live if you can'
  version: '0.2'
  authors: [
    'Tunnecino @ arrogance.es'
  ]