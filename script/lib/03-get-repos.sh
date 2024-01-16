## get-repos
#### #### #### #### #### #### #### #### #### #### 
# $@ = array of repos
# autopkg-array function
get-repos() {
	local arr=("$@")
	autopkg-array "repo-add" "${arr[@]}" 
}
