main() {
	echo "Checking dependencies"
	if ! git -v &> /dev/null; then 
		echo "Please install git"
		exit 1
	fi
	if ! autopkg version &> /dev/null; then
		echo "Please install autopkg"
		exit 1
	fi

	echo "Setting up autopkg"
	echo
	echo "Loading repositories"
	get_repos "${repos[@]}"
	echo
	echo "Creating overrides"
	make_override "${overrides[@]}"
	echo
	echo "Copying profile"
	copy_profile
	echo "Done!"
}

main
