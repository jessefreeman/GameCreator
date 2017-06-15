# The Workspace

The Game Creator makes a Workspace folder in a shared location on your computer. By opening up the Workspace folder, you can work directly on a game’s files in your editor of choice. To get the path, you can to enter editor mode by pressing control 1 on the keyboard. Once in edit mode, you can access the settings tool from the top navigation.

![image alt text](images/TheWorkspace_image_0.png)

Once you load up the settings tool, you should see a screen like this that shows you the path to where the workspace folder exists on your computer.

![image alt text](images/TheWorkspace_image_1.png)

You can change this path to anywhere on your computer. 

![image alt text](images/TheWorkspace_image_2.png)

There are buttons to reset the path, copy the existing path or paste in a new path. To navigate to the default location, select the copy button and paste the path it into the file browser on your computer. The path on my Windows computer is: 

`C:/Users/Jesse Freeman/AppData/LocalLow/Pixel Vision 8/GameCreatorFree/` 

Yours should be similar with a different user name.

![image alt text](images/TheWorkspace_image_3.png)

Inside the Workspace folder are four directories: Archive, Game, Lib, and Trash.

![image alt text](images/TheWorkspace_image_4.png)

The Archive is where the Game Creator stores finished games, tools, and systems. The Game folder is for any game the engine is currently running, or you are editing. This directory is persistent and only replaced when you load a new game. Since this folder is persistent, you to continue working on a game across different sessions. The Lib folder contains Lua scripts shared across different games or tools. Trash contains files that ready to be deleted. By default, the Game Creator empties the trash when you exit.

You can override the default system path by pasting in the path where you want to store your workspace on your computer. Game Creator confirms that the path is valid before creating the new Workspace folder along with all the required projects. Contents inside of the Game, Lib or Trash folder are not copied over when creating a new workspace.

