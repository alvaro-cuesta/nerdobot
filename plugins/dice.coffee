util = require '../lib/util'
{floor, random} = Math

DEFAULT_DIES = 1
DEFAULT_FACES = 6
MAX_DIES = 100

module.exports = ->

  @addCommand 'dice',
    args: "<dices, default=#{DEFAULT_DIES}, max=#{MAX_DIES}> <faces, default=#{DEFAULT_FACES}>"
    aliases: ['d']
    description: 'Throw dies and show their sum'
    ({nick}, message, to) =>
      to ?= nick

      dies = DEFAULT_DIES
      faces = DEFAULT_FACES

      if message?
        [a, b] = util.split message, ' '
        console.log 1 + a, 1 + b

        if b? and b != ''
          dies = parseInt a, 10
          faces = parseInt b, 10
        else if a? and a != ''
          faces = parseInt a, 10

      return unless 0 < dies <= MAX_DIES

      sum = dies
      sum += floor random() * faces for _ in [1..dies]

      @say to, " = #{sum}"

  name: 'Dice'
  description: 'Throw dies'
  version: '0.1'
  authors: ['Álvaro Cuesta']
