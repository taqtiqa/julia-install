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
* `gpg`.
* `tar`
* `patch` (if `--patch` is specified)
* [gcc] >= 4.2 or [clang]

## Synopsis

List supported Julias and their major versions:

```bash
julia-install
```

List the latest versions:

```bash
julia-install --latest
```

Install the current stable version of Julia:

```bash
julia-install julia
```

Install the latest version of Julia:

```bash
julia-install --latest julia
```

Install a stable version of Julia:

```bash
julia-install julia 1.0
```

Install a specific version of Julia:

```bash
julia-install julia 1.0.4
```

Install a Julia into a specific directory:

```bash
julia-install --install-dir /path/to/dir julia
```

Install a Julia into a specific `julias` directory:

```bash
julia-install --julias-dir /path/to/julias/ julia
```

Install a Julia into `/usr/local`:

```bash
julia-install --system julia 1.0.4
```

Install a Julia from an official site with directly download:

```bash
julia-install -M https://ftp.julialang.org/pub/julia julia 1.0.4
```

Install a Julia from a mirror (hypothetical):

```bash
julia-install -M http://www.mirrorservice.org/sites/julialang.org/pub/julia julia 1.0.0-p15
```

Install a Julia with a specific patch:

```bash
julia-install -p https://raw.githubusercontent.com/JuliaLang/julia/master/deps/patches/SuiteSparse-shlib.patch" "local.patch julia 1.0.3-p1
```

Install a Julia with a specific C compiler:

```bash
julia-install julia 1.4.0 -- CC=gcc-4.9
```

Install a Julia with specific configuration:

```bash
julia-install julia 1.4.0 -- --enable-shared --enable-dtrace CFLAGS="-O3"
```

Install a Julia without installing dependencies first:

```bash
julia-install --no-install-deps julia 1.0.4
```

Uninstall a Julia version:

```bash
rm -rf ~/.julias/julia-1.0.4
```

### Integration

Using julia-install with [chjulia]:

```bash
julia-install --julias-dir /usr/local/share/julias julia 1.0.4
```

Using julia-install with [jlenv]:

```bash
julia-install --install-dir ~/.jlenv/julias/1.0.4 julia 1.0.4
```

`julia-install` can also be used with [Chef].

## Install

From archive:
```bash
ver=0.2.0
wget -O julia-install-${ver}.tar.gz https://github.com/jlenv/julia-install/archive/v${ver}.tar.gz
tar -xzvf julia-install-${ver}.tar.gz
cd julia-install-${ver}/
make install
```

From Git sources:

```bash
git clone --depth=1 https://github.com/jlenv/julia-install
cd julia-install/
make install
```

### Signify

All releases are [Signify] signed for security.
Instructions on how to import my Signify key can be found on my [blog][1].
To verify that a release was not tampered with:

```bash
wget https://raw.github.com/jlenv/julia-install/master/pkg/julia-install-0.7.0.tar.gz.asc
signify --verify julia-install-0.7.0.tar.gz.asc julia-install-0.7.0.tar.gz
```

### Homebrew

julia-install can also be installed with [homebrew]:

```bash
brew install julia-install
```

Or the absolute latest julia-install can be installed from source:

```bash
brew install julia-install --HEAD
```

### Arch Linux

julia-install is already included in the [AUR]:

```bash
yaourt -S julia-install
```

### Fedora Linux

julia-install is available on [Fedora Copr](https://copr.fedorainfracloud.org/coprs/jlenv/julia-install/).

## Known Issues

### Julia

Julias older than 1.9.3-p429 will not compile with [Clang][clang] and require
[GCC][gcc] >= 4.2. Normally, Linux and BSD systems will already have GCC
installed. OS X users can install GCC via [homebrew]:

```bash
brew tap homebrew/versions
brew install gcc49
```

And run julia-install again:

```bash
julia-install julia 1.0.4 -- CC=gcc-4.9
```

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
  `share/julia-install/$julia/functions.sh` and may override the generic
  steps in `share/julia-install/functions.sh`.
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
* Building Julias from HEAD. This is risky and may result in a buggy/broken
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

[Signify]: http://en.wikipedia.org/wiki/Pretty_Good_Privacy
[1]: http://jlenv.github.io/contact.html#pgp

[homebrew]: http://brew.sh/
[AUR]: https://aur.archlinux.org/packages/julia-install/
