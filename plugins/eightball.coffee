
answers = [
  "It is certain",
  "It is decidedly so",
  "Without a doubt",
  "Yes – definitely",
  "You may rely on it",
  "As I see it, yes",
  "Most likely",
  "Outlook good",
  "Yes",
  "Signs point to yes",
  "Reply hazy, try again",
  "Ask again later",
  "Better not tell you now",
  "Cannot predict now",
  "Concentrate and ask again",
  "Don't count on it",
  "My reply is no",
  "My sources say no",
  "Outlook not so good",
  "Very doubtful"
] 

module.exports = ->
  @addCommand '8ball',
    description: 'Ask something to the 8Ball and see what answers',
    help: 'Play with the black ball as a children'
    (from, message, channel) =>
      if not channel?
        @notice from, 'This command only works in channels'
        return

      banner = (message) =>
        "#{@color 'black'}The #{@BOLD}8-Ball#{@RESET} #{message}"

      if not message?
        @say channel, banner 'can\'t answer to the silence, moron...'
        return

      answer = answers[Math.floor(Math.random()*answers.length)];

      @say channel,
        banner "#{@color 'black'}answers... #{@BOLD}#{answer}#{@RESET}"

  name: '8Ball Game'
  description: 'Ask something to the 8Ball and see what answers'
  version: '0.2'
  authors: ['Tunnecino @ arrogance.es']