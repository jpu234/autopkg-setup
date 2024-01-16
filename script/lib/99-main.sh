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
	get_repos "${repos[@]}"
	make_override "${overrides[@]}"
	copy_profile
	echo "Done!"
}

main
