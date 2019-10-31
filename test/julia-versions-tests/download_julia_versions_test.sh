#!/usr/bin/env bash

. ./test/helper.sh
. ./share/julia-install/julia-versions.sh

julia="julia"

function setUp()
{
	rm -rf "$julia_install_cache_dir/$julia"
}

function test_download_julia_versions()
{
	download_julia_versions "$julia"

	for file in {stable,versions}.txt signatures.gpg; do
		assertTrue "did not create the $file file" \
			   "[[ -f \"\$julia_install_cache_dir/\$julia/$file\" ]]"
		assertTrue "did not write data to the $file file" \
			   "[[ -s \"\$julia_install_cache_dir/\$julia/$file\" ]]"
	done
}

function tearDown()
{
	rm -rf "$julia_install_cache_dir/$julia"
}

SHUNIT_PARENT=$0 . $SHUNIT2
