module.exports = (bot, memory) ->

  brainfuck = ({nick}, program, to) ->
    to ?= nick

    cin = ""
    out = ""
    ptr = 0
    eip = 0
    inptr = 0

    mem = []
    for i in [0..memory-1]
      mem[i] = 0

    # TODO: umbalanced []
    operators =
      '>': -> ptr++
      '<': -> ptr--
      '+': -> mem[ptr]++
      '-': -> mem[ptr]--
      '.': -> out += String.fromCharCode mem[ptr]
      ',': ->
        mem[ptr] = cin.charCodeAt inptr
        inptr++
      '[': ->
        if mem[ptr] == 0
          eip += program[eip..].indexOf ']'
      ']': ->
        if mem[ptr] != 0
          eip = program[..eip].lastIndexOf '['

    exec = ->
      if program[eip] of operators
        operators[program[eip]]()

      eip++

      if eip < program.length
        process.nextTick exec
      else
        bot.say to, "OUTPUT: #{out}"

    exec()

  bot.commands.on 'brainfuck', brainfuck
  bot.commands.on 'bf', brainfuck

  name: 'Brainfuck'
  description: "Brainfuck interpreter"
  version: '0.1'
  authors: ['Álvaro Cuesta']
