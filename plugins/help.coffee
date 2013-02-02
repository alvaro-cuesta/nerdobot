module.exports = ->

  @addCommand 'help',
    args: '<command, optional>'
    description: 'List commands or print help for <command>'
    ({nick}, command, to) =>
      to ?= nick

      if command?
        command = command[1..] if command[0] == @config.prefix

        for _, meta of @plugins
          for cmd, info of meta.commands
            if command == cmd or (info.aliases? and command in info.aliases)
              helpMsg = "#{@BOLD}#{@color 'red'}#{@config.prefix}#{cmd}#{@RESET}"
              helpMsg += ' ' + info.args if info.args?
              helpMsg += ' - ' + info.description if info.description?

              @say to, helpMsg

              if info.help?
                @say to, " #{info.help}"

              if info.aliases? and info.aliases.length > 0
                @say to, " #{@BOLD}Aliases:#{@RESET} #{@config.prefix + info.aliases.join ", #{@config.prefix}"}"

              return

        @notice nick, "Unknown command #{@BOLD}#{@config.prefix}#{command}#{@RESET}"
      else
        commands = []
        for _, meta of @plugins
          for cmd, _ of meta.commands
            commands.push cmd

        commands.sort (a, b) ->
          return 1 if a > b
          return -1 if a < b
          0

        @say to, "#{@BOLD}#{@color 'red'}Available commands:#{@RESET} #{@config.prefix + commands.join ", #{@config.prefix}"}"
        @say to, " Type #{@BOLD}#{@config.prefix}help <command>#{@BOLD} for detailed instructions."

  name: 'Help'
  description: 'Print help for bot commands'
  version: '0.2'
  authors: ['Álvaro Cuesta']
