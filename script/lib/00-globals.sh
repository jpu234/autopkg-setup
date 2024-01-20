## Global settings
#### #### #### #### #### #### #### #### #### #### 

source sources.sh

autopkg() { /usr/local/bin/autopkg $@; }

defaults_cmd() { /usr/bin/defaults $@; }

exit_with_error() { echo "$@" 1>&2; exit 1; }

copy_profile() { cat "profile.sh" >> ~/".zprofile"; }

write_defaults() { "$defaults_cmd" "write" ~/Library/Preferences/com.github.autopkg.plist $@; }