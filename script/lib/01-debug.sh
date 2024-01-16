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
