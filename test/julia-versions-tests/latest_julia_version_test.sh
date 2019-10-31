#!/usr/bin/env bash

. ./test/helper.sh
. ./share/julia-install/julia-versions.sh

julia="julia"
stable_file="$julia_install_cache_dir/$julia/stable.txt"

function oneTimeSetUp()
{
	download_julia_versions_file "$julia" "stable.txt"
}

function test_latest_julia_version_with_no_empty_string()
{
	local last_version="$(tail -n 1 "$stable_file")"
	local output="$(latest_julia_version "$julia" "")"

	assertEquals "did not return the last version" \
		     "$last_version" \
		     "$output"
}

function test_latest_julia_version_with_partial_version()
{
	local expected_version="$(grep -E '^2\.2\.' "$stable_file")"
	local partial_version="2.2"
	local output="$(latest_julia_version "$julia" "$partial_version")"

	assertEquals "did not return the matching version" \
		     "$expected_version" \
		     "$output"
}

SHUNIT_PARENT=$0 . $SHUNIT2
