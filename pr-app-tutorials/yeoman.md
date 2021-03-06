# Using Yeoman to generate eXist-db applications
[https://github.com/eXist-db/generator-exist](https://github.com/eXist-db/generator-exist)

## Goals

- Create your own workspace that can be synced with eXist via VSCode
- Understand how syncing both the file system and your server helps your workflow.

## Steps

Complete the instructions in [installs.md]() before continuing below.

1. `mkdir your-folder-name`. This creates what will become a new Git repo.
1. `cd your-folder-name`
1. `yo` and follow prompts, which are, in order (with suggested and sample responses):
	- *What would you like to do?* @existdb/exist
	- *What would you like to call your exist-db application?* tmp
	- *How should I abbreviate that?* tmp
	- *Please add a short description*? My amazing tmp application
	- *Pick an app template:* empty
	- *Should your app have a secure area?* No
	- *Will your application be deployed in the apps collection?* (hit return for yes) apps (NB: Hit `Return`; do not type a `Y`.)
	- *What should your module namespace begin with?* http://www.obdurodon.org
	- *Pick a version number?* 1.0.0
	- *Pick the release status:* alpha
	- *Would you like to generate a pre-install script?* Yes
	- *Would you like to generate a post-install script?* Yes
	- *Who is the author of the application?* gab_keane
	- *What is your email address?* gabakeane@gmail.com
	- *What is the author's website?* https://gabikeane.github.io/portfolio
	- *Please pick a license:* MIT
	- *Will you host your code on GitHub?* Yes
	- *What is your GitHub username?* gabikeane (use your own GitHub username)
	- *Would you like to assign db user roles and permissions for your app?* No
	- *Whats your CI service?* GitHub Action
	- *Would you like to use docker for your app?* No
	- *Would you like to add a.existdb.jsonIDE config file for:atom or vs-code?* Yes
	- *What is the eXist instance's URI?* http://localhost:8080/exist
	- *What is user-name of the admin user*? admin
	- *What is the admin user's password?* [hidden] (leave the password empty, just press enter)
1. Build a *.xar* file by typing `ant` at the command line.
1. Start eXist-db, open a browser, and go to [http://localhost:8080/](). Log in as `admin` (no password, usually).
Launch Package Manager and upload the regular *.xar* file from your `build` folder (the dev *.xar* can be ignored for now).
1. Within eXist-db, go to the Launcher, and make sure your app is there. 
1. At the command line, and within the same folder you created and ran Yeoman in, type `git branch -m main` to change the repo's branch name to the conventional "main."
1. On GitHub, create a new repository with the same name as the folder you created. **Important**: Make sure that you create an *empty* repository, *without* a README.
1. Once you have created the empty repository, follow the instructions under "...or push an existing repository from the command line."  
