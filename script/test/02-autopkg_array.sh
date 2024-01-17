source lib/02-autopkg_array.sh || exit 1
# set up
debug() { :; }
# debug() { echo "$@" 1>&2; }
autopkg() { echo -n "a:$@ "; }


# tests

input_array=("one" "two three" "four")
expect_result \
	"Basic autopkg_array" \
	"Processed 3 items" \
	autopkg_array "cmd" "${input_array[@]}"

expect_succeed "Function autopkg_array" autopkg_array 'one' 'two three' 'four'
autopkg() { return 1; }
expect_fail "Function error autopkg_array" autopkg_array 'one' 'two three' 'four'


# tear down
unset -f autopkg_array
unset -f debug
unset -f autopkg
unset input_array