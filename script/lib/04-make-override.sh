## make-override
#### #### #### #### #### #### #### #### #### #### 
# $@ = array of recipes
# autopkg-array function
make-override() {
	local arr=("$@")
	autopkg-array "make-override" "${arr[@]}" 
}
