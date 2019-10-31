#!/usr/bin/env bash

. ./test/helper.sh
. ./share/julia-install/julia-versions.sh

julia="julia"
file="stable.txt"
expected_path="$julia_install_cache_dir/$julia/$file"

function test_download_julia_versions_file_with_no_parent_dir()
{
	rm -rf "$julia_install_cache_dir/$julia"

	download_julia_versions_file "$julia" "$file"

	assertTrue "did not create the parent dir" \
		   '[[ -d "$julia_install_cache_dir/$julia" ]]'
}

function test_download_julia_versions_file_first_time()
{
	mkdir -p "$julia_install_cache_dir/$julia"

	download_julia_versions_file "$julia" "$file"

	assertTrue "did not create the file" \
		   '[[ -f "$expected_path" ]]'
	assertTrue "did not write data to the file" \
		   '[[ -s "$expected_path" ]]'
}

function test_download_julia_versions_file_with_existing_file()
{
	mkdir -p "$julia_install_cache_dir/$julia"
	touch "$julia_install_cache_dir/$julia/$file"

	download_julia_versions_file "$julia" "$file"

	assertTrue "did not write data to the file" \
		   '[[ -s "$expected_path" ]]'
}

function tearDown()
{
	rm -rf "$julia_install_cache_dir/$julia"
}

SHUNIT_PARENT=$0 . $SHUNIT2
