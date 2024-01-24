# autopkg-setup

Instructions for setting up AutoPkg on local machines, including a few scripts that we can keep up to date here. They have been updated in 2024 with an added script.

# Steps to install

[Setup](#setup)

Script Installation

Installation with Scripts

Manual Installation

## Setup

For any method of installation, start by installing Git and AutoPkg.

### Installing git

`git` is part of 



1. Install AutoPkg
2. Install `git`
3. Add AutoPkg Recipes
4. Make Recipe Overrides
5. Set Up Server Credentials
6. Set Up Profile (optional)
7. Test

## Install AutoPkg

First, find the latest version of AutoPkg. You can use its [GitHub repo](https://github.com/autopkg/autopkg/releases/latest) or by running the Terminal command: 

`curl -s https://api.github.com/repos/autopkg/autopkg/releases/latest | grep "browser_download_url"`

Next, download that package, either from the link in a web browser or using `curl` on the Terminal command line: 
`curl -LO https://github.com/autopkg/autopkg/releases/download/v2.7.2/autopkg-2.7.2.pkg`
(substituting the latest link in).

`curl` note: `-L` allows it to follow redirects, `-O` says to save the package with the same name as the download

Finally, install that package, either by double clicking the file from the browser or with the following command:
`sudo installer -pkg autopkg-2.7.2.pkg -target /`

Alternately, we have a policy to download the latest AutoPkg from the Jamf server. To use that, enter the command: `sudo jamf policy -id 13019`

To verify the program is working: `autopkg version` or `/usr/local/bin/autopkg version`

## Install `git`

To install `git`, you need to install the Xcode Command Line Tools from Apple. There are three main ways to do this:

1. Login to the local computer and run the following on the command line: `xcode-select --install` or `/usr/bin/xcode-select --install` (note: the process opens a window on the console, so you need to be logged in)
2. Download the Xcode Command Line Tools from Apple Developer and run the package. You'll need a free Apple Developer account.
3. We have a Jamf Policy set up to do it that you can trigger running the following command: `sudo jamf policy -trigger xcodedev`. To ensure that the package is up to date, run `sudo /usr/sbin/softwareupdate -aiR` to install available updates.

To verify the program is working: `git -v` or `/usr/bin/git -v`

## Add AutoPkg Recipes

Run the commands in the `add-recipes.sh` script. You can verify the recipes are all installed by running the `autopkg list-repos` or `/usr/local/bin/autopkg list-repos` command.

## Make Recipe Overrides

Run the commands in the `make-override.sh` script. You can verify the recipes are all installed by checking the `~/Library/AutoPkg/RecipeOverrides` directory.

## Set Up Server Credentials

Run the following commands, substituting your Jamf Server URL for `$url`, your account for `$account`, and your password for `$password`:

`/usr/bin/defaults write ~/Library/Preferences/com.github.autopkg.plist JSS_URL "$url"`

`/usr/bin/defaults write ~/Library/Preferences/com.github.autopkg.plist API_USERNAME "$account"`

`/usr/bin/defaults write ~/Library/Preferences/com.github.autopkg.plist API_PASSWORD "$password"`

Note: the `history -p` command (in `zsh`) or `history -c` command (in `bash`) will clear your command line history and the `clear` command will clear your terminal window (so no one sees what you typed)

## Set Up Profile

This is an optional step if you intend to use this machine to regularly run AutoPkg. It lets you launch the Terminal window and type `apd` to initiate running all the AutoPkg recipes. 

Paste the contents of the `profile.sh` script into a file called `.zprofile` (`zsh`) or `.profile` (`bash`) in the user home directory.

## Test

Test one of the recipes with something like: `autopkg run ~/Library/AutoPkg/RecipeOverrides/BBEdit.jamf-upload.recipe`
