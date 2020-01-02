#!/usr/bin/env bash

. ./test/helper.sh
. ./share/julia-install/julia-versions.sh

julia="julia"

function oneTimeSetUp()
{
	download_julia_versions_file "$julia" "versions.txt"
}

function test_is_known_julia_version()
{
	local version="1.0.4"

	is_known_julia_version "$julia" "$version"

	assertEquals "did not return 0" 0 $?
}

function test_is_known_julia_version_with_unknown_version()
{
	local version="9.9.9"

	is_known_julia_version "$julia" "$version"

	assertEquals "did not return 1" 1 $?
}

SHUNIT_PARENT=$0 . $SHUNIT2
