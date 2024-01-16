## make_override
#### #### #### #### #### #### #### #### #### #### 
# $@ = array of recipes
# autopkg_array function
make_override() {
	local arr=("$@")
	autopkg_array "make-override" "${arr[@]}" 
}
