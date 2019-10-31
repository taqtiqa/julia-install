#!/usr/bin/env bash

. ./test/helper.sh
. ./share/julia-install/julia-versions.sh

julia="julia"

function oneTimeSetUp()
{
	rm -rf "$julia_install_cache_dir"
}

function test_are_julia_versions_missing_with_no_parent_dir()
{
	are_julia_versions_missing "$julia"

	assertEquals "did not return 0" 0 $?
}

function test_are_julia_versions_missing_with_no_julia_dir()
{
	mkdir -p "$julia_install_cache_dir"

	are_julia_versions_missing "$julia"

	assertEquals "did not return 0" 0 $?
}

function test_are_julia_versions_missing_with_no_files()
{
	mkdir -p "$julia_install_cache_dir/$julia"

	are_julia_versions_missing "$julia"

	assertEquals "did not return 0" 0 $?
}

function test_are_julia_versions_missing_with_some_files()
{
	mkdir -p "$julia_install_cache_dir/$julia"
	touch "$julia_install_cache_dir/$julia/stable.txt"

	are_julia_versions_missing "$julia"

	assertEquals "did not return 0" 0 $?
}

function test_are_julia_versions_missing_with_all_files()
{
	mkdir -p "$julia_install_cache_dir/$julia"

	for file in "${julia_versions_files[@]}"; do
		touch "$julia_install_cache_dir/$julia/$file"
	done

	are_julia_versions_missing "$julia"

	assertEquals "did not return 1" 1 $?
}

function tearDown()
{
	rm -rf "$julia_install_cache_dir"
}

SHUNIT_PARENT=$0 . $SHUNIT2
