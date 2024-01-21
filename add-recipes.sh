#!/bin/bash
## Add some recipes to AutoPkg

source sources.sh || exit 1

for r in "${repos[@]}"; do
	echo "Loading repo ${r}..."
	if ! /usr/local/bin/autopkg "repo-add" "${r}" &> /dev/null; then
		echo "Unable to run action repo-add ${r}" 1>&2
		return 1
	fi
done
echo "Processed ${#repos[@]} items"
