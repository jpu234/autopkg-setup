# autopkg-setup

Instructions for setting up AutoPkg on local machines, including a few scripts that we can keep up to date here. They have been updated in 2024 with an added script.

# Steps to install

[Setup](#setup)

[Script Installation](#running-the-script)

[Installation with Scripts](#installation-with-scripts)

[Manual Installation](#manual-installation)

[Testing the Installation](#test)

## Setup

For any method of installation, start by installing Git and AutoPkg and creating a copy of this repo.

### Installing git

`git` is part of the Xcode Command Line Tools from Apple. There are three main ways to do this:

- Login to the local computer and run the following on the command line: `xcode-select --install` (note: the process opens a window on the console, so you need to be logged into the console)
- Download the Xcode Command Line Tools from Apple Developer and run the package. You'll need a free Apple Developer account.
- We have a Jamf Policy set up on Draugr to do it that you can trigger running the following command: `sudo jamf policy -trigger xcodedev`. To ensure that the package is up to date, run `sudo softwareupdate -aiR` to install available updates.

To verify the program is working: `git -v` or `/usr/bin/git -v`

### Install AutoPkg

First, find the latest version of AutoPkg. You can use its [GitHub repo](https://github.com/autopkg/autopkg/releases/latest) or by running the Terminal command: 

`curl -s https://api.github.com/repos/autopkg/autopkg/releases/latest | grep "browser_download_url"`

Next, download that package, either from the link in a web browser or using `curl` on the Terminal command line: 
`curl -LO https://github.com/autopkg/autopkg/releases/download/v2.7.2/autopkg-2.7.2.pkg`
(substituting the latest link in).

`curl` note: `-L` allows it to follow redirects, `-O` says to save the package with the same name as the download

Finally, install that package, either by double clicking the file from the browser or with the following command:
`sudo installer -pkg autopkg-2.7.2.pkg -target /`

Alternately, we have a policy to download the latest AutoPkg from the Draugr Jamf server. To use that, enter the command: `sudo jamf policy -id 13019`

To verify the program is working: `autopkg version`

### Clone This Repo

The easiest way to do this is to open a Terminal Session and type the command: `git clone https://github.com/jchutc0/autopkg-setup.git`. That will create a local copy of all files in this archive on your computer in the `autopkg-setup` directory

### Set Up Repositories and Repos

Look at the contents of the `sources.sh` file to see the AutoPkg recipes and repos that I use and either use those or update them for your own needs (unless you do the manual setup). 

Once the setup is complete, choose to [run the installer script](#running-the-script), install with [individual scripts](#installation-with-scripts), or set things up [manually](#manual-installation).

## Running the Script

The script will do the rest of the setup for you. If it works properly, it should be the easiest way to do things. In the Terminal session where you cloned this repo, change directory into the repo `cd autopkg-setup`. Then run the command `./installer.sh`.

The script:
- Verifies `git` and `autopkg` are installed
- Prompts you for your server API credentials and stores those in the AutoPkg defaults file
- Uses `autopkg` to pull down any repositories defined in the `sources.sh` file
- Uses `autopkg` to make overrides of the AutoPkg recipes defined in the `sources.sh` file
- Sets up a `.zprofile` file to make running AutoPkg easier

If the script runs successfully, [test the installation](#test)

## Installation with Scripts

For more control of the installation process, you can bypass some of the automation. To do this process:
- Set up the AutoPkg defaults file
	- Set the Jamf server URL with: `defaults write ~/Library/Preferences/com.github.autopkg.plist JSS_URL "$url"` (substituting your Jamf URL for `$url`)
	- Set the Jamf API username with: `defaults write ~/Library/Preferences/com.github.autopkg.plist API_USERNAME "$account"` (substituting your API username for `$account`)
	- Set the Jamf API password with: `defaults write ~/Library/Preferences/com.github.autopkg.plist API_PASSWORD "$password"` (substituting your API password for `$password`); Note: the `history -p` command (in `zsh`) or `history -c` command (in `bash`) will clear your command line history and the `clear` command will clear your terminal window (so no one sees the password you typed)
- Run the script `add-recipes.sh` script (`source add-recipes.sh`) to pull down any repositories defined in the `sources.sh` file 
- Run the script `make-override.sh` script (`source make-override.sh`) to make overrides of the AutoPkg recipes defined in the `sources.sh` file 
- (Optional) Paste the contents of the `profile.sh` script into a file called `.zprofile` (if you use `zsh`) or `.profile` (if you use `bash`) in the user home directory to set up a profile

If these steps are successful, [test the installation](#test)

## Manual Installation
- Set up the AutoPkg defaults file
	- Set the Jamf server URL with: `defaults write ~/Library/Preferences/com.github.autopkg.plist JSS_URL "$url"` (substituting your Jamf URL for `$url`)
	- Set the Jamf API username with: `defaults write ~/Library/Preferences/com.github.autopkg.plist API_USERNAME "$account"` (substituting your API username for `$account`)
	- Set the Jamf API password with: `defaults write ~/Library/Preferences/com.github.autopkg.plist API_PASSWORD "$password"` (substituting your API password for `$password`); Note: the `history -p` command (in `zsh`) or `history -c` command (in `bash`) will clear your command line history and the `clear` command will clear your terminal window (so no one sees the password you typed)
- Run the script `add-recipes.sh` script (`source add-recipes.sh`) to pull down any repositories defined in the `sources.sh` file 
- Run the script `make-override.sh` script (`source make-override.sh`) to make overrides of the AutoPkg recipes defined in the `sources.sh` file 
- (Optional) Paste the contents of the `profile.sh` script into a file called `.zprofile` (if you use `zsh`) or `.profile` (if you use `bash`) in the user home directory to set up a profile

If these steps are successful, [test the installation](#test)

## Test

To verify that things work:
- Use the command `defaults read ~/Library/Preferences/com.github.autopkg.plist` and make sure that file shows your API credentials and server URL correctly (the `clear` command will clear your screen so your password doesn't just keep showing)
- Verify the recipes are all installed by running the `autopkg list-repos` command. You should see all the repos you added.
- Verify the overrides are present with `ls ~/Library/AutoPkg/RecipeOverrides`
- Verify the profile is written correctly by opening a new Terminal session
- Test one of the recipes with something like: `autopkg run ~/Library/AutoPkg/RecipeOverrides/BBEdit.jamf-upload.recipe`
