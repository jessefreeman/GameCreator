# Loading Data

When the Game Creator attempts to load a game from the Archive, the contents are copied over to the Game directory, and each file loads in a specific order. Knowing this order is important to understand how a game is prepared to be played by the engine. Here are the steps the Game Creators importer following:

1. System Data

2. Lua Code

3. System Colors

4. Color Map

5. Sprites

6. Tile Map

7. Tile Map Flags

8. Fonts

9. Metadata

All the data in a game project is loaded at run-time and parsed when a game first loads. After the game is running, changes made to the files require the game to reload and each file reimported. You to work on a project with an external editor while it is running then hit refresh Ctrl + 4 to see your modifications. 

