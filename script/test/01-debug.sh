source lib/01-debug.sh || exit 1
# set up
date() { echo "DATE"; }
scriptname="SCRIPT"


# tests
declare debug_mode
expect_error \
	"Basic debug stderr" \
	"DATE [SCRIPT]:  Error message" \
	"" \
	debug Error message
unset debug_mode

expect_error \
	"Diabled debug" \
	"" \
	"" \
	"debug "Error message""


# tear down
unset -f date
unset -f debug
unset scriptname
unset debug_mode
