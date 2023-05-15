# autopkg-setup

Instructions for setting up AutoPkg on local machines, including a few scripts that we can keep up to date here.

# Steps to install
(details on each below)

1. Install AutoPkg
2. Install `git`
3. Add AutoPkg Recipes
4. Make Recipe Overrides
5. Set Up Server Credentials
6. Set Up Profile (optional)
7. Test

## Install AutoPkg

First, download the latest version of AutoPkg. You can use its [GitHub repo](https://github.com/autopkg/autopkg/releases/latest).

Next, download that package, either from the link in a web browser or using `curl` on the Terminal command line: 
`curl -LO https://github.com/autopkg/autopkg/releases/download/v2.7.2/autopkg-2.7.2.pkg`
(substituting the latest link in)
`curl` note: `-L` allows it to follow redirects, `-O` says to save the package with the same name as the download

Finally, install that package, either by double clicking the file from the browser or with the following command:
`sudo installer -pkg autopkg-2.7.2.pkg -target /`

To verify the program is working: `autopkg version` or `/usr/local/bin/autopkg version`

## Install `git`

To install `git`, you need to install the Xcode Command Line Tools from Apple. There are three main ways to do this:

1. Download the Xcode Command Line Tools from Apple Developer and run the package. You'll need a free Apple Developer account.
2. Login to the local computer and run the following on the command line: `xcode-select --install` or `/usr/bin/xcode-select --install` (note: the process opens a window on the console, so you need to be logged in)
3. We have a Jamf Policy set up to do it that you can trigger running the following command: `sudo jamf policy -trigger xcodedev`

To verify the program is working: `git -v` or `/usr/bin/git -v`

## Add AutoPkg Recipes

Run the commands in the [[add-recipes.sh]] script. You can verify the recipes are all installed by running the `autopkg list-repos` or `/usr/local/bin/autopkg list-repos` command

## Make Recipe Overrides

## Set Up Server Credentials

## Set Up Profile

## Test