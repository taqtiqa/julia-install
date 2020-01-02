#!/usr/bin/env bash

. ./test/helper.sh
. ./share/julia-install/functions.sh

patches=("https://raw.githubusercontent.com/JuliaLang/julia/master/deps/patches/SuiteSparse-shlib.patch" "local.patch")
julia_dir_name="julia-1.0.3-p1"

function setUp()
{
	mkdir -p "$src_dir/$julia_dir_name"
}

function test_download_patches()
{
	download_patches 2>/dev/null

	assertTrue "did not download patches to \$src_dir/\$julia_dir_name" \
		   '[[ -f "$src_dir/$julia_dir_name/SuiteSparse-shlib.patch" ]]'
	assertEquals "did not update \$patches" \
		     "${patches[0]}" "$src_dir/$julia_dir_name/SuiteSparse-shlib.patch"
}

function tearDown()
{
	rm -r "$src_dir/$julia_dir_name"
	return
}

SHUNIT_PARENT=$0 . $SHUNIT2
