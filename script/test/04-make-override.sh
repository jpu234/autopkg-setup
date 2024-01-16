source lib/02-autopkg-array.sh || exit 1
source lib/04-make-override.sh || exit 1
# set up
debug() { :; }
# debug() { echo "$@" 1>&2; }
autopkg() { echo -n "$@"; }


# tests

input_array=("one" "two three" "four")
expect_result \
	"Basic make-override" \
	"make-override one &> /dev/nullmake-override two three &> /dev/nullmake-override four &> /dev/null" \
	make-override "${input_array[@]}"


# tear down
unset -f autopkg-array
unset -f make-override
unset -f debug
unset -f autopkg
unset input_array