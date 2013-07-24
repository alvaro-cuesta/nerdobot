
module.exports = ->

  command = @config.prefix + "rps"

  game = []

  delay = (ms, func) => setTimeout func, ms

  help = (from) =>
    @say from.nick, 
      banner "#{@BOLD}How to play?#{@RESET}"
    @say from.nick, 
      "First, you need to start a game with the command #{@BOLD}#{command} " +
      "start#{@RESET} and await for a challenger. If you want to join a " +
      "started game, simply do a #{@BOLD}#{command} join#{@RESET}."
    @say from.nick, 
      "Now, you will recieve instructions to beat your challenger and win " +
      "the game. Also, you can check the status of the game in any moment, " +
      "using #{@BOLD}#{command} status#{@RESET}."
    @say from.nick,
      "The system will search for players for 4 minutes. If no players found " +
      "the game will be cancelled automatically. A player can also cancel a " +
      "game with the command #{@BOLD}#{command} cancel#{@RESET}."

  banner = (message) =>
    "#{@BOLD}#{@color 'grey'}Rock#{@color 'red'} Paper#{@RESET} " +
    "#{@BOLD}&#{@color 'blue'} Scissors! -#{@RESET} #{message}"

  @addCommand 'rps',
    description: 'Play Rock, Paper and Scissors with friends'
    help: 'Use the command rps help to learn how to play'
    (from, message, channel) =>

      start = (from) =>
        if game[channel]?
          @say channel,
            banner "The game is already started on this channel, Please, use " +
            "#{@BOLD}#{command} join#{@RESET} to play!"
          return

        if game[from.nick]?
          @say channel,
            banner "You are already participating in a game!"
          return

        game[channel] = []
        game[channel] =
          player1:
            nick: from.nick
            pick: 0
          player2:
            nick: 0
            pick: 0
          phase: 1
          channel: channel

        running = game[channel]

        game[running.player1.nick] = running

        @say running.channel, 
          banner "The player #{@BOLD}#{running.player1.nick}#{@RESET} has " +
          "started a game on #{running.channel}. Please, use " + 
          "#{@BOLD}#{command} join#{@RESET} to play!"

        announce = "The player #{@BOLD}#{running.player1.nick}#{@RESET} is " + 
            "searching a challenger, use #{@BOLD}#{command} join#{@RESET} " + 
            "to play with him"

        game[running.channel].timer = delay 60000, => 
          @say running.channel, 
            banner announce
              
          game[running.channel].timer = delay 60000, => 
            @say running.channel, 
              banner announce

              game[running.channel].timer = delay 60000, => 
                @say running.channel, 
                  banner announce

                game[running.channel].timer = delay 60000, =>
                  @say running.channel,
                    banner "Canceled the game on #{running.channel} due " +
                    "lacking of players :("

                  clearTimeout(game[running.channel].timer)

                  delete game[running.channel]
                  delete game[running.player1.nick]
                  delete game[running.player2.nick]

      status = (from) =>
        if not game[channel]?
          @say channel,
            banner "There are not any games active on this channel, you can " +
            "start a game with #{@BOLD}#{command} start#{@RESET}."
          return

        running = game[channel]

        if running.phase == 1
          @say channel,
            banner "The player #{@BOLD}#{running.player1.nick}#{@RESET} is " + 
            "searching a challenger, use #{@BOLD}#{command} join#{@RESET} to " +
            "play with him"
        else if running.phase == 2
          @say channel,
            banner "There are already a game in process, " + 
            "#{@BOLD}#{running.player1.nick} vs " +
            "#{running.player2.nick}#{@RESET}."

      join = (from) =>
        if not game[channel]?
          @say channel,
            banner "There are not any games active on this channel, you can " +
            "start a game with #{@BOLD}#{command} start#{@RESET}."
          return

        if game[from.nick]?
          @say channel,
            banner "You are already participating in a game!"
          return

        running = game[channel]

        if from.nick == running.player1.nick
          @say channel,
            banner "You can't not play with yourself... wait until I find a " +
            "player!"
          return

        if running.phase == 2
          @say channel,
            banner "There are already a game in process on this channel, " +
            "#{@BOLD}#{running.player1.nick} vs " +
            "#{running.player2.nick}#{@RESET}."
          return

        game[channel].phase = 2
        game[channel].player2.nick = from.nick

        if game[channel].timer?
          clearTimeout(game[channel].timer)

        running = game[channel]

        @say channel,
          banner "The player #{@BOLD}#{running.player2.nick}#{@RESET} " +
          "accepted the challenge from " +
          "#{@BOLD}#{running.player1.nick}#{@RESET}!"
        @say channel,
          "The instructions will be delivered on private messages, stay alert!"

        @say running.player1.nick,
          banner "Game instructions"
        @say running.player1.nick,
          "You will play against #{@BOLD}#{running.player2.nick}#{@RESET} " +
          "this round. You need to choose between #{@BOLD}#{command} " + 
          "rock#{@RESET}, #{@BOLD}#{command} paper#{@RESET} or " +
          "#{@BOLD}#{command} scissors#{@RESET} on this private chat. Once " +
          "both players decide, the winner will be announced on the channel."

        @say running.player2.nick,
          banner "Game instructions"
        @say running.player2.nick,
          "You will play against #{@BOLD}#{running.player1.nick}#{@RESET} " +
          "this round. You need to choose between #{@BOLD}#{command} " + 
          "rock#{@RESET}, #{@BOLD}#{command} paper#{@RESET} or " +
          "#{@BOLD}#{command} scissors#{@RESET} on this private chat. Once " +
          "both players decide, the winner will be announced on the channel."

        game[running.player2.nick] = running

      pick = (from, message) =>
        if channel?
          @notice from.nick,
            "This command can be only used in private"
          return

        if game[from.nick]
          running = game[from.nick]
          switch from.nick
            when running.player1.nick
              if running.player1.pick
                @say from.nick,
                  "You already picked #{@BOLD}#{running.player1.pick}#{@RESET}"
                return
              switch message
                when "rock"
                  game[running.channel].player1.pick = "rock"
                  @say from.nick,
                    "You picked #{@BOLD}#{message}#{@RESET}"
                when "paper"
                  game[running.channel].player1.pick = "paper"
                  @say from.nick,
                    "You picked #{@BOLD}#{message}#{@RESET}"
                when "scissors"
                  game[running.channel].player1.pick = "scissors"
                  @say from.nick,
                    "You picked #{@BOLD}#{message}#{@RESET}"

                else
                  @say from.nick,
                    "You need to choose between rock, paper or scissors"

              if game[running.channel].player2.pick
                game[game[running.channel].player1.nick] = game[running.channel]
                game[game[running.channel].player2.nick] = game[running.channel]
                decide()

            when running.player2.nick
              if running.player2.pick
                @say from.nick,
                  "You already picked #{@BOLD}#{running.player2.pick}#{@RESET}"
                return
              switch message
                when "rock"
                  game[running.channel].player2.pick = "rock"
                  @say from.nick,
                    "You picked #{@BOLD}#{message}#{@RESET}"
                when "paper"
                  game[running.channel].player2.pick = "paper"
                  @say from.nick,
                    "You picked #{@BOLD}#{message}#{@RESET}"
                when "scissors"
                  game[running.channel].player2.pick = "scissors"
                  @say from.nick,
                    "You picked #{@BOLD}#{message}#{@RESET}"

                else
                  @say from.nick,
                    "You need to choose between rock, paper or scissors"

              if game[running.channel].player1.pick
                game[game[running.channel].player1.nick] = game[running.channel]
                game[game[running.channel].player2.nick] = game[running.channel]
                decide()

        else
          @notice from.nick,
            "You are not participating in any game!"
          return

      decide = =>
        if game[from.nick]
          running = game[from.nick]
          if running.player1.pick == "rock"
            if running.player2.pick == "rock"
              win = 3
            if running.player2.pick == "paper"      
              win = 2
            if running.player2.pick == 'scissors'
              win = 1
          if running.player1.pick == "paper"
            if running.player2.pick == "rock"
              win = 1
            if running.player2.pick == "paper"      
              win = 3
            if running.player2.pick == 'scissors'
              win = 2
          if running.player1.pick == "scissors"
            if running.player2.pick == "rock"
              win = 2
            if running.player2.pick == "paper"      
              win = 1
            if running.player2.pick == 'scissors'
              win = 3

        @say running.channel,
          banner "#{@BOLD}#{running.player1.nick}#{@RESET} picked " +
          "#{@BOLD}#{running.player1.pick}#{@RESET} versus " +
          "#{@BOLD}#{running.player2.nick}#{@RESET} that picked " +
          "#{@BOLD}#{running.player2.pick}#{@RESET}"

        if win == 1
          @say running.channel,
            banner "And the winner is... #{@BOLD}#{running.player1.nick}!"
        else if win == 2
          @say running.channel,
            banner "And the winner is... #{@BOLD}#{running.player2.nick}!"
        else if win == 3
          @say running.channel,
            banner "And the winner is... a DRAW!"

        if win
          delete game[running.channel]
          delete game[running.player1.nick]
          delete game[running.player2.nick]

      cancel = (from) =>
        if game[from.nick]
          running = game[from.nick]
          @say running.channel,
            banner "Canceled the game on #{running.channel} :("

          if game[channel].timer?
            clearTimeout(game[channel].timer)

          delete game[running.channel]
          delete game[running.player1.nick]
          delete game[running.player2.nick]

      switch message
        when "help"
          help from

        when "start"
          start from

        when "join"
          join from

        when "rock"
          pick from,"rock"
        when "paper"
          pick from,"paper"
        when "scissors"
          pick from,"scissors"

        when "cancel"
          cancel from

        when "status"
          status from

        else
          @say channel,
            banner "Now you can play the classic game of Rock, Paper & " +
              "Scissors. Use the command #{@BOLD}#{command} help#{@RESET} to " +
              "learn how to play!"

  name: 'Rock, Paper, Scissors Game'
  description: 'Play againts other users!'
  version: '0.5'
  authors: [
    'Tunnecino @ arrogance.es'
  ]