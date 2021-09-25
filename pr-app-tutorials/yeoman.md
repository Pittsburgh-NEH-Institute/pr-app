# Using Yeoman to generate eXist-db applications
[https://github.com/eXist-db/generator-exist](https://github.com/eXist-db/generator-exist)

How *should* we be answering these questions? Work on this together with David.

Goals:
- create collaborative workspace that can be synced with eXist via VSCode
- What is output? .xar?
- how does initializing with Git prepare this to be added to a project space? how can we model a good workflow for this so people don't lose work/versions in their early development?

Steps
`mkdir your-folder-name`
`cd your-folder-name`
`yo`
follow prompts

```
? What would you like to call your exist-db application? tmp
? How should I abbreviate that? tmp
? Please add a short description? My amazing tmp application
? Pick an app template: empty
? should your app have a secure area? No
? Will your application be deployed in the apps collection? (hit return for yes) apps
? What should your module namespace begin with? http://www.obdurodon.org
? Pick a version number? 1.0.0
? Pick the release status alpha
? Would you like to generate a pre-install script? Yes
? Would you like to generate a post-install script? Yes
? Who is the author of the application? gab_keane
? What is your email address? gabakeane@gmail.com
? What is the author's website? https://gabikeane.github.io/portfolio
? Please pick a license MIT
? Will you host your code on GitHub? Yes
? What is your GitHub username? gabikeane
? Would you like to assign db user roles and permissions for your app? No
? Whats your CI service GitHub Action
? Would you like to use docker for your app? No
? Would you like to add a.existdb.jsonIDE config file for:atom or vs-code? Yes
? What is the eXist instance's URI? http://localhost:8080/exist
? What is user-name of the admin user? admin
? What is the admin user's password [hidden]
```
`atom build.xml`

remove the 4 <copy> lines that use bootstrap, save, and close. Duncan has already logged it as a bug, so next release should eliminate this step completely.

`ant`

Start eXist-db, open a browser, and go to http://localhost:8080/. Log in as admin (no password, usually)
Navigate to Package Manager and upload the file from your `build` folder. The dev version can be ignored for now.



