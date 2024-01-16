source lib/02-autopkg_array.sh || exit 1
source lib/03-get_repos.sh || exit 1
# set up
debug() { :; }
# debug() { echo "$@" 1>&2; }
autopkg() { echo -n "$@"; }


# tests

input_array=("one" "two three" "four")
expect_result \
	"Basic get_repos" \
	"repo-add one &> /dev/nullrepo-add two three &> /dev/nullrepo-add four &> /dev/null" \
	get_repos "${input_array[@]}"


# tear down
unset -f autopkg_array
unset -f get_repos
unset -f debug
unset -f autopkg
unset input_array