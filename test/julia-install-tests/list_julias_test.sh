#!/usr/bin/env bash

. ./test/helper.sh

function test_list_julias()
{
	local output="$(list_julias)"

	assertTrue "did not include julia" '[[ "$output" == *julia:* ]]'
}

SHUNIT_PARENT=$0 . $SHUNIT2
