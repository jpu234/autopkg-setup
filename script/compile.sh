#!/bin/bash
scriptname="installer.sh"
echo "Compiling to $scriptname"
for f in "./lib"/*; do
	echo "  Processing $f"
	echo "#### #### #### $f #### #### #### " >> "${scriptname}"
	cat "$f" >> "${scriptname}"
	echo >> "${scriptname}"
done
echo "Added all files"
chmod +x "${scriptname}"
mv "${scriptname}" ..
echo "Done"
