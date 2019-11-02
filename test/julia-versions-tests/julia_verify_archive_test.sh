#!/usr/bin/env bash

. ./test/helper.sh
. ./share/julia-install/julia-versions.sh

julia="julia"
julia_archive="julia-1.0.0.tar.gz"

function oneTimeSetUp()
{
	download_julia_versions_file "$julia" "signatures.gpg"
}

function setUp()
{
	mkdir -p "$src_dir/$julia_dir_name"
}

function setUp()
{
	unset julia_archive
	#unset src_dir
	#src_dir="$PWD/test/factory"
	cp "$PWD/test/factory/hello-world.txt" "${src_dir}"
	cp "$PWD/test/factory/hello-world.txt.asc" "${src_dir}"
  julia_archive="hello-world.txt"
}
function test_julia_signature_for_with_gpg()
{ 
	setup_julia_public_key 9999
	local expected_signature="julia-1.0.0.tar.gz.asc"
	local output="$(verify_archive_signature)"

	assertEquals "did not return the correct signature" \
		     "$expected_signature" \
		     "$output"
}

# function tearDown()
# {
# 	# rm -r "$src_dir/$julia_dir_name"
# }

SHUNIT_PARENT=$0 . $SHUNIT2
