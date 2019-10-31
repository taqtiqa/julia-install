#!/usr/bin/env bash

. ./test/helper.sh
. ./share/julia-install/julia-versions.sh

julia="julia"
julia_archive="julia-1.0.0.tar.gz"

function oneTimeSetUp()
{
	download_julia_versions_file "$julia" "signatures.gpg"
}

function test_julia_signature_for_with_gpg()
{
	local expected_signature="julia-1.0.0.tar.gz.asc"
	local output="$(julia_signature_for "$julia" gpg "$julia_archive")"

	assertEquals "did not return the correct signature" \
		     "$expected_signature" \
		     "$output"
}

SHUNIT_PARENT=$0 . $SHUNIT2
