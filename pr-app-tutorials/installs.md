# Required software installs (MacOS)

## Synopsis

How to prepare your Mac to create an eXist-db app.

Windows installation instructions appear further down. To go there directly, click [here](https://github.com/Pittsburgh-NEH-Institute/pr-app/blob/main/pr-app-tutorials/installs.md#required-software-installs-windows).

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
1. For existdb-vscode do *one* of the following:
    * Open Virtual Studio Code, search for existdb-vscode module, and follow installation instructions
    * Install from <https://marketplace.visualstudio.com/items?itemName=eXist-db.existdb-vscode&utm_source=VSCode.pro&utm_campaign=AhmadAwais>
    * Install from <https://github.com/wolfgangmm/existdb-langserver>

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

# Required software installs (Windows)

## Synopsis

How to prepare your Windows PC to create an eXist-db app. 

## Installations

1. Install these in the following order. 
2. Unless otherwise noted, always install packages through running Windows PowerShell, or Git Bash, as Administrator (this is an elevated command prompt).
3. When prompted to upgrade any of these packages except node (but including npm and nvm), accept the prompt.

## Install *Chocolatey*

Read [about Chocolatey](https://chocolatey.org/how-chocolatey-works) and follow the [installation instructions](https://chocolatey.org/install#individual) for individual use.

**Before installing *Chocolatey***
1. Check that you have Windows PowerShell installed by searching for it on the Windows Start menu. If not, [install PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2). Information on PowerShell is available [here](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.2).
2. Then, search for PowerShell through the Windows Start menu. Right click on it, then select "Run as administrator." Click "Yes" when asked whether you want to allow PowerShell to make changes to your device. 
3. Proceed with the *Chocolatey* installation instructions.

## Install *eXist-db*

Install current stable version from [http://exist-db.org/exist/apps/homepage/index.html]().
1. Follow the [installation instructions](https://exist-db.org/exist/apps/doc/basic-installation) on the eXist-db website. (**Important:** Pay attention to the instructions on Java versions). 
2. You will know that the installation has been successful if, after following all prompts, the eXist-db launcher opens after entering http://localhost:8080/ in your browser. 
3. If you are having trouble getting eXist-db to run:
   - Uninstall eXist-db.
   - Make sure that you have [OpenJDK](http://jdk.java.net/18/) installed.
   - Reinstall eXist-db and check that it launches successfully. 
4. If eXist-db still will not run, follow their [troubleshooting instructions](https://exist-db.org/exist/apps/doc/troubleshooting) or [advanced installation guide](https://exist-db.org/exist/apps/doc/advanced-installation).

## Install *git*

Type `git` at the command line. If it isn't installed, type `choco install git`. This will also install Git Bash. From now on, instead of using PowerShell, you will use Git Bash as your command line interface. (**Important:** Remember to run Git Bash as Administrator when installing anything). 

## Install *vscode* + *existdb-vscode* module 

1. Check if vscode is already on your machine by typing `code --version` at the command line. 
2. If not, make sure Git Bash has been launched as administrator. 
   - Type `choco install vscode`
3. For *existdb-vscode*, install from https://marketplace.visualstudio.com/items?itemName=eXist-db.existdb-vscode&utm_source=VSCode.pro&utm_campaign=AhmadAwais

## Install *npm* and *nvm*

1. Install *npm* (node package manager) with `choco install npm`.
2. Install *nvm* (node version manager) with `choco install nvm`. (Why? nvm lets you install and choose among different node releases, and Yeoman requires node v. 14, which is not the most recent version.)
3. **Important**: restart Git Bash. 
4. Install *node* v.14 with `nvm install 14`. The installation will show you the full number of the version (for example, v14.19.1 instead of v14). **Write down the full version number and save it for future use**. 
5. Activate *node* v.14 with `nvm use 14.19.1` (or the full version number you saved from the previous step). (This command persists only in a single shell, which is what you want, but it means that you have to run again each time you launch a new shell).

If at any point you have issues using *npm* or *nvm*, check your Program Files for a nodejs directory, then delete the directory. Instructions for this are [here](https://github.com/coreybutler/nvm-windows/issues/191#issuecomment-233779673) in the solution given by the user "pleverett".  

## Install *yeoman* for eXist-db

1. `npm i -g yo`
2. `npm i -g @existdb/generator-exist`

## Create a new app 

1. Follow the instructions at [yeoman.md](). 





