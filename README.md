# Writing a simple MPV plugin in Crystal

This is a POC! It is a `mpv` plugin, written in crystal, using the C plugin interface of `mpv`.

## Installation

MPV's C plugins interface is disabled by default, you'll need to build `mpv` with `--enable-cplugin` to activate it.

### Build mpv

Follow the instructions at [mpv-player/mpv](https://github.com/mpv-player/mpv) to build `mpv`. When asked to configure the project, run:

```sh
$ ./waj configure --enable-cplugin
```
Continue the other steps to compile `mpv`.

### Build the plugin

Build the plugin's shared library with:

```sh
$ make
```

If you want to rebuild it, use:

```sh
$ make re
```

To clean the repository, and re-build the plugin.

## Usage

Once you have your custom `mpv` build and the plugin's shared library, you can run test it with:

```sh
$ /path/to/custom/mpv /path/to/media/file  --script ./mpv-crystal-simple-plugin.so
```

## Contributing

1. Fork it ( https://github.com/bew/mpv-crystal-simple-plugin/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [bew](https://github.com/bew) Benoit de Chezelles - creator, maintainer
