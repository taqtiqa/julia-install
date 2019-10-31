[[ -z "$SHUNIT2"     ]] && SHUNIT2=/usr/share/shunit2/shunit2
[[ -n "$ZSH_VERSION" ]] && setopt shwordsplit

[ -n "$JLENV_DEBUG" ] && set -o xtrace

export HOME="$PWD/test/home"
export PATH="$PWD/bin:$PATH"

mkdir -p "$HOME"

. $PWD/share/julia-install/julia-install.sh

function oneTimeSetUp() { return; }
function setUp() { return; }
function tearDown() { return; }
function oneTimeTearDown() { return; }
