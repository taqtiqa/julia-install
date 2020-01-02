#!/usr/bin/env bash

. ./test/helper.sh
. ./share/julia-install/julia-versions.sh

julia="julia"
stable_file="$julia_install_cache_dir/$julia/stable.txt"

function oneTimeSetUp()
{
	download_julia_versions_file "$julia" "stable.txt"
	download_julia_versions_file "$julia" "versions.txt"
}

function test_look_julia_version_with_known_version()
{
	local known_version="1.0.1"
	local output="$(lookup_julia_version "$julia" "$known_version")"

	assertEquals "did not return the same version" \
		     "$known_version" \
		     "$output"
}

function test_lookup_julia_version_with_empty_string()
{
	local last_version="$(tail -n 1 "$stable_file")"
	local output="$(lookup_julia_version "$julia" "")"

	assertEquals "did not return the latest version" \
		     "$last_version" \
		     "$output"
}

function test_lookup_julia_version_with_partial_version()
{
	local partial_version="2.2"
	local expected_version="$(grep -E '^2\.2\.' "$stable_file")"
	local output="$(lookup_julia_version "$julia" "$partial_version")"

	assertEquals "did not return the matching version" \
		     "$expected_version" \
		     "$output"
}

SHUNIT_PARENT=$0 . $SHUNIT2
