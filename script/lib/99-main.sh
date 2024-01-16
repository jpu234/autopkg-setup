main() {
	echo "Setting up autopkg"
	get-repos "${repos[@]}"
	make-override "${overrides[@]}"
	copy_profile
	echo "Done!"
}

main
