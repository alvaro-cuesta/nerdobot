module.exports = ->
  @addCommand 'kata_rectangle_Code07_mamon',
    args: '<texto>'
    description: 'Imprime <texto> como un rectángulo. Dedicado al mamón de Code07.'
    ({nick}, text, to) =>
      to ?= nick

      n = text.length/4

      if text % 2
        @say to, 'El texto debe tener una longitud par'
        return

      l = Math.ceil n+1
      s = ~~n-1

      whitespace = Array(l-1).join ' '

      u = l+s
      v = 2*l + s

      a = text[...l]
      b = text[l...u]
      c = text[u...v].split('').reverse().join ''
      d = text[v..]

      @say to, a
      @say to, d[s-i] + whitespace + b[i-1] for i in [1..s]
      @say to, c

  name: 'Kata Rectangle'
  description: "Code07 mamón!"
  version: '0.1'
  authors: ['kaoD']
