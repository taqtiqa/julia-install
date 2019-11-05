#!/usr/bin/env bash

. ./test/helper.sh

file="./test/factory/file.txt"

gpg="file.txt.asc"

signatures_gpg="./test/signatures.gpg"

function oneTimeSetUp()
{
	cat <<EOS > "${signatures_gpg}"
1  foo.txt
9999  file.txt
1  file.txt
EOS
}

function test_supported_signatures()
{
	assertNotNull "did not detect the gpg signature utilility" "$gpgcmd"
}

function test_supported_source_control()
{
	assertNotNull "did not detect the git source control utilility" "$gitcmd"
}

function test_lookup_signature_id_gpg()
{
	assertEquals "did not return the expected GPG signature" \
		     "9999" \
		     "$(lookup_signature_id ${signatures_gpg} file.txt)"
}

function test_lookup_signature_with_missing_file()
{
	assertEquals "returned data when it should not have" \
		     "" \
		     "$(lookup_signature_id "$signatures_gpg" "missing.txt")"
}

function test_lookup_signature_with_duplicate_entries()
{
	cat <<EOS > duplicate_signatures.gpg
"$(basename "$file").asc"  $(basename "$file")
aaaaaa.aaa.aa.asc  $(basename "$file")
EOS

	assertEquals "did not return the first checksum for the file" \
		     "\"$gpg\"" \
		     "$(lookup_signature_id duplicate_signatures.gpg "$file")"

	rm duplicate_signatures.gpg
}

function test_compute_signature_gpg()
{
	julia_archive="hello-world.txt"
	local expected='Julia archive VERIFIED.'
	assertEquals "did not return the expected gpg checksum" \
		     "$expected" \
		     "$(compute_signature gpg)"
}

function test_compute_signature_with_missing_file()
{
	julia_archive="missing.txt"
	assertEquals "returned data when it should not have" \
		     "Julia archive NOT verified." \
		     "$(compute_signature gpg 2>/dev/null)"
}

function test_verify_signature_gpg()
{
	julia_archive="hello-world.txt"
	verify_signature "$file" gpg "Julia archive VERIFIED."
	assertEquals "signature was not valid" 0 $?
	
}

function oneTimeTearDown()
{
	rm "$signatures_gpg"
}

SHUNIT_PARENT=$0 . $SHUNIT2
