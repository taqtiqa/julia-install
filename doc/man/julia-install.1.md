# julia-install 1 "Aug 2018" julia-install "User Manuals"

## SYNOPSIS

`julia-install` [[JULIA-VERSION | JULIA [VERSION]] [-- CONFIGURE_OPTS...]]

## DESCRIPTION

Installs Julia.

https://github.com/jlenv/julia-install#readme

## ARGUMENTS

*JULIA*
  Install Julia by name. Must be `julia`.

*VERSION*
	Optionally select the version of selected Julia.

*CONFIGURE_OPTS*
	Additional optional configure arguments.

## OPTIONS

`-r`, `--julias-dir` *DIR*
	Specifies the alternate directory where other Julia directories are
	installed, such as *~/.rvm/julias* or *~/.jlenv/versions*.
	Defaults to */opt/julias* for root and *~/.julias* for normal users.

`-i`, `--install-dir` *DIR*
	Specifies the directory where Julia will be installed.
	Defaults to */opt/julias/$julia-$version* for root and
	*~/.julias/$julia-$version* for normal users.

`--prefix` *DIR*
	Alias for `-i DIR`.

`--system`
	Alias for `-i /usr/local`.

`-s`, `--src-dir` *DIR*
	Specifies the directory for downloading and unpacking Julia source.

`-c`, `--cleanup`
	Remove the downloaded Julia archive and unpacked source-code after
	installation.

`-j[`*JOBS*`]`, `--jobs[=`*JOBS*`]`
	Specifies the number of *make* jobs to run in parallel when compiling
	Julia. If the -j option is provided without an argument, *make* will
	allow an unlimited number of simultaneous jobs.

`-p`, `--patch` *FILE*
	Specifies any additional patches to apply.

`-M`, `--mirror` *URL*
	Specifies an alternate mirror to download the Julia archive from.

`-u`, `--url` *URL*
	Alternate URL to download the Julia archive from.

`-m`, `--md5` *MD5*
	Specifies the MD5 checksum for the Julia archive.

`--sha1` *SHA1*
	Specifies the SHA1 checksum for the Julia archive.

`--sha256` *SHA256*
	Specifies the SHA256 checksum for the Julia archive.

`--sha512` *SHA512*
	Specifies the SHA512 checksum for the Julia archive.

`--package-manager [apt|dnf|yum|pacman|zypper|brew|pkg|port]`
  Use an alternative package manager.

`--no-download`
	Use the previously downloaded Julia archive.

`--no-verify`
	Do not verify the downloaded Julia archive.

`--no-extract`
	Do not extract the downloaded Julia archive. Implies `--no-download`
	and `--no-verify`.

`--no-install-deps`
	Do not install build dependencies before installing Julia.

`--no-reinstall`
	Skip installation if another Julia is detected in same location.

`-L`, `--latest`
	Downloads the latest julia versions and checksums from the julia-versions
	repository (https://github.com/jlenv/julia-versions#readme).

`-V`, `--version`
	Prints the current julia-install version.

`-h`, `--help`
	Prints a synopsis of julia-install usage.

## EXAMPLES

List supported Julias and their major versions:

    $ julia-install

List the latest versions:

    $ julia-install --latest

Install the current stable version of Julia:

    $ julia-install julia

Install the latest version of Julia:

    $ julia-install --latest julia

Install a latest version of Julia:

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

    $ julia-install -M http://www.mirrorservice.org/sites/ftp.julialang.org/pub/julia julia 2.4.0

Install a Julia with a specific patch:

    $ julia-install -p https://raw.github.com/gist/4136373/falcon-gc.diff julia 1.9.3-p551

Install a Julia with specific configuration:

    $ julia-install julia 2.4.0 -- --enable-shared --enable-dtrace CFLAGS="-O3"

Using julia-install with [RVM]:

    $ julia-install --julias-dir ~/.rvm/julias julia 2.4.0

Using julia-install with [jlenv]:

    $ julia-install -i ~/.jlenv/versions/2.4.0 julia 2.4.0

Uninstall a Julia version:

    $ rm -rf ~/.julias/julia-2.4.0

## FILES

*/usr/local/src*
	Default root user source directory.

*~/src*
	Default non-root user source directory.

*/opt/julias/$julia-$version*
	Default root user installation directory.

*~/.julias/$julia-$version*
	Default non-root user installation directory.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>
MArk Van de Vyver <mark@taqtiqa.com>

## SEE ALSO

julia(1), jlenv(1), chjulia(1), chjulia-exec(1)
