# nerdobot

IRC bot for #mv.nerd built with CoffeeScript + NodeJS.

You can use `nerdobot` as a configurable bot, as a bot library and as an IRC library (look into the `/lib/` folder.)

## Usage

### Requirements

`nerdobot` requires [NodeJS](http://nodejs.org/) and NPM (usually installed with Node) to be run. [CoffeeScript](http://coffeescript.org) also needs to be installed. Use `npm install -g coffee-script`, which will install `coffee` globally so you can run CoffeeScript code using `coffee <file.coffee>`.

### Installing

```sh
$ sudo npm install -g https://github.com/alvaro-cuesta/nerdobot/tarball/master
```

That will install `nerdobot` globally, so you can run it like this:

```sh
$ nerdobot
```

To setup the bot configuration, follow [config.EXAMPLE.coffee](https://github.com/alvaro-cuesta/nerdobot/blob/master/config.EXAMPLE.coffee). After that, you can either set the `NERDO_CONFIG` environment variable, pass the config file path as a command-line argument or put the file under nerdobot's root folder.

**Be careful!** Some plugins need additional dependencies which won't be auto-installed by NPM. Inspect the error logs and fetch them using `npm install <dependency>` under nerdobot's folder.

## Developing

### Running your own nerdobot copy

If you did download the code, there's an easy way to update dependencies. Run this under `nerdobot`'s code folder:

```sh
$ npm install
```

And run using:

```sh
$ coffee ./bin/nerdobot.coffee
or
$ npm start
```

You can also install your own nerdobot copy globally (to execute typing `nerdobot` anywhere in your system) executing this under nerdobot's root folder:

```sh
$ sudo npm install -g
```

### Contributing

Just fork this repository and start hacking on your own copy. Preferably, make your own branch out of `develop` (this will be easier for everyone to maintain.) Once you're happy with the results, need comments, or just want to let us know, issue a [pull request](https://github.com/alvaro-cuesta/nerdobot/pull/new/develop).

If the code is good enough, we have no problems on accepting pull requests (and you'll be added to the appropriate contributors sections.) If there's something wrong, we'll let you know and guide you to fix it. I hope it's just not **TERRIBLY** wrong :)

We prefer [CoffeeScript](http://coffeescript.org/) code but might pull JavaScript if it's good enough (or maybe migrate it to CoffeeScript.) Ask before doing any work, just in case.

### Plugins

Hacking plugins is even easier. You can either follow the same steps for contributing (if the plugin is worthwhile for everyone) or start your own repo (just for your plugin) and start hacking there.

In any case, we're not sure we'll maintain your plugin code if you fork off our repo. If the code falls behind the development code, it might even be pulled off to a `old_plugins` directory. We might maintain it if we feel it's worthwhile, and you can always maintain it yourself.

Plugins follow this structure:

```javascript
module.exports = function(pluginConfig) {
  /* your code here
   *
   * - 'this' will be your bot instance
   * - pluginConfig contains the key value for this plugin in
   *   nerdobot's config file
   *
   * see 'lib/irc.coffee', 'lib/bot.coffee'
   * and other plugins for API/examples
   *
   */

  return {
    name: 'Plugin long name',
    description: 'This plugin does something... probably',
    version: '0.1',
    authors: [
      'You',
      'Some guy',
      'The internet'
    ]
  };
};
```

```coffee
module.exports = (pluginConfig) ->
  # your code here
  #
  # - 'this' will be your bot instance
  # - pluginConfig contains the key value for this plugin in
  #   nerdobot's config file
  #
  # see 'lib/irc.coffee', 'lib/bot.coffee'
  # and other plugins for API/examples

  name: 'Plugin long name'
  description: 'This plugin does something... probably'
  version: '0.1'
  authors: [
    'You',
    'Some guy',
    'The internet'
  ]
```

## Contributors

- [blzkz](https://github.com/blzkz)
- [Tunnecino](https://github.com/Arrogance) @ [ignitae.com](http://www.ignitae.com)

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
