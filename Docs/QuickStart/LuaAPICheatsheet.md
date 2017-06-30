# Lua API Cheatsheet

All Lua games have access to a set of APIs that communicate directly with the Pixel Vision 8 engine. These are exposed via the Game Chip. This bridge allows you to access the native properties and methods of the core framework.

## Lifecycle Hooks

The game has several built-in methods you can implement to hook into the engine as it runs. These are the main methods:

<table>
  <tr>
    <td>Name</td>
    <td>Arguments</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>Draw</td>
    <td></td>
    <td>Used for drawing the game to the display.</td>
  </tr>
  <tr>
    <td>Init</td>
    <td></td>
    <td>This is called when a game is initialized.</td>
  </tr>
  <tr>
    <td>Reset</td>
    <td></td>
    <td>This is called when a game is reset.</td>
  </tr>
  <tr>
    <td>Update</td>
    <td>timeDelta</td>
    <td>Used for updating the game's logic.</td>
  </tr>
</table>


## Game Chip Methods

Here is an alphabetical list of all of the Game Chip APIs:

<table>
  <tr>
    <td>Name</td>
    <td>Arguments</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>BackgroundColor</td>
    <td>id</td>
    <td>The background color is used to fill the screen when clearing the display. This method returns the current background color ID. If no color exists, it returns -1 which is magenta (#FF00FF).</td>
  </tr>
  <tr>
    <td>Button</td>
    <td>button
state
controllerID</td>
    <td>The main form of input for Pixel Vision 8 is the controller's buttons. Returns a bool based on the state of the button.</td>
  </tr>
  <tr>
    <td>CalculateIndex</td>
    <td>x
y
width</td>
    <td>Converts an X and Y position into an index. Returns an int value representing the X and Y position in a 1D array.</td>
  </tr>
  <tr>
    <td>CalculatePosition</td>
    <td>index
width</td>
    <td>Converts an index into an X and Y position to help when working with 1D arrays that represent 2D data. Returns a vector representing the X and Y position of an index in a 1D array.</td>
  </tr>
  <tr>
    <td>Clamp</td>
    <td>val
min
max</td>
    <td>Limits a value between a minimum and maximum. Returns an int within the min and max range.</td>
  </tr>
  <tr>
    <td>Clear</td>
    <td>x
y
width
height</td>
    <td>Clearing the display removed all of the existing pixel data, replacing it with the default background color.</td>
  </tr>
  <tr>
    <td>Color</td>
    <td>id
value</td>
    <td>The Color() method allows you to read and update color values in the ColorChip. This method returns a hex string for the supplied color ID. If the color has not been set or is out of range, it returns magenta (#FF00FF) which is the default transparent system color.</td>
  </tr>
  <tr>
    <td>ColorsPerSprite</td>
    <td></td>
    <td>Pixel Vision 8 sprites have limits around how many colors they can display at once which is called the Colors Per Sprite or CPS.</td>
  </tr>
  <tr>
    <td>Configure</td>
    <td></td>
    <td>Configures the GameChip instance by loading it into the engine's memory, getting a reference to the APIBridge and setting the ready flag to true.</td>
  </tr>
  <tr>
    <td>Deactivate</td>
    <td></td>
    <td>This unloads the game from the engine.</td>
  </tr>
  <tr>
    <td>DisplaySize</td>
    <td>width
height</td>
    <td>The display's size defines the visible area where pixel data exists on the screen. This method returns a Vector representing the display's size. The X and Y values refer to the pixel width and height of the screen.</td>
  </tr>
  <tr>
    <td>DrawPixels</td>
    <td>pixelData
x
y
width
height
drawMode
flipH
flipV
colorOffset</td>
    <td>This method allows you to draw raw pixel data directly to the display.</td>
  </tr>
  <tr>
    <td>DrawSprite</td>
    <td>id
x
y
flipH
flipV
aboveBG
colorOffset</td>
    <td>Sprites represent individual collections of pixel data at a fixed size.</td>
  </tr>
  <tr>
    <td>DrawSprites</td>
    <td>ids
x
y
width
flipH
flipV
aboveBG
colorOffset
onScreen</td>
    <td>The DrawSprites method makes it easier to combine and draw groups of sprites to the display in a grid.</td>
  </tr>
  <tr>
    <td>DrawText</td>
    <td>text
x
y
drawMode
font
colorOffset
spacing
width</td>
    <td>The DrawText() method allows you to render text to the display.</td>
  </tr>
  <tr>
    <td>DrawTilemap</td>
    <td>x
y
columns
rows</td>
    <td>By default, the tilemap renders to the display by simply calling DrawTilemap().</td>
  </tr>
  <tr>
    <td>Flag</td>
    <td>column
row
value</td>
    <td>This allows you to quickly access just the flag value of a tile.</td>
  </tr>
  <tr>
    <td>InputString</td>
    <td></td>
    <td>The InputString() method returns the keyboard input entered this frame.</td>
  </tr>
  <tr>
    <td>Key</td>
    <td>key
state</td>
    <td>While the main form of input in Pixel Vision 8 comes from the controllers, you can test for keyboard input by calling the Key() method. This method returns a bool based on the state of the button.</td>
  </tr>
  <tr>
    <td>MouseButton</td>
    <td>button
state</td>
    <td>Pixel Vision 8 supports mouse input. Returns a bool based on the state of the button.</td>
  </tr>
  <tr>
    <td>MousePosition</td>
    <td></td>
    <td>The MousePosition() method returns a vector for the current cursor's X and Y position.</td>
  </tr>
  <tr>
    <td>OverscanBorder</td>
    <td>x
y</td>
    <td>Pixel Vision 8's overscan value allows you to define parts of the screen that are not visible similar to how older CRT TVs rendered images. This method returns the overscan's X (right) and Y (bottom) border value as a vector. Each X and Y value needs to be multiplied by 8 to get the actual pixel size of the overscan border.</td>
  </tr>
  <tr>
    <td>PauseSong</td>
    <td></td>
    <td>Toggles the current playback state of the sequencer.</td>
  </tr>
  <tr>
    <td>PlaySong</td>
    <td>trackIDs
loop</td>
    <td>This helper method allows you to automatically load a set of loops as a complete song and plays them back.</td>
  </tr>
  <tr>
    <td>PlaySound</td>
    <td>id
channel</td>
    <td>This method plays back a sound on a specific channel.</td>
  </tr>
  <tr>
    <td>ReadSaveData</td>
    <td>key
defaultValue</td>
    <td>Allows you to read saved data by supplying a key. Returns string data associated with the supplied key.</td>
  </tr>
  <tr>
    <td>RebuildTilemap</td>
    <td>columns
rows
spriteIDs
colorOffsets
flags</td>
    <td>This forces the map to redraw its cached pixel data.</td>
  </tr>
  <tr>
    <td>RedrawDisplay</td>
    <td></td>
    <td>You can use RedrawDisplay to make clearing and drawing the tilemap easier.</td>
  </tr>
  <tr>
    <td>Repeat</td>
    <td>val
max</td>
    <td>Repeats a value based on the max. Returns an int that is never less than 0 or greater than the max.</td>
  </tr>
  <tr>
    <td>ReplaceColor</td>
    <td>index
id</td>
    <td>The ReplaceColor() method allows you to quickly change a color to an existing color without triggering the DisplayChip to parse and cache a new hex value.</td>
  </tr>
  <tr>
    <td>RewindSong</td>
    <td>position
loopID</td>
    <td>Rewinds the sequencer to the beginning of the currently loaded song.</td>
  </tr>
  <tr>
    <td>ScrollPosition</td>
    <td>x
y</td>
    <td>You can scroll the tilemap by calling the ScrollPosition() method and supplying a new scroll X and Y position. By default, this method returns a vector with the current scroll X and Y position.</td>
  </tr>
  <tr>
    <td>Sprite</td>
    <td>id
data</td>
    <td>This allows you to return the pixel data of a sprite or overwrite it with new data. Returns an array of int data which points to color ids.</td>
  </tr>
  <tr>
    <td>SpriteSize</td>
    <td>width
height</td>
    <td>Returns the size of the sprite as a Vector where X and Y represent the width and height. Returns a vector where the X and Y for the sprite's width and height.</td>
  </tr>
  <tr>
    <td>StopSong</td>
    <td></td>
    <td>Stops the sequencer.</td>
  </tr>
  <tr>
    <td>Tile</td>
    <td>column
row
spriteID
colorOffset
flag</td>
    <td>This allows you to get the current sprite id, color offset and flag values associated with a given tile. Returns a dictionary containing the spriteID, colorOffset, and flag for an individual tile.</td>
  </tr>
  <tr>
    <td>TilemapSize</td>
    <td>width
height</td>
    <td>This will return a vector representing the size of the tilemap in columns (x) and rows (y). Returns a vector of the tile maps size in tiles where x and y are the columns and rows of the tilemap.</td>
  </tr>
  <tr>
    <td>TotalColors</td>
    <td>ignoreEmpty</td>
    <td>The TotalColors() method simply returns the total number of colors in the ColorChip. This method returns the total number of colors in the color chip based on the ignoreEmpty argument's value.</td>
  </tr>
  <tr>
    <td>TotalSprites</td>
    <td>ignoreEmpty</td>
    <td>Returns the total number of sprites in the system. This method returns the total number of sprites in the color chip based on the ignoreEmpty argument's value.</td>
  </tr>
  <tr>
    <td>UpdateTiles</td>
    <td>column
row
columns
ids
colorOffset
flag</td>
    <td>A helper method which allows you to update several tiles at once.</td>
  </tr>
  <tr>
    <td>WriteSaveData</td>
    <td>key
value</td>
    <td>Allows you to save string data to the game file itself.</td>
  </tr>
</table>


To learn more about each of these methods, check out the full Lua API list.

