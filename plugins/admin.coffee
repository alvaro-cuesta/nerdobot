clc = require 'cli-color'

module.exports = ->

  @addCommand 'load',
    args: '<plugin>'
    description: 'Loads a plugin'
    (from, plugin, to) =>
      @loadConfig()
      @load plugin
      @say to ? from, "#{@BOLD}#{plugin} loaded!"

  @addCommand 'unload',
    args: '<plugin>'
    description: 'Unloads a plugin'
    (from, plugin, to) =>
      @unload plugin
      @say to ? from, "#{@BOLD}#{plugin} unloaded!"

  @addCommand 'reload',
    description: 'Reloads all plugins'
    (from, message, to) =>
      console.log ''
      console.log clc.bold ' - RELOADING PLUGINS ! -'
      console.log ''

      @loadConfig()
      @unloadPlugins()
      @loadPlugins()

      @say to ? from, "#{@BOLD}Plugins reloaded!"

  @addCommand 'config',
    description: 'Reloads the bot config from the original file'
    (from, message, to) =>
      console.log ''
      console.log clc.bold ' - RELOADING CONFIG ! -'
      console.log ''

      @loadConfig()

      @say to ? from, "#{@BOLD}Config reloaded!"

  name: 'Admin'
  description: 'Bot administration commands'
  version: '0.1'
  authors: ['Álvaro Cuesta']
