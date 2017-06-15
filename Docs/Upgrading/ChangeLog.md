# Change Log

The Game Creator is constantly being updated based on the new feature backlog, bugs that need fixing and optimizing the underlying code base. Because of this, the goal is to release new versions as often as possible. If you are new to the Game Creator or looking to understand what has changed since the last release, you can find all of the changes below, broken down by the version number.

### v0.7.1 Alpha

This is an untested build of the Game Creator allowing developers to test out early features going into v0.8.0a. Make sure to back up your workspace before using and you may need to create a new workspace to get access to the new Save and Settings tools, or just manually delete them from your Workspace’s Archive folder.

* New save tool which allows you to preview a game’s files, archive the project and export it.

* New export workflow which supports creating Pixel Vision 8 runners for Windows, Mac, Linux and WebGL.

* Redesigned Settings Tool with support for fullscreen and scaled window mode.

* New API to get the frames per second value. Call `editorBridge.fps` and it will return a readonly int for the current frames FPS.

* Various bug fixes to tools.

### v0.7.0 Alpha

* All new shorthand API designed to help speed up game development.

* Updated demos to show off new APIs and Pixel Vision 8 features.

* Renaming archives in the File Picker Tool now correctly update their info.json data.

* Fixed bugs with saving. You can no longer save when no game is loaded, creating a new game lets you save without renaming first and fixed other issues around not detecting when you can save based on external changes.

* Fixed how Sprite Tool renders transparent colors to work more like the Color Tool.

* Fixed display oversample issues which would render 1px of the left and bottom of the screen on the top and right.

* Sprite Tool now displays tilemap.png tiles that are not in the sprite.png file.

* Background Color was moved from the Screen Buffer Chip into the Color Chip. Should automatically correct itself when loading up a game and saving it.

* Add overscan option was added to let you crop the screen, simulate old CRT screen clipping and offer a place off screen to store sprites you don’t want to be displayed.

* Clear method now accepts no values, to redraw the entire display like it previously worked, or you can pass in an x, y, width, and height to clear a specific region.

* Added a new DrawTilemap method to have more granular control over rendering the tilemap. You can also define a x, y, width and height for how much of the tilemap you want to sample and even define an offsetX and offsetY for where to render it on the screen.

* Removed ScreenBufferChip. While you can still reference it and its APIs, this will be deprecated in future versions.

* Backward compatibility exists with the previous APIBridge, but all logic is now routed through the new API. This may cause some rendering and performance issues. The APIBridge will be removed so you are encouraged to migrate over to the new APIs.

### v0.6.3 Alpha

* Fixed the save button, so it shows up correctly in the toolbar

* Fixed the music tool so you can generate loops on games with 3 or fewer tracks (which was throwing an array out of index error before).

* Fixed color importer to now treats transparent colors in .pngs as the default PV8 transparency mask color (#FF00FF). You will notice this fix when previewing some color.png files in the Display Tool.

* Fixed the last used tool to work how it should. Now if you go from the editor to the game and back you should automatically load the last used tool.

* Optimized the Tilemap Tool's sprites. While this tool is still a WIP, I have been trying to optimize how it loads tiles to speed that up a bit.

* Deprecating editorBridge:LoadLib() which will be removed in v0.7.0a. Use apiBridge:LoadLib() instead. Now any game can load an external library file from the Game folder or the Workspace’s Lib folder.

* Updated the Setting Tool. It now disables the game name if none exists. Also the workspace path area is larger and there is now a dedicated volume/mute button. 

* Fix to the Tilemap Tool to display the correct scroll y value.

* All new system templates which display basic instructions on how to modify a new game file.

### v0.6.2 Alpha

* Rebuilt pre-loader logic to now display percentage and break up loading over steps.

* Optimized tools to load faster based on new pre-loader logic.

* All new boot screen.

* Added help messages to all of the tool's UI.

* Added support to display line numbers for script errors.

* Cleaned up Debugger Tool to now show icons based on event type.

* Sprite Tool (pro only) now shows the sprites instead of fonts and other dynamically generated artwork.

* Sprite Tool (pro only) now supports exporting, reverting and clearing sprites.

* Color Tool (pro only) now supports exporting, reverting and clearing colors.

* Fixed issues where changing colors in the Color Tool cleared the display and wouldn't show changes.

### v0.6.1 Alpha

* New tilemap preview tool (pro only).

* Bug fixes and optimizations.

* Cleaned up installer files and updated for v0.6.1a.

* Created new Windows installers for free and pro executables.

### v0.6.0 Alpha

* All new file browser and system config tools.

* New controller mapping tool.

* New pro-tools for editing colors, sprites, sound effects and music.

* Optimized rendered for better performance.

* New API method calls for drawing sprites, text and more.

* New editor bridges for colors, sprite, sound effects and music.

* Bug fixes

* New demo games showing off the controller input, drawing sprites, displaying a mouse and playing back sound and music.

* All errors are now displayed in a custom error screen.

* New debug tool for display the game's log.txt file when running the engine.

### v0.5.0 Alpha

* Create, play, edit, save and share PV8 games

* Loading and error screens

* Includes sample Lua game, RPG8, with source code and art

* Includes tools for creating new games, saving/loading them and editing system settings

* Full support for system colors, sprites and tilemap with collision

* Open workflow allowing external pixel and code editors to modify games

* No sound or music support in this build

