#!/usr/bin/env bash

. ./test/helper.sh
. ./share/julia-install/signatures.sh

file="./test/factory/file.txt"

# gpg --no-default-keyring --keyring ./temp.keyring --import juliareleases.pub
# gpg --public-keyring tmp_keyring --encrypt myfile.txt 
# tmp_keyring
# $ gpg -v --no-default-keyring --keyring /tmp/mykey.gpg --output file.txt.asc --detach-sig /test/file.txt

gpg="file.txt.asc"

signatures_gpg="./test/signatures.gpg"

function oneTimeSetUp()
{
	echo -n "$data" > "$file"

	cat <<EOS > "${signatures_gpg}"
foo.txt.asc  foo.txt
"$(basename "$file").asc"  $(basename "$file")
bar.txt.asc  bar.txt
EOS
}

function test_supported_signatures()
{
	assertNotNull "did not detect the gpg signature utilility" "$gpgcmd"
	assertNotNull "did not detect the git source control utilility" "$gitcmd"
}

function test_lookup_signature_gpg()
{
	assertEquals "did not return the expected GPG signature" \
		     "\"${gpg}\"" \
		     "$(lookup_signature ${signatures_gpg} ${file})"
}

function test_lookup_signature_with_missing_file()
{
	assertEquals "returned data when it should not have" \
		     "" \
		     "$(lookup_signature "$signatures_gpg" "missing.txt")"
}

function test_lookup_signature_with_duplicate_entries()
{
	cat <<EOS > duplicate_signatures.gpg
"$(basename "$file").asc"  $(basename "$file")
aaaaaa.aaa.aa.asc  $(basename "$file")
EOS

	assertEquals "did not return the first checksum for the file" \
		     "\"$gpg\"" \
		     "$(lookup_signature duplicate_signatures.gpg "$file")"

	rm duplicate_signatures.gpg
}

function test_compute_signature_gpg()
{
	assertEquals "did not return the expected gpg checksum" \
		     "$gpg" \
		     "$(compute_signature gpg "${file}.asc" "$file")"
}

function test_compute_signature_with_missing_file()
{
	assertEquals "returned data when it should not have" \
		     "" \
		     "$(compute_signature gpg "missing.txt" 2>/dev/null)"
}

function test_verify_signature_gpg()
{
	verify_signature "$file" gpg "$gpg"

	assertEquals "signature was not valid" 0 $?
	
}


function oneTimeTearDown()
{
	rm "$file"
	rm "$signatures_gpg"
}

SHUNIT_PARENT=$0 . $SHUNIT2
