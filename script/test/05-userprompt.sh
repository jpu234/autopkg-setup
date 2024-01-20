source lib/05-userprompt.sh || exit 1

# set up
debug() { :; }

write_defaults() { 
	results="${results}defaults write ${@}\n"
}


# tests
## check url_validator for http and not http
expect_fail \
	"check url_validator for not http" \
	url_validator "someserver.com"

expect_succeed \
	"check url_validator for http" \
	url_validator "http://someserver.com"
	
## check strip_slash for url ending with a slash
result=$(strip_slash "https://test_server.com/")
expect_equal "check strip_slash for url ending with a slash" \
	"$result" "https://test_server.com"

## check strip_slash for url ending with no slash
result=$(strip_slash "https://test_server.com")
expect_equal "check strip_slash for url ending with no slash" \
	"$result" "https://test_server.com"

# check write values for username/password
expect_succeed \
	"Check user/password succeess" \
	user_prompt "https://test_server.com" "u" "u" "p"

results=""
user_prompt "https://test_server.com" "u" "test username" "test password"
expect_equal "Check write values for username/password" \
	"${results}" "defaults write JSS_URL https://test_server.com\ndefaults write API_USERNAME test username\ndefaults write API_PASSWORD test password\n"

# check write values for client id/secret
results=""
expect_succeed \
	"Check client id/secret succeess" \
	user_prompt "https://test_server.com" "c" "" "" "test client id" "test client secret"

results=""
user_prompt "https://test_server.com" "c" "" "" "test client id" "test client secret"
expect_equal "Check write values for client id/secret" "${results}" \
	"defaults write JSS_URL https://test_server.com\ndefaults write CLIENT_ID test client id\ndefaults write CLIENT_SECRET test client secret\n"


# tear down
unset -f url_validator
unset -f user_prompt
unset -f write_defaults
unset -f strip_slash
unset result