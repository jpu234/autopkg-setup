## Global settings
#### #### #### #### #### #### #### #### #### #### 

source sources.sh

autopkg() { /usr/local/bin/autopkg $@; }

exit_with_error() { echo "$@" 1>&2; exit 1; }

copy_profile() { cat "profile.sh" >> ~/".zprofile"; }