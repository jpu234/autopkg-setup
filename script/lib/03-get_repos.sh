## get_repos
#### #### #### #### #### #### #### #### #### #### 
# $@ = array of repos
# autopkg_array function
get_repos() {
	local arr=("$@")
	autopkg_array "repo-add" "${arr[@]}" 
}
