# nerdobot

IRC bot for #mv.nerd built with CoffeeScript + NodeJS

## Usage

`nerdobot` requires [NodeJS](http://nodejs.org/) and NPM (usually installed with Node) to be run.

[CoffeeScript](http://coffeescript.org) also needs to be installed. Use `npm install -g coffee-script`, which will install `coffee` globally so you can run CoffeeScript code using `coffee <file.coffee>`.

As this is being written, `nerdobot` is not stable enough to be uploaded to external repositories, so you'll have to fetch it from GitHub (either the repository or `master` branch realization.) Edit `config.coffee` to setup your bot configuration.

```
$ npm install
<fancy colors and lots of characters>
$ coffee ./bin/nerdobot.coffee
or
$ npm start
```

You can also install `nerdobot` globaly:

```
$ npm install -g
$ nerdobot
```

Once `nerdobot` is stable enough it will be available in NPM's repositories, so you'll be able to install it like this:

`$ npm install -g nerdobot`

## Developing

Just fork this repository and start hacking on your own copy. Preferably, make your own branch out of `develop` (this will be easier for everyone to maintain.) Once you're happy with the results, need comments, or just want to let us know, issue a [pull request](https://github.com/alvaro-cuesta/nerdobot/pull/new/develop).

If the code is good enough, we have no problems on accepting pull requests (and you'll be added to the appropriate contributors sections.) If there's something wrong, we'll let you know and guide you to fix it. I hope it's just not **TERRIBLY** wrong :)

We prefer [CoffeeScript](http://coffeescript.org/) code but might pull JavaScript if it's good enough (or maybe migrate it to CoffeeScript.) Ask before doing any work, just in case.

### Plugins

Hacking plugins is even easier. You can either follow the same steps for contributing (if the plugin is worthwhile for everyone) or start your own repo (just for your plugin) and start hacking there.

In any case, we're not sure we'll maintain your plugin code if you fork off our repo. If the code falls behind the development code, it might even be pulled off to a `old_plugins` directory. We might maintain it if we feel it's worthwhile, and you can always maintain it yourself.

Plugins follow this structure:

```javascript
module.exports = function(bot) {
  /* your code here
   * 'bot' will be your bot instance
   *
   * see 'lib/irc.coffee', 'lib/bot.coffee'
   * and other plugins for API/examples
   */
}
```

```coffee
module.export = (bot) ->
  # your code here
  # 'bot' will be your bot instance
  #
  # see 'lib/irc.coffee', 'lib/bot.coffee'
  # and other plugins for API/examples
```

## License

Copyright © 2012 Álvaro Cuesta and other contributors
https://github.com/alvaro-cuesta/nerdobot/

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
