#!/usr/bin/env bash

. ./test/helper.sh

function setUp()
{
	unset julia
	unset julia_cache_dir
}

function test_parse_julia_with_a_single_name()
{
	local expected_julia="julia"

	parse_julia "$expected_julia"

	assertEquals "did not return successfully" 0 $?
	assertEquals "did not set \$julia" "$expected_julia" "$julia"
}

function test_parse_julia_with_a_name_and_version()
{
	local expected_julia="julia"
	local expected_version="9.0.0"

	parse_julia "${expected_julia}-${expected_version}"

	assertEquals "did not return successfully" 0 $?
	assertEquals "did not set \$julia" "$julia" "$expected_julia"
	assertEquals "did not set \$julia_version" "$expected_version" \
						  "$julia_version"
}

function test_parse_julia_with_invalid_julia()
{
	parse_julia "foo" 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

SHUNIT_PARENT=$0 . $SHUNIT2
