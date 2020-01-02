#! /bin/sh

# This is an integration test for:
# julia-versions & julia-install
INSTALL_VERSION=1.3.1

function msg() {
  echo -e "\033[0;31m$1\033[0m"
}

msg "Install julia-install"
git clone --depth=1 https://github.com/taqtiqa-mark/julia-install
cd julia-install
git pull origin jl
make install

msg "Installing Julia using julia-install"
julia-install julia ${INSTALL_VERSION}

msg "Testing if the installed version is correct"
[[ $(julia -v) == "julia version $INSTALL_VERSION" ]]
