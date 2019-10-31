#!/usr/bin/env bash

. ./test/helper.sh

install_dir="./test/dir"

function setUp()
{
	mkdir -p "$install_dir/bin"
	touch -m "$install_dir/bin/julia"
	chmod +x "$install_dir/bin/julia"
}

function test_no_reinstall_when_julia_executable_exists()
{
	local output="$(julia-install --install-dir "$install_dir" --no-reinstall julia)"

	assertEquals "did not return 0" 0 $?
	assertTrue "did not print a message to STDOUT" \
		'[[ "$output" == *"already installed"* ]]'
}

function tearDown()
{
	rm -r "$install_dir"
}

SHUNIT_PARENT=$0 . $SHUNIT2
