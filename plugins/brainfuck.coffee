# TODO:
#  max iterations
#  toroidal memory?
#  cin

module.exports = (memory) ->

  brainfuck = ({nick}, program, to) =>
    do =>
      to ?= nick

      cin = ""
      out = ""
      ptr = 0
      eip = 0
      inptr = 0

      mem = []
      for i in [0..memory-1]
        mem[i] = 0

      operators =
        '>': -> ptr++
        '<': -> ptr--
        '+': -> mem[ptr]++
        '-': -> mem[ptr]--
        '.': -> out += String.fromCharCode mem[ptr]
        ',': -> mem[ptr] = cin.charCodeAt inptr++
        '[': ->
          index = program[eip..].indexOf ']'
          throw "Unbalanced '[' in char #{eip}" if index < 0
          eip += index if mem[ptr] == 0
        ']': ->
          index = program[..eip].lastIndexOf '['
          throw "Unbalanced ']' in char #{eip}" if index < 0
          eip = index if mem[ptr] != 0

      compiled = (operators[c] for c in program when c of operators)

      exec = =>
        try
          compiled[eip++]()

          if eip < program.length
            process.nextTick exec
          else
            @say to, "#{@color 'blue'}#{@BOLD}OUTPUT#{@RESET}: #{out}"
        catch err
          @say to, "#{@color 'red'}#{@BOLD}ERROR#{@RESET}: #{err}"

      exec()

  @addCommand 'brainfuck',
    args: '<code>'
    aliases: ['bf']
    description: 'Interpret Brainfuck code'
    help: "Further details: #{@color 'blue'}#{@UNDERLINE}http://en.wikipedia.org/wiki/Brainfuck#{@RESET}"
    brainfuck

  name: 'Brainfuck'
  description: "Brainfuck interpreter"
  version: '0.1'
  authors: ['Álvaro Cuesta']
