#!/usr/bin/env bash

. ./test/helper.sh
. ./share/julia-install/julia-versions.sh

julia="julia"

function oneTimeSetUp()
{
	download_julia_versions_file "$julia" "stable.txt"
}

function test_stable_julia_versions()
{
	local expected_output="$(cat "$julia_install_cache_dir/$julia/stable.txt")"
	local output="$(stable_julia_versions "$julia")"

	assertEquals "did not read stable.txt" "$expected_output" "$output"
}

SHUNIT_PARENT=$0 . $SHUNIT2
