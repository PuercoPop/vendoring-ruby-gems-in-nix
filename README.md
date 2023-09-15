# How to vendor ruby gems using Nix?

## First approach: Try to call bundler cache from inside a bundlerEnv

This fails because bundle cache tries to set the [CACHE_ALL_PLATFORMS] option
before running the command. This tries to write the config next to the Gemfile,
which is in the nix store. So it fails.

```shell
$ nix -A defeault
$ bundle cache
There was an error while trying to write to `/nix/store/3b0fsiq7fcfx3aakmhj1xbigpbq4m3km-gemfile-and-lockfile/.bundle/config`. It is likely that you need
to grant write permissions for that path.
```

## Second approach: Using bundix's -m flag

Bundix has an option named [magic] which seems to call bundle pack, which is an
alias for cache. It takes a ruby argument which is an expression to fill the
whole in to `bundler.override { _ruby = ?_? }`.

```shell
$ nix-shell -A update
$ bundix -m                      # Your Ruby version is 2.7.6, but your Gemfile specified 3.2
$ bundix -m --ruby=ruby          # Your Ruby version is 2.7.6, but your Gemfile specified 3.2
$ bundix -m --ruby=pkgs.ruby_3_2 # Success! 🙌
```

[CACHE_ALL_PLATFORMS]: https://github.com/rubygems/rubygems/blob/71ef92300be7c2c01888847cdf8a222e6f869be9/bundler/lib/bundler/cli/cache.rb#L22-L24
[magic]: https://github.com/nix-community/bundix/blob/e9f533a9a28555aa759b7418a739d79c06192bfb/lib/bundix/commandline.rb#L42
