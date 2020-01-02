### 0.1.0 / 2019-10-31

Initial Julia release.

* Supports installing arbitrary versions.
* Supports downloading the latest versions and checksums from [julia-versions].
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

[xdg-spec]: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

[apt]: http://wiki.debian.org/Apt
[dnf]: https://fedoraproject.org/wiki/Features/DNF
[yum]: http://yum.baseurl.org/
[pacman]: https://wiki.archlinux.org/index.php/Pacman
[brew]: http://mxcl.github.com/homebrew/

[Julia]: http://www.julialang.org/

[julia-versions]: https://github.com/jlenv/julia-versions#readme
