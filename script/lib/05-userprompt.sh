## user_prompt, url_validator
#### #### #### #### #### #### #### #### #### #### 

# JSS_URL
# api_mode
# API_USERNAME
# API_PASSWORD
# CLIENT_ID
# CLIENT_SECRET
# url_validator
# user_prompt
# write_defaults

url_validator() {
	local url="$1"
	if [ "${url::4}" != "http" ]; then return 1; fi
}

strip_slash() {  sed 's/\/$//' <<< "$1"; }

user_prompt() {
	debug "User prompt"
	local JSS_URL="$1"
	local api_mode="$2"
	local API_USERNAME="$3"
	local API_PASSWORD="$4"
	local CLIENT_ID="$5"
	local CLIENT_SECRET="$6"
	while [ -z "${JSS_URL}" ]; do
		read -r -p "Please enter the URL to the Jamf Pro server (starting with https): " JSS_URL
		if ! url_validator "$JSS_URL"; then JSS_URL=""; fi
		# strip the trailing slash if present
		JSS_URL=$(strip_slash "$JSS_URL")
	done
	
	if [ -z "$api_mode" ]; then
		read -r -p "Enter 'u' for username/password or press enter for client id/secret: " api_mode
	fi
	
	if [ "$api_mode" == "u" ]; then
		while [ -z "${API_USERNAME}" ]; do
			read -r -p "Please enter the Jamf Pro server username: " API_USERNAME
		done	
		while [ -z "${API_PASSWORD}" ]; do
			read -r -s -p "Please enter the Jamf Pro server password: " API_PASSWORD
		done
		if ! write_defaults "JSS_URL" "$JSS_URL"; then
			echo "Unable to write JSS_URL to defaults"; return 1
		fi
		if ! write_defaults "API_USERNAME" "$API_USERNAME"; then
			echo "Unable to write API_USERNAME to defaults"; return 1
		fi
		if ! write_defaults "API_PASSWORD" "$API_PASSWORD"; then
			echo "Unable to write API_PASSWORD to defaults"; return 1
		fi
	else
		while [ -z "${CLIENT_ID}" ]; do
			read -r -p "Please enter the Jamf Pro server API client ID: " CLIENT_ID
		done	
		while [ -z "${CLIENT_SECRET}" ]; do
			read -r -s -p "Please enter the Jamf Pro server API client secret: " CLIENT_SECRET
		done
		if ! write_defaults "JSS_URL" "$JSS_URL"; then
			echo "Unable to write JSS_URL to defaults"; return 1
		fi
		if ! write_defaults "CLIENT_ID" "$CLIENT_ID"; then
			echo "Unable to write CLIENT_ID to defaults"; return 1
		fi
		if ! write_defaults "CLIENT_SECRET" "$CLIENT_SECRET"; then
			echo "Unable to write CLIENT_SECRET to defaults"; return 1
		fi
	fi

}
