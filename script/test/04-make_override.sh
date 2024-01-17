source lib/02-autopkg_array.sh || exit 1
source lib/04-make_override.sh || exit 1
# set up
debug() { :; }
# debug() { echo "$@" 1>&2; }
autopkg() { echo -n "$@"; }


# tests

input_array=("one" "two three" "four")
expect_result \
	"Basic make_override" \
	"Processed 3 items" \
	make_override "${input_array[@]}"


# tear down
unset -f autopkg_array
unset -f make_override
unset -f debug
unset -f autopkg
unset input_array
