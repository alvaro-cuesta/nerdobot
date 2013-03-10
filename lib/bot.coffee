util = require './util'
irc = require './irc'
clc = require 'cli-color'
EventEmitter = require('events').EventEmitter

module.exports.Bot = class Bot extends irc.Client
  constructor: (config) ->
    super(config)

    @plugins = {}
    @time = true

    # Default user provider = nick
    if @config.userProvider
      @getUser = require "./user/#{@config.userProvider}"
    else
      @getUser ?= ({nick}) -> nick

    @commands = new EventEmitter()
    # Emits commands issues by users
    #   command -> from, args, channel
    #     channel is undefined in private messages

    @events.on 'welcome', =>
      @join channel for channel in @config.channels

    @events.on 'message', (from, message, channel) =>
      @parseCommand from, message, channel

    # Load plugins
    for own plugin, config of config.plugins
      commands = {}

      botInstance = Object.create this
      botInstance.addCommand = (command, meta, cb) =>
        commands[command] = meta
        @commands.on command, cb
        if @config.aliases?[command]?
          for alias in @config.aliases[command]
            @commands.on alias, cb

      meta = require('../plugins/' + plugin).apply botInstance, [config]
      # = {name, version, description, authors}
      if meta
        @plugins[plugin] = meta
        @plugins[plugin].commands = commands
        console.log clc.bold("#{meta.name} v#{meta.version}") + " - #{meta.description}"
      else
        console.log clc.redBright.bold "Error loading '#{plugin}'"

    console.log ''

  # Parse messages looking for client commands
  parseCommand: (from, message, channel) ->

    [command, rest] = util.split message, ' '
    if not command? or command == ''
      return

    command = @stripControl command

    if command[0] == @config.prefix
      command = command[1..]

      args = rest if rest != ''

      if @commands.listeners(command).length > 0
        if @config.antiflood and not @time
          return

        if not @checkPermission @getUser(from), command
          return

        @commands.emit command, from, args, channel

        # Antiflood
        @time = false

        if @config.antiflood
          setTimeout =>
            @time = true
          , @config.antiflood
      else
        @notice from.nick, "Unknown command #{@BOLD}#{@config.prefix}#{command}#{@RESET}"

  checkPermission: (user, command) ->
    {whitelist, users} = @config

    if not whitelist?[command]?
      return true  # disabled

    if users?[user]?
      return true if 'admin' in users[user]  # admin group = god
      return true for group in users[user] when group in whitelist[command]

    return false
