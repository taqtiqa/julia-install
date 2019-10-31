#!/usr/bin/env bash

. ./test/helper.sh

function oneTimeSetUp()
{
	julia="julia"

	download_julia_versions "$julia"
}

function setUp()
{
	julia="julia"
	julia_version="1.0"

	expected_julia_version="$(latest_version "$julia_install_cache_dir/$julia/stable.txt" "$julia_version")"
}

function test_init()
{
	init

	assertEquals "did not return 0" 0 $?
}

function test_julia_version()
{
	init

	assertEquals "did not expand julia_version" \
		     "$expected_julia_version" \
		     "$julia_version"
}

function test_julia_version_with_unknown_version()
{
	local expected_julia_version="9000"

	julia_version="$expected_julia_version"

	local output=$(init 2>&1)

	assertTrue "did not print a warning" \
		   '[[ $output == *"*** Unknown julia version $expected_julia_version."* ]]'
	assertEquals "did not preserve julia_version" \
		     "$expected_julia_version" \
		     "$julia_version"
}

function test_init_with_julia_url()
{
	local url="http://mirror.s3.amazonaws.com/downloads/julia-1.2.3.tar.gz"

	julia_url="$url"
	init

	assertEquals "did not preserve julia_url" "$url" "$julia_url"
}

function test_init_julia_gpg()
{
	init

	assertNotNull "did not set julia_gpg" $julia_gpg
}

function test_init_with_julia_gpg()
{
	local gpg="b1946ac92492d2347c6235b4d2611184"

	julia_gpg="$gpg"
	init

	assertEquals "did not preserve julia_gpg" "$gpg" "$julia_gpg"
}

function test_julias_dir()
{
	init

	if (( UID == 0 )); then
		assertEquals "did not correctly default julias_dir" \
			     "/opt/julias" \
			     "$julias_dir"
	else
		assertEquals "did not correctly default julias_dir" \
			     "$HOME/.julias" \
			     "$julias_dir"
	fi
}

function test_julia_cache_dir()
{
	init

	assertEquals "did not correctly set julia_cache_dir" \
		     "$julia_install_cache_dir/$julia" \
		     "$julia_cache_dir"
}

function test_install_dir()
{
	init

	assertEquals "did not correctly default install_dir" \
		     "$julias_dir/$julia-$expected_julia_version" \
		     "$install_dir"
}

function tearDown()
{
	unset install_dir julia_cache_dir
	unset julia julia_version julia_gpg julia_archive julia_url
}

SHUNIT_PARENT=$0 . $SHUNIT2
