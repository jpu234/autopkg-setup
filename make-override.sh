#!/bin/bash
## Add some recipes to AutoPkg

source sources.sh || exit 1

for r in "${overrides[@]}"; do
	echo "Loading recipe ${r}..."
	if ! /usr/local/bin/autopkg "make-override" "${r}" &> /dev/null; then
		echo "Unable to run action make-override ${r}" 1>&2
		return 1
	fi
done
echo "Processed ${#overrides[@]} items"
