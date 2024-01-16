#!/bin/bash

if /usr/bin/tput -V &> /dev/null; then
	RESULTS_POSITION=$(($(/usr/bin/tput cols ) * 3 / 5 ))
	if tput colors &> /dev/null && [ $(tput colors) -gt 8 ]
		then declare RESULTS_COLOR_MODE
	fi
else RESULTS_POSITION=60
fi

report_print() {
	printf "%-${RESULTS_POSITION}s " " * $1" # Test name padded
	local BOLD RED GREEN ENDCOLOR
	if [ -n "${RESULTS_COLOR_MODE+x}" ]; then 
		BOLD="\x1b[1m"
		RED="\x1b[31m"
		GREEN="\x1b[32m"
		ENDCOLOR="\x1b[0m"
	fi
	if [ "$2" == "ok" ]; then
		printf "[${BOLD}${GREEN} %s ${ENDCOLOR}]\n" "OK"
	else
		printf "[${BOLD}${RED} %s ${ENDCOLOR}]\n" "FAIL"
	fi
}

report_ok() { report_print "$@" "ok"; }

report_fail() {
	
	local BOLDRED="\033[1m\033[31m"
	local ENDCOLOR="\033[0m"
 	echo -e " *  $1 \t[ ${BOLDRED}FAIL${ENDCOLOR} ]"
	shift
	echo
	echo -e "$@"
	exit 1
}

expect_equal() {
	if [ "${2}" == "${3}" ]
		then report_ok "$1"
		else report_fail "$1" "${2}"
	fi
}

expect_result() {
	local fcn_name=$1
	shift
	local fcn_expect=$1
	shift
	local fcn_result=$("$@")
	expect_equal "$fcn_name" "$fcn_result" "$fcn_expect"
}

expect_error() {
	local fcn_name=$1
	shift
	local fcn_err_expect=$1
	shift
	local fcn_out_expect=$1
	shift
	local cmd=$1
	shift
	local fcn_err_result=$( ($cmd "$@") 2>&1 > /dev/null )
	local fcn_out_result=$( ($cmd "$@") 2> /dev/null )
	expect_equal "$fcn_name (stderr)" "$fcn_err_result" "$fcn_err_expect"
	expect_equal "$fcn_name (stdout)" "$fcn_out_result" "$fcn_out_expect"
}

expect_succeed() {
	local fcn_name=$1
	shift
	$( ($@) 2>&1 > /dev/null ) &> /dev/null && report_ok "$fcn_name" || report_fail "$fcn_name"
}

expect_fail() {
	local fcn_name=$1
	shift
	$( ($@) 2>&1 > /dev/null ) &> /dev/null && report_fail "$fcn_name" || report_ok "$fcn_name"
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
