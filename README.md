# julia-install

[![Build Status](https://travis-ci.org/jlenv/julia-install.svg?branch=master)](https://travis-ci.org/jlenv/julia-install)

Builds and installs signed [Julia] sources. Compatible with `chjulia`
and `jlenv-chjl`.

Please see the full [documentation](https://jlenv.github.io/julia-install).

## Features

* Supports installing arbitrary versions.
* Supports downloading the latest versions from [julia-versions] or .
* Supports verifying GPG signatures of Julia source archives.
* Supports `chjulia` and the `jlenv` plugin `jlenv-chjl`.
* Supports default install to XDG Base Directories [specification][xdg-spec]
  * User directories
    * `XDG_CONFIG_HOME`
      Where user-specific configurations should be written (analogous to /etc).
      Default: $HOME/.config/julias/.
    * `XDG_CACHE_HOME`
       Where user-specific non-essential (cached) data should be written (analogous to /var/cache).
       Default: $HOME/.cache/julias/.
    * `XDG_DATA_HOME`
       Where user-specific data files should be written (analogous to /usr/share).
       Default: $HOME/.local/share/julias/.
  * System directories
    * `XDG_DATA_DIRS`
       List of directories seperated by : (analogous to PATH).
       Default: /usr/local/share/julias/:/usr/share/julias/.
    * `XDG_CONFIG_DIRS`
       List of directories seperated by : (analogous to PATH).
       Default: /etc/xdg/julias/.
* Supports installing into arbitrary directories.
* Supports downloading from arbitrary URLs.
* Supports downloading from mirrors.
* Supports downloading/applying patches.
* Supports specifying arbitrary `./configure` options.
* Supports downloading archives using `wget` or `curl`.
* Supports verifying downloaded archives using `gpg`.
* Supports installing build dependencies via the package manager:
  * [apt]
  * [dnf]
  * [yum]
  * [pacman]
  * [zypper]
  * [pkg]
  * [macports]
  * [brew]
* Has tests.

## Anti-Features

* Does not require updating every time a new Julia version comes out.
* Does not require recipes for each individual Julia version or configuration.
* Does not support installing trunk/HEAD.
