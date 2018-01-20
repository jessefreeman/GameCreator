# Change Log

The Game Creator is constantly being updated based on the new feature backlog, bugs that need fixing and optimizing the underlying code base. Because of this, the goal is to release new versions as often as possible. If you are new to the Game Creator or looking to understand what has changed since the last release, you can find all of the changes below, broken down by the version number.

### V0.7.8 Alpha

This is an untested build of the Game Creator allowing developers to test out early features going into v0.8.0a. Make sure to backup your workspace before using. For this update, you should create an entirely new Workspace folder. Find the default location and remove the old bios and core workspace, then start up v0.7.6 to let it recreate the workspace from scratch.

* Rebuilt Workspace Explorer Tool and underlying file system from scratch. Now all of the features of the GameCreator are available from the Workspace including launching games, editing files and managing the trash.

* Built-in art packs, demos, tools, and systems are now easier to find in the Workspace Explorer in their directories.

* Removed DisplaySize() and OverscanBorder() from the GameChip. Replacing with a single Display() call wich optional bool for visible display size.

* ReadProductName() and ReadVersion() are now SystemName() and SystemVersion().

* Removed VisibleBounds() from Lua API.

* You can now create PV8 native Vector and Rect in Lua by calling NewVector(x,y) and NewRect(x,y,w,h).

* Gif recording is now enabled in the editor by hitting Ctrl + 3.

* New export feature in Workspace Explorer. When in the Sandbox, click the build button to generate out a compressed game file and WebGL build. Future support for Win, Mac, and Linux coming in the next build.

* Fixed Lua file collisions allowing you to override default Lua files in the project. If a similar named Lua file is in the game's project, it will be used instead of built-in system files.

* Cleaned up the Lua bridges and refactored EditorBridge to be part of the RunnerService and GameEditor. These new APIs will be documented in a future build.

Known Issues:

* The new file system is untested and may not work as expected or crash the Game Creator. Please make sure to back up any projects while using this build and modifying the Workspace from inside of the Game Creator itself.

* Restoring files from the trash has been disabled.

* The music settings are not fully functional. They are currently not mapped to the correct values. While you can make some changes to the music generator, some settings may throw an error or have unexpected results.

* Unable to edit the wave type for SFX settings. There is no UI for this, and it currently displays a slider which will throw an error if it is used. This will be addressed in a future build.

* You can now keep folders in your workspace instead of .pv8 zip files. This features is experimental and may not work as expected.

### V0.7.7 Alpha

* All new rendering API. Under the hood the DisplayChip has been completely rewritten. For the most part, the Drawing APIs remain the same.

* Game saving has been implemented. Games will automatically save back to the source where they are running including archives in your Games folder.

* Render layers have been added. You can define the number of layers the DisplayChip can support. By default there are now 6 layers: background, sprite below, tilemap (cache), sprite, UI, and sprite above. See the new Tilemap demo for an example of how each layer works.

* FontChip has been refactored and simplified. It no longer accepts a wrap param in the API. You’ll need to use the new TextUtil for wrapping and splitting text into seporate lines. In Lua, use WordWrap(text, width) and SplitLines(text). The Font demo has been updated along with any other system template or demo that used word wrap previously.

* Gif recording can be enabled by pressing Ctrl + 1. There is no cap to the length or file size of a recording so be careful. In future builds this will be limited to 10-20 seconds.

* Max sprite value has been moved from the DisplayChip to the SpriteChip. If do not update the value in the Chip Editor your game will remove any sprite cap.

* You can now debug layers by calling DebugLayers(bool) in lua. Once enabled, use keys 1-6 for turning on layers and 0 to reset.

* UI layer has changed and is no longer persistent between frames. If you need to draw UI, you will want to push Pixel Data directly to the display on each render frame which doesn’t count against any sprite limit.

* New sprite Unique flag for SpriteChip that when set to false will ignore optimizing sprites. This is not fully tested.

* New Pico 8 system template. The project not only includes some specs similar to Pico 8 projects but has an API map that can be used to get some Pico 8 game running in Pixel Vision 8. Some Drawing APIs are not fully implemented so look through the pico-8-shim.lua file in the template to see what you can and can’t do.

* New DrawRect() API to use for clearing the screen and drawing filled rectangles to the display for UI or masking.

* There were over 60 issues resolved in this build. You can track all of the open issues on the Github issue page and file any bugs you see there as well.

### V0.7.6 Alpha

* The Game Creator UI was completely rebuilt from the ground up. There is a new UI framework, and a lot of the tools have been simplified to help fix issues in the workflow. You can now use the UI in your games, and there are a demo project and new system tool to show you how.

* Most of the changes are undocumented at this time. You can find example projects in the new File tool under the System tab. Each project has been updated to take advantage of changes to the PV8 API.

* DrawSprite and DrawSprites have been changed. You no longer need to pass in a bool to flag rendering sprite data above or below the background layer. You can now pass in DrawMode.Sprite/DrawMode.SpriteAbove or DrawMode.SpriteBelow for this to work.

* DrawTile and DrawTiles have been added as an alternative to Tile/UpdateTiles. This focuses solely on drawing tile data to the tilemap, the tilemap cache or the new UI layer. You can call DrawTile(id, c, r, mode, colorOffset) or DrawTiles(ids, c, r, w, mode, colorOffset) to use it. These APIs require the position in column and rows. It accepts DrawMode.Tile, DrawMode.TilemapCache or DrawMode.Layer.

* There is a new UI layer designed for adding HUDs and overlays to games. The UI layer sits above the tilemap but is below sprites. You can draw pixel data, text or tiles to it by supplying DrawMode.UI as the render option. The UI layer is the exact side of the screen and does not scroll. You can clear it by calling ClearUILayer() which is not done automatically when calling RedrawDisplay.

* PV8 archives now live in the Workspace/Games folder. The game you are editing will be stored in the Workspace/Sandbox folder. These paths are customizable in the bios but were changed to accommodate a new file system structure being implemented in a future build.

* There is a new File Browser and Save Tool. The File Browser will now show you tabs for different folders inside of the workspace. The first tab will show your games, the system tab has built-in demos, and the last is for anything in the trash. Games in the trash can now be permanently deleted or restored back to the Workspace/Games folder.

* You can now launch games in the File Browser by double-clicking on them. This allows you to play the game without having to edit it. In the save tool, double-clicking on a file will automatically open that file in the appropriate editor.

* All of the chip settings have been moved into a central location called the Chip Editor. You can access this by going into a project’s save tool and double-clicking on the data.json file. Any changes you make here will be applied to the project. There is also a lock option which allows you to finalize the system specs and not edit them while working.

* Creating a new game automatically moves the contents of the Workspace/Games folder into the trash. Trash is no longer automatically emptied when shutting down the Game Creator so you can restore backups of accidentally deleted projects at any time.

* All of the tools have been migrated over to the new UI Framework and were optimized so they should load 4 to 5 times faster than before.

* The Sprite Editor now allows you to compress your sprites and will create a new optimized sprites.cache.png file. Once this file is created, it will be used instead of the default sprite.png file. If you want to rebuild the cache, you’ll need to delete that file then re-compress the sprites.

* Each project can now store its own SpriteBuilder folder. This allows you to keep all of the resources that belong to a game in one place but it will not count against your project’s total. Only core files are counted.

* There is a new Tile Map editor with support for creating a Tiled friendly json file. You can do this by clicking on the Compress button in the Tilemap Editor. Once you click this, it will convert the tilemap.png file into a tilemap.json file and link up the sprites and collision flags. When you open this file in Tiled, you can make all of your changes there and anything saved will automatically be re-loaded into the game the next time you run it. The old tilemap.png file will be ignored, and this new json file will greatly speed up load times for your game.

* There were over 180 issues resolved in this build making it the largest one to date. Now that the new UI framework is in place, updates to the Game Creator should be a lot easier. The goal is to return to updates every two weeks. You can track all of the open issues on the Github issue page and file any bugs you see there as well.

### V0.7.5 Alpha (Unreleased)

This version was not stable enough to be released.

### V0.7.4 Alpha

* All runners have been moved out of the core application folder and can now be installed manually in the workspace.

* Fixed issue with HTML5 runner where it would throw out of memory error.

* Export will now work only for runners that are installed and grey out when a supported runner can’t be found.

* Fixed issues that would crash the Game Creator when trying to escape out of the loader or when reloading a tool that threw an error.

* Sound has now been fixed and will correctly load and set based on the bios value. 

* Mute has also been fixed to restore the correct sound volume even after restarting the Game Creator.

* File picker action buttons now show roll over help and contextual help when they need to be pressed two times in order to perform an action.

* Modified the Action Bar UI component to directly support double click action. All tools that use the component have been updated.

* Save tool is now using the new Action Bar UI component. You will get contextual button actions based on the state of the tool’s data and buttons will be disabled when they can not be used.

* Changed save tool’s "Save" button to “Update” to make it clearer what the action will do after changing data in the tool.

* Fixed a bug where the File Picker filter tabs would throw an out of bounds error.

* Fixed missing or broken icons on the Save Tool’s file picker.

### V0.7.3 Alpha

* Completely new Workspace API. The entire system has been rebuilt in preparation of v0.8.0.

* System Tool and Demos are now not part of the build. This will help reduce file size. You can download them and manually install only what you want/need. Future builds will automate this.

* Creating a new game will now warn you before overwriting an existing one.

* Creating a new game will automatically archive the existing game and move it into the trash. The trash may be set to delete when exiting the game so check your settings.

* File picker action buttons have been rebuilt. They now disabled when no action can be performed and enable based on the context.

* Import and Launch have been removed from the File Picker and will be added back in a future build.

* All built in tools are now located in the Game Creator’s data/StreamingAssets folder which is different based on the OS it’s running on. This allows tools to be built into the Game Creator itself and makes updating them easier in the future. If you use an existing workspace, you can remove the old .pvt files from the archive folder.

* Fixed Copy and Paste help text in Settings screen for workspace path panel.

* Fixed bug in Sprite Builder that would not create a new sb-sprites.lua file from scratch.

* Fixed scale InvalidCastException which happened after changing the scale and reloading the settings tool.

* Fixed issue with DrawSprites and scrolling along the Y position.

* New bios which is built into the GameCreator and manages core settings. The bios file in the Workspace now overrides any default values. This will make adding new properties to the bios easier in future updates.

* All system tools are now defined in the bios including error messages and more. In future builds you will be able to load in custom tools for specific tasks.

* Escape button now stops a running game and load the last tool. Escape will not reload the game, you’ll need to use Ctrl + 1.

* Fixed issue when drawing tiles outside of the tilemap boundaries. Now the tile will wrap to the opposite side.

* New internal URI system for loading game. There are two root locations, System (built in) and Workspace (user defined) allowing more control over how and where games are loaded from.

* New Load APIs exposed to the global runner. You can call LoadGame(), LoadTool() and EditGame() from global and pass in the Game Creator URI path. 

* Workspace/Lib folder is now Workspace/Libs folder. The previous framework UI scripts have been moved into the Game Creator’s system folder and each component is now its own Lua file.

* Fixed Sprite Builder button to only show up when a SpriteBuilder folder exists.

* When archiving a game, all files in the Workspace/Game folder are saved including folder structure. Past versions only saved core files. This now allows you to save all external files associated with your game but are not needed by the Game Creator in a single place. Any files that Game Maker can’t use are ignored and do not count against the file size limitation.

### v0.7.2 Alpha

* Updated doc structure and added new sections on using external editors, the Display Tool, Sprite Tool and taking screenshots.

* Display Tool now shows color totals.

* Display and sprite tool no longer shows magenta around totals.

* Editor window scale value is now saved correctly.

* Foundation for loading Assets from file picker.

* Added support for Flag() API.

* Added support for Asset Projects (.pva).

* Cleaned up export options, src is now set to true by default to include a .pv8 file in the Builds folder.

* Changed options in Open tool. In order to edit a project, click the edit button. Open has been removed and replaced with launch. Also selecting a .pvs or .pva file will give you the option to import it into your open project.

### v0.7.1 Alpha

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

