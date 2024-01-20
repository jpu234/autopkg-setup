#### #### #### ./lib/00-globals.sh #### #### #### 
## Global settings
#### #### #### #### #### #### #### #### #### #### 

source sources.sh

autopkg() { /usr/local/bin/autopkg $@; }

defaults_cmd() { /usr/bin/defaults $@; }

exit_with_error() { echo "$@" 1>&2; exit 1; }

copy_profile() { cat "profile.sh" >> ~/".zprofile"; }

write_defaults() { "$defaults_cmd" "write" ~/Library/Preferences/com.github.autopkg.plist $@; }
#### #### #### ./lib/01-debug.sh #### #### #### 
## debug
#### #### #### #### #### #### #### #### #### #### 
# $1 = message to print
# scriptname - basename of the script
# debug_mode - set (true) if script sends debug messages
debug() {
	if [ -z "${debug_mode+x}" ]; then return; fi
	local timestamp=$(date +%Y-%m-%d\ %H:%M:%S)    
	echo "${timestamp} [${scriptname}]:  $@" 1>&2
}

#### #### #### ./lib/02-autopkg_array.sh #### #### #### 
## autopkg_array
#### #### #### #### #### #### #### #### #### #### 
# $@ = array of repos
# debug function
# autopkg function
autopkg_array() {
	debug "Starting autopkg_array function"
	local autopkg_action="$1" && shift
	local arr=("$@")
	debug "Got array (${arr[*]})"
	for r in "${arr[@]}"; do
		debug "Loading repo ${r}"
		if ! autopkg "${autopkg_action}" "${r}" &> /dev/null; then
			echo "Unable to run action ${autopkg_action} on ${r}" 1>&2
			return 1
		fi
	done
	echo "Processed ${#arr[@]} items"
}

#### #### #### ./lib/03-get_repos.sh #### #### #### 
## get_repos
#### #### #### #### #### #### #### #### #### #### 
# $@ = array of repos
# autopkg_array function
get_repos() {
	local arr=("$@")
	autopkg_array "repo-add" "${arr[@]}" 
}

#### #### #### ./lib/04-make_override.sh #### #### #### 
## make_override
#### #### #### #### #### #### #### #### #### #### 
# $@ = array of recipes
# autopkg_array function
make_override() {
	local arr=("$@")
	autopkg_array "make-override" "${arr[@]}" 
}

#### #### #### ./lib/05-userprompt.sh #### #### #### 
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
		read -r -p "Please enter the URL to the Jamf Pro server (starting with https): " servername
		if !url_validator "$JSS_URL"; then JSS_URL=""; fi
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

#### #### #### ./lib/99-main.sh #### #### #### 
main() {
	echo "Checking dependencies..."
	if ! git -v &> /dev/null; then 
		echo "Please install git"
		exit 1
	fi
	if ! autopkg version &> /dev/null; then
		echo "Please install autopkg"
		exit 1
	fi
	if ! defaults_cmd help &> /dev/null; then
		echo "Defaults command not found"
		exit 1
	fi

	user_prompt
	echo
	echo "Setting up autopkg..."
	echo
	echo "Loading repositories..."
	get_repos "${repos[@]}"
	echo
	echo "Creating overrides..."
	make_override "${overrides[@]}"
	echo
	echo "Copying profile..."
	copy_profile
	echo "Done!"
}

main

