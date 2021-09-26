# Using vscode in sync with eXist-db (MacOS)

1. Complete all instructions in [installs.md]() and then [yeoman.md]().
1. Launch eXist-db. If you haven’t already built and installed your app, do that now.
1. Launch VS Code. (You can do this from the Applications folder in the Finger, but see also “Launching from the command line” at [https://code.visualstudio.com/docs/setup/mac]().
1. Under "File" click "Add Folder to Workspace". Select the root directory for the app you initialized in the [yeoman.md]() instructions.
1. Under “File” select “Save workspace as” and give your workspace a meaningful name, saving into the root directory of the app.
1. Under "Terminal" select "Run Task" and then begin typing "exist-db". There should be a task called "exist-db:sync-your-workspace-name". When you run it, a terminal panel will open inside vscode.
1. To test your connection, in the workspace create a new XML file that consists entirely of `<code>Hello world!</code>` and save inside your rep with the filetype *.xml*. 
1. To confirm that sync is working do any of the following:
	1. Watch the terminal panel.
	2. Open the app in your browser (if the app is configured to show available files).
	3. Launch the eXist-db Java Admin Client and look for your new file there. 

# Getting ready to commit to a repository

1. Remove *.existdb.json* from *.gitignore*. You want to track this piece!
1. Initialize an empty repository on github.com.
1. Configure git remote (see below; this example is for SSH authentication; see [https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes]() for more complete information), set up a main branch, and then push:

```
git remote add origin git@github.com:your-org/your-repo
git branch -M main
git push -u origin main
```

Others can now clone this repository, build an app using `ant`, install the app in their own eXist-db by using exist Package Manager, open in VSCode, create the workspace, and run sync task (see all previous steps!).

## TODO

What happens when no one uses VS Code anymore? We should really explain our tool choices in these kinds of notes, so others can make informed decisions in the future.
