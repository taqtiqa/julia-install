#!/usr/bin/env bash

. ./test/helper.sh

function setUp()
{
	patches=()
	configure_opts=()
	make_opts=()

	unset julia
	unset julia_version
	unset src_dir
	unset install_dir
}

function test_parse_options_with_no_arguments()
{
	parse_options

	assertEquals "did not return 0" 0 $?
	assertNull "did not leave \$julia blank" "$julia"
	assertNull "did not leave \$julia_version blank" "$julia_version"
}

function test_parse_options_with_invalid_options()
{
	parse_options "--foo" "julia" >/dev/null 2>&1

	assertEquals "did not return 1" 1 $?
}

function test_parse_options_with_one_argument()
{
	local expected="julia"

	parse_options "$expected"

	assertEquals "did not set \$julia" "$expected" "$julia"
}

function test_parse_options_with_two_arguments()
{
	local expected_julia="julia"
	local expected_version="1.0.4"

	parse_options "$expected_julia" "$expected_version"

	assertEquals "did not set \$julia" "$expected_julia" "$julia"
	assertEquals "did not set \$julia_version" "$expected_version" \
		     				  "$julia_version"
}

function test_parse_options_with_more_than_two_arguments()
{
	parse_options "julia" "1.0.4" "foo" >/dev/null 2>&1

	assertEquals "did not return 1" 1 $?
}

function test_parse_options_with_install_dir()
{
	local expected="/usr/local/"

	parse_options "--install-dir" "$expected" "julia"

	assertEquals "did not set \$install_dir" "$expected" "$install_dir"
}

function test_parse_options_with_prefix()
{
	local expected="/usr/local/"

	parse_options "--prefix" "$expected" "julia"

	assertEquals "did not set \$install_dir" "$expected" "$install_dir"
}

function test_parse_options_with_system()
{
	local expected="/usr/local"

	parse_options "--system"

	assertEquals "did not set \$install_dir to $expected" "$expected" \
		                                              "$install_dir"
}

function test_parse_options_with_src_dir()
{
	local expected="~/src/"

	parse_options "--src-dir" "$expected" "julia"

	assertEquals "did not set \$src_dir" "$expected" "$src_dir"
}

function test_parse_options_with_jobs()
{
	local expected="--jobs"

	parse_options "$expected" "julia"

	assertEquals "did not set \$make_opts" "$expected" "${make_opts[0]}"
}

function test_parse_options_with_jobs_and_arguments()
{
	local expected="--jobs=4"

	parse_options "$expected" "julia"

	assertEquals "did not set \$make_opts" "$expected" "${make_opts[0]}"
}

function test_parse_options_with_patches()
{
	local expected=(patch1.diff patch2.diff)

	parse_options "--patch" "${expected[0]}" \
		      "--patch" "${expected[1]}" "julia"

	assertEquals "did not set \$patches" $expected $patches
}

function test_parse_options_with_mirror()
{
	local mirror="http://www.mirrorservice.org/sites/ftp.julialang.org/pub/julia"

	parse_options "--mirror" "$mirror" "julia"

	assertEquals "did not set \$julia_mirror" "$mirror" "$julia_mirror"
}

function test_parse_options_with_url()
{
	local url="http://mirror.s3.amazonaws.com/downloads/julia-1.2.3.tar.gz"

	parse_options "--url" "$url" "julia"

	assertEquals "did not set \$julia_url" "$url" "$julia_url"
}

function test_parse_options_with_gpg()
{
	local gpg="1"

	parse_options "--gpg" "$gpg" "julia"

	assertEquals "did not set \$julia_gpg" "$gpg" "$julia_gpg"
}

# function test_parse_options_with_package_manager()
# {
# 	local new_package_manager="dnf"

# 	set_package_manager "apt"

# 	parse_options "--package-manager" "$new_package_manager"

# 	assertEquals "did not set \$package_manager" "$new_package_manager" "$package_manager"
# }

function test_parse_options_with_no_download()
{
	parse_options "--no-download" "julia"

 	assertEquals "did not set \$no_download" 1 $no_download
}

function test_parse_options_with_no_verify()
{
	parse_options "--no-verify" "julia"

 	assertEquals "did not set \$no_verify" 1 $no_verify
}

function test_parse_options_with_no_verify()
{
	parse_options "--no-extract" "julia"

 	assertEquals "did not set \$no_extract" 1 $no_extract
 	assertEquals "did not set \$no_verify" 1 $no_verify
 	assertEquals "did not set \$no_download" 1 $no_download
}

function test_parse_options_with_no_install_deps()
{
	parse_options "--no-install-deps" "julia"

 	assertEquals "did not set \$no_install_deps" 1 $no_install_deps
}

function test_parse_options_with_no_reinstall()
{
	parse_options "--no-reinstall" "julia"

	assertEquals "did not set to \$no_reinstall" 1 $no_reinstall
}

function test_parse_options_with_additional_options()
{
	local expected=(--enable-shared CFLAGS="-03")

	parse_options "julia" "--" $expected

	assertEquals "did not set \$configure_opts" $expected $configure_opts
}

function test_parse_options_with_additional_options_with_spaces()
{
	parse_options "julia" "--" --enable-shared CFLAGS="-march=auto -O2"

	assertEquals "did not word-split \$configure_opts correctly" \
          'CFLAGS=-march=auto -O2' "${configure_opts[1]}"
}

SHUNIT_PARENT=$0 . $SHUNIT2
