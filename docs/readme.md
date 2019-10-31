# Julia-install

Builds and installs signed [Julia] sources. Compatible with `chjulia`
and `jlenv-chjl`.

## Features

* Supports installing arbitrary versions.
* Supports downloading the latest versions from [julia-versions].
* Verifies GPG signatures of Julia archives.
* Compatible with `chjulia` and the `jlenv` plugin `jlenv-chjl`.
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
* Supports verifying downloaded archives using `md5sum`, `md5` or `openssl md5`.
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

## Requirements

* [bash] >= 3.x
* [wget] > 1.12 or [curl]
* `md5sum`, `md5` or `openssl md5`.
* `tar`
* `bzip2`
* `patch` (if `--patch` is specified)
* [gcc] >= 4.2 or [clang]

## Synopsis

List supported Rubies and their major versions:

    $ julia-install

List the latest versions:

    $ julia-install --latest

Install the current stable version of Julia:

    $ julia-install julia

Install the latest version of Julia:

    $ julia-install --latest julia

Install a stable version of Julia:

    $ julia-install julia 2.3

Install a specific version of Julia:

    $ julia-install julia 2.2.4

Install a Julia into a specific directory:

    $ julia-install --install-dir /path/to/dir julia

Install a Julia into a specific `julias` directory:

    $ julia-install --julias-dir /path/to/julias/ julia

Install a Julia into `/usr/local`:

    $ julia-install --system julia 2.4.0

Install a Julia from an official site with directly download:

    $ julia-install -M https://ftp.julialang.org/pub/julia julia 2.4.0

Install a Julia from a mirror:

    $ julia-install -M http://www.mirrorservice.org/sites/ftp.julialang.org/pub/julia julia 1.0.0-p645

Install a Julia with a specific patch:

    $ julia-install -p https://raw.github.com/gist/4136373/falcon-gc.diff julia 1.9.3-p551

Install a Julia with a specific C compiler:

    $ julia-install julia 2.4.0 -- CC=gcc-4.9

Install a Julia with specific configuration:

    $ julia-install julia 2.4.0 -- --enable-shared --enable-dtrace CFLAGS="-O3"

Install a Julia without installing dependencies first:

    $ julia-install --no-install-deps julia 2.4.0

Uninstall a Julia version:

    $ rm -rf ~/.julias/julia-2.4.0

### Integration

Using julia-install with [RVM]:

    $ julia-install --julias-dir ~/.rvm/julias julia 2.4.0

Using julia-install with [jlenv]:

    $ julia-install --install-dir ~/.jlenv/versions/2.4.0 julia 2.4.0

julia-install can even be used with [Chef].

## Install

    wget -O julia-install-0.7.0.tar.gz https://github.com/jlenv/julia-install/archive/v0.7.0.tar.gz
    tar -xzvf julia-install-0.7.0.tar.gz
    cd julia-install-0.7.0/
    sudo make install

### PGP

All releases are [PGP] signed for security. Instructions on how to import my
PGP key can be found on my [blog][1]. To verify that a release was not tampered
with:

    wget https://raw.github.com/jlenv/julia-install/master/pkg/julia-install-0.7.0.tar.gz.asc
    gpg --verify julia-install-0.7.0.tar.gz.asc julia-install-0.7.0.tar.gz

### Homebrew

julia-install can also be installed with [homebrew]:

    brew install julia-install

Or the absolute latest julia-install can be installed from source:

    brew install julia-install --HEAD

### Arch Linux

julia-install is already included in the [AUR]:

    yaourt -S julia-install

### Fedora Linux

julia-install is available on [Fedora Copr](https://copr.fedorainfracloud.org/coprs/jlenv/julia-install/).

## Known Issues

### Julia

Rubies older than 1.9.3-p429 will not compile with [Clang][clang] and require
[GCC][gcc] >= 4.2. Normally, Linux and BSD systems will already have GCC
installed. OS X users can install GCC via [homebrew]:

    brew tap homebrew/versions
    brew install gcc49

And run julia-install again:

    julia-install julia 2.4.0 -- CC=gcc-4.9

# Contributing

## New Versions

**All new Julia versions or checksums should be submitted to the [julia-versions]
repository.**

## Code Style

* Tab indent code.
  * Spaces may be used to align multi-line commands.
* (Try to) Keep code within 80 columns.
* Use [bash] <= 3.x features.
* Quote all String variables.
* Use `(( ))` for arithmetic expressions and `[[ ]]` otherwise.
* Use `$(...)` instead of back-ticks.
* Use `${path##*/}` instead of `$(basename $path)`.
* Use `${path%/*}` instead of `$(dirname $path)`.
* Always use `"$@"` and `${array[@]}` instead of `$*` or `${arry[*]}`,
  respectively.
* Prefer single-line expressions where appropriate:

  ```bash
  [[ -n "$foo" ]] && other command

  if   [[ "$foo" == "bar" ]]; then command
  elif [[ "$foo" == "baz" ]]; then other_command
  fi

  case "$foo" in
    bar) command ;;
    baz) other_command ;;
  esac
  ```

* Use the `function` keyword for functions.
* Put curly braces on a new line so they align.
* Load function arguments into local variables for readability:

  ```bash
  function do_stuff()
  {
    local julia="$1"
    local version="$2"
    # ...
  }
  ```

* Explicitly return error codes with `|| return $?`.
* Keep branching logic to a minimum.
* Code should be declarative and easy to understand.

## Pull Request Guidelines

* Utility functions should go into `share/julia-install/julia-install.sh`.
* Generic installation steps should go into `share/julia-install/functions.sh`.
* Julia specific installation steps should go into
  `share/julia-install/$julia/functions.sh` and may override the generic steps in
  `share/julia-install/functions.sh`.
* Julia build dependencies should go into
  `share/julia-install/$julia/dependencies.txt`.
* All new code must have [shunit2] unit-tests.

### What Will Not Be Accepted

* Options for Julia specific `./configure` options. You can pass additional
  configuration options like so:

  ```bash
  julia-install julia 2.0 -- --foo --bar
  ```

* Excessive version or environment checks. This is the job of a `./configure`
  script.
* Excessive OS specific workarounds. We should strive to fix any Julia build
  issues or OS environment issues at their source.
* Building Rubies from HEAD. This is risky and may result in a buggy/broken
  version of Julia. The user should build development versions of Julia by hand
  and report any bugs to upstream.

## Change Log(#changelog)

The Change Log is [here](/changelog).

[Makefile]: https://gist.github.com/3224049
[shunit2]: http://code.google.com/p/shunit2/

[bash]: http://www.gnu.org/software/bash/

[Julia]: http://www.julialang.org/
[julia-install]: https://jlenv.github.io/julia-install
[julia-versions]: https://github.com/jlenv/julia-versions#readme

[apt]: http://wiki.debian.org/Apt
[dnf]: https://fedoraproject.org/wiki/Features/DNF
[yum]: http://yum.baseurl.org/
[pacman]: https://wiki.archlinux.org/index.php/Pacman
[zypper]: https://en.opensuse.org/Portal:Zypper
[pkg]: https://wiki.freebsd.org/pkgng
[macports]: https://www.macports.org/
[brew]: http://brew.sh

[bash]: http://www.gnu.org/software/bash/
[wget]: http://www.gnu.org/software/wget/
[curl]: http://curl.haxx.se/

[gcc]: http://gcc.gnu.org/
[clang]: http://clang.llvm.org/

[jlenv]: https://github.com/jlenv/jlenv#readme
[julia-build]: https://github.com/jlenv/julia-build#readme
[Chef]: https://github.com/jlenv/jlenv-cookbook#readme

[PGP]: http://en.wikipedia.org/wiki/Pretty_Good_Privacy
[1]: http://jlenv.github.io/contact.html#pgp

[homebrew]: http://brew.sh/
[AUR]: https://aur.archlinux.org/packages/julia-install/
