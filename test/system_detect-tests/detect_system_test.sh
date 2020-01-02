#!/usr/bin/env bash

. ./test/helper.sh

function setUp()
{
	detect_system
}

function test_detect_system_name_lowercase()
{
	assertEquals "did not detect system name" "ubuntu" "$ji_system_name_lowercase" 
}

function test_detect_system_version_lowercase()
{
	command -v dnf >/dev/null || return

	assertEquals "did not detect system version" "18.04" "$ji_system_version_lowercase"
}

function test_detect_system_type_lowercase()
{
	assertEquals "did not detect system name" "linux" "$ji_system_type_lowercase" 
}

function test_detect_system_arch_lowercase()
{
	assertEquals "did not detect system name" "x86_64" "$ji_system_arch_lowercase" 
}

SHUNIT_PARENT=$0 . $SHUNIT2
