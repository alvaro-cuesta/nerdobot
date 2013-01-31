# Core

### IRC Client

- Missing 'to' in say -> say to all channels
- Join multiple channels at once
- Detect multiple channels joined in event?
- Part command and detection
- Ident
- Debug/spy colors
- User/channel helper (modes, etc.)
- Track self nick
- Strip colors when parsing for commands

### Bot

- Command permissions (at least admin)
- Web interface
   - For plugins too!

# Plugins

- Plugin info/help

## Quote

- Search quote using SQL's like for quote, nick, etc.
- SQL Index

## GitHub

- Self-update
- Abstract Express usage

## YouTube/Google/Whatever
- Some way to return random results instead of the first result.
- Bug with tildes

## eval/coff
- Buggy on long array outputs (\n is inserted)
- Multiline !!eval/!!coff doesn't work

## Suggested plugins

### Simple
- Dice throw
- Fortune cookie
- 8ball
- Utils
   - Ping
   - Time

### Networks/auth
- IRC-Hispano auth
- Nickserv

### APIs
- Google/bit.ly/cluds shortener/expander
- MV

### IRC
- Proper logging
- Stats (max users, most talking, most joins, etc.)
- Op controls + autoop etc.
- Seen

### Games
- Trivial
- Hangman
- Russian roulette
- Rock, paper, scissors

### Other/utils
- Timer/alarm/countdown
- Brainfuck/other interpreters
   - https://github.com/flatland/lazybot/blob/develop/src/lazybot/plugins/haskell.clj
   - https://github.com/flatland/lazybot/blob/develop/src/lazybot/plugins/brainfuck.clj
- Karma
- WhatIs/About/Help/Info
- Admin
   - Load/unload plugins
   - Reconnect
   - Reload config
   - Debug
   - Unsandboxed eval
   - Shell commands
- Mail system
- Autoreplys
- Polls
