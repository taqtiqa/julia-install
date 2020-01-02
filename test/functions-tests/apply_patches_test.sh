#!/usr/bin/env bash

. ./test/helper.sh
. ./share/julia-install/functions.sh

julia_dir_name="julia-1.0.3-p1"
patches=("$src_dir/$julia_dir_name/test/factory/test.diff")

function setUp()
{
	mkdir -p "$src_dir/$julia_dir_name/test/factory/"
	echo "diff -Naur $julia_dir_name.orig/test $julia_dir_name/test
--- $julia_dir_name.orig/test 1970-01-01 01:00:00.000000000 +0100
+++ $julia_dir_name/test  2013-08-02 20:57:08.055843749 +0200
@@ -0,0 +1 @@
+patch
" > "${patches[0]}"
}

function test_apply_patches()
{
	cd "$src_dir/$julia_dir_name"
	apply_patches >/dev/null
	cd $OLDPWD

	assertTrue "did not apply downloaded patches" \
		   '[[ -f "$src_dir/$julia_dir_name/test/factory/test.diff" ]]'
}

function tearDown()
{
	rm -r "$src_dir/$julia_dir_name"
	return
}

SHUNIT_PARENT=$0 . $SHUNIT2
