source lib/02-autopkg-array.sh || exit 1
# set up
debug() { :; }
# debug() { echo "$@" 1>&2; }
autopkg() { echo -n "a:$@ "; }


# tests

input_array=("one" "two three" "four")
expect_result \
	"Basic autopkg-array" \
	"a:cmd one &> /dev/null a:cmd two three &> /dev/null a:cmd four &> /dev/null " \
	autopkg-array "cmd" "${input_array[@]}"

expect_succeed "Function autopkg-array" autopkg-array 'one' 'two three' 'four'
autopkg() { return 1; }
expect_fail "Function error autopkg-array" autopkg-array 'one' 'two three' 'four'


# tear down
unset -f autopkg-array
unset -f debug
unset -f autopkg
unset input_array