# Using VSCode in sync with eXist-db
complete after all yeoman steps
hold onto your hats! what happens when no one uses VS Code anymore? we should really explain our tool choices in these kinds of notes, so others can make informed decisions in the future.

Open VS Code (you can use the command `code` for this! (David is going to add a link)

Under "File" click "Add Folder to Workspace"
Select the directory you've been working in, the one you created the app inside of.

Under "Terminal" select "Run Task" and then begin typing "exist-db". There should be a task called "exist-db:sync-your-workspace-name"

To test your connection, in the workspace create a new XML file and paste the following code:
```
<code>Hello world!</code>
```
and save with filetype .xml.

Watch the terminal for sync, and open the app in your browser to see if it shows up there too. You can also try looking for the file by opening the eXist-db Java Admin Client.





