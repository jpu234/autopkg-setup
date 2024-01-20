#!/bin/bash

if /usr/bin/tput -V &> /dev/null; then
	RESULTS_POSITION=$(($(/usr/bin/tput cols ) * 3 / 5 ))
	if tput colors &> /dev/null && [ $(tput colors) -gt 8 ]
		then declare RESULTS_COLOR_MODE
	fi
else RESULTS_POSITION=60
fi

report_print() {
	local status="$1"; shift
	local test_name="$1"; shift
	local BOLD RED GREEN ENDCOLOR
	printf "%-${RESULTS_POSITION}s " " * ${test_name}" # Test name padded
	if [ -n "${RESULTS_COLOR_MODE+x}" ]; then 
		BOLD="\x1b[1m"
		RED="\x1b[31m"
		GREEN="\x1b[32m"
		ENDCOLOR="\x1b[0m"
	fi
	if [ "${status}" == "ok" ]; then
		printf "[${BOLD}${GREEN} %s ${ENDCOLOR}]\n" "OK"
	else
		printf "[${BOLD}${RED} %s ${ENDCOLOR}]\n" "FAIL"
		echo
		echo -e "$@"
		exit 1
	fi
}

expect_equal() { [ "${2}" == "${3}" ] &&  report_print "ok" "$1" ||  report_print "fail" "$1" "${2}"; }

expect_result() {
	local fcn_name=$1; shift
	local fcn_expect=$1; shift
	local fcn_result=$("$@")
	expect_equal "$fcn_name" "$fcn_result" "$fcn_expect"
}

expect_error() {
	local fcn_name=$1; shift
	local fcn_err_expect=$1; shift
	local fcn_out_expect=$1; shift
	local cmd=$1; shift
	local fcn_err_result=$( ($cmd $@) 2>&1 > /dev/null )
	local fcn_out_result=$( ($cmd $@) 2> /dev/null )
	expect_equal "$fcn_name (stderr)" "$fcn_err_result" "$fcn_err_expect"
	expect_equal "$fcn_name (stdout)" "$fcn_out_result" "$fcn_out_expect"
}

expect_succeed() {
	local fcn_name=$1; shift
	local fcn_command=$1; shift
	"$fcn_command" $@ &> /dev/null && report_print "ok" "$fcn_name" || report_print "fail" "$fcn_name"
	
}

expect_fail() {
	local fcn_name=$1; shift
	local fcn_command=$1; shift
	"$fcn_command" $@ &> /dev/null && report_print "fail" "$fcn_name" || report_print "ok" "$fcn_name"
}

scriptname="installer.sh"
echo "Testing functions in $scriptname"
for f in "./test"/*; do
	echo "#### #### #### $f #### #### #### "
	echo
	source "$f"
	echo
done
echo "#### #### #### All Tests Complete #### #### #### "
echo "Done"
