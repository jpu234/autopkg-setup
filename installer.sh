#### #### #### ./lib/00-globals.sh #### #### #### 
## Global settings
#### #### #### #### #### #### #### #### #### #### 

source sources.sh

autopkg() { /usr/local/bin/autopkg $@; }

exit_with_error() { echo "$@" 1>&2; exit 1; }

copy_profile() { cat "profile.sh" >> "~/.zprofile"; }
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

#### #### #### ./lib/02-autopkg-array.sh #### #### #### 
## autopkg-array
#### #### #### #### #### #### #### #### #### #### 
# $@ = array of repos
# debug function
# autopkg function
autopkg-array() {
	debug "Starting autopkg-array function"
	local autopkg_action="$1" && shift
	local arr=("$@")
	debug "Got array (${arr[*]})"
	for r in "${arr[@]}"; do
		debug "Loading repo ${r}"
		if ! autopkg "${autopkg_action} ${r} &> /dev/null"; then
			echo "Unable to run action ${autopkg_action} on ${r}" 1>&2
			return 1
		fi
	done
}

#### #### #### ./lib/03-get-repos.sh #### #### #### 
## get-repos
#### #### #### #### #### #### #### #### #### #### 
# $@ = array of repos
# autopkg-array function
get-repos() {
	local arr=("$@")
	autopkg-array "repo-add" "${arr[@]}" 
}

#### #### #### ./lib/04-make-override.sh #### #### #### 
## make-override
#### #### #### #### #### #### #### #### #### #### 
# $@ = array of recipes
# autopkg-array function
make-override() {
	local arr=("$@")
	autopkg-array "make-override" "${arr[@]}" 
}

#### #### #### ./lib/99-main.sh #### #### #### 
main() {
	echo "Setting up autopkg"
	get-repos "${repos[@]}"
	make-override "${overrides[@]}"
	copy_profile
	echo "Done!"
}

main

