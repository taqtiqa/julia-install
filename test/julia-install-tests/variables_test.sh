#!/usr/bin/env bash

. ./test/helper.sh

function test_julia_install_version()
{
	assertTrue "did not set \$julia_install_version" \
		   '[[ -n "$julia_install_version" ]]'
}

function test_julia_install_dir()
{
	local expected_julia_install_dir="$PWD/share/julia-install"

	assertEquals "was not ./share/julia-install" \
		     "$expected_julia_install_dir" \
		     "$julia_install_dir"
}

function test_julia_install_cache_dir()
{
	if [[ -n "$XDG_CACHE_HOME" ]]; then
		assertTrue "did not use \$XDG_CACHE_HOME/" \
			   '[[ "$julia_install_cache_dir" == "$XDG_CACHE_HOME/"* ]]'
	else
		assertTrue "did not use \$HOME/.cache/" \
			   '[[ "$julia_install_cache_dir" == "$HOME/.cache/"* ]]'
	fi
}

function test_julias()
{
	for julia in julia; do
		assertTrue "did not contain $julia" \
			   "[[ \" \${julias[@]} \" == *\" $julia \"* ]]"
	done
}

function test_patches()
{
	assertEquals "\$patches was not empty" 0 "${#patches[@]}"
}

function test_configure_opts()
{
	assertEquals "\$configure_opts was not empty" 0 "${#configure_opts[@]}"
}

function test_make_opts()
{
	assertEquals "\$make_opts was not empty" 0 "${#make_opts[@]}"
}

function test_src_dir()
{
	if (( UID == 0 )); then
		assertEquals "did not set \$src_dir correctly" \
			     "/usr/local/src" "$src_dir"
	else
		assertEquals "did not set \$src_dir correctly" \
			     "$HOME/src" "$src_dir"
	fi
}

function test_julias_dir()
{
	if (( UID == 0 )); then
		assertEquals "did not set \$julias_dir correctly" \
			     "/opt/julias" "$julias_dir"
	else
		assertEquals "did not set \$julias_dir correctly" \
			     "$HOME/.julias" "$julias_dir"
	fi
}

SHUNIT_PARENT=$0 . $SHUNIT2
