# Required software installs (MacOS)

## Synopsis

How to prepare your Mac to create an eXist-db app.

**TODO:** Add Windows instructions

## Installations

1. Install these in the following order.
1. Install as a regular user (don’t use *sudo*).
1. When prompted to upgrade any of these packages except *node* (but including *npm* and *nvm*), accept the prompt.

### Install *homebrew*
Read [About Homebrew](https://brew.sh/) and install with
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`


### Install *eXist-db*
Install current stable version from [http://exist-db.org/exist/apps/homepage/index.html]()
or `brew install alfred` and `brew install --cask existdb`

### Install *git*

Type `git` at the command line. If it isn’t installed, accept the prompt to install the Xcode command line tools.

### Install *vscode* + *existdb-vscode* module

1. Run `brew install --cask vscode` or install from [https://code.visualstudio.com]()
1. Open Virtual Studio Code + search for existdb-vscode module

### Install *npm* and *nvm*

1. Install *npm* (node package manager) with `brew install npm`
2. Install *nvm* (node version manager) with `brew install nvm`. (Why? *nvm* lets you install and choose among different *node* releases, and Yeoman requires node v. 14, which is not the most recent version.)
2. **Don’t skip this step!** Run `brew info nvm` and follow the “caveats” instructions.
2. Install *node* v. 14 with `nvm install 14`.
3. Activate *node* v. 14 with `nvm use 14`. (This command persists only in a single shell, which is what you want, but it means that you have to run again each time you launch a new shell.)

### Install *yeoman* for eXist-db

1. `npm i -g yo`
1. `npm i -g @existdb/generator-exist`

### Create a new app

1. Follow the instructions at [yeoman.md]()
