# Lua API Cheatsheet

All Lua games have access to a set of APIs that communicate directly with the Pixel Vision 8 engine. These are exposed via the Game Chip. This bridge allows you to access the native properties and methods of the core framework.

## Lifecycle
| Name | Arguments | Description |
| ---- | ---- | ----------- |
| Draw |  | Draw() is called once per frame after the Update() has completed.|
| Reset |  | Reset() is called when a game is restarted.|
| Shutdown |  | Shutdown() is called when quitting a game or shutting down the Runner/Game Creator.|

## Color
| Name | Arguments | Description |
| ---- | ---- | ----------- |
| BackgroundColor | id<br/> | The background color is used to fill the screen when clearing the display. This method returns the current background color ID.|
| Color | id<br/>value<br/> | The Color() method allows you to read and update color values in the ColorChip. This method returns a hex string for the supplied color ID.|
| ColorsPerSprite |  | Pixel Vision 8 sprites have limits around how many colors they can display at once which is called the Colors Per Sprite or CPS.|
| ReplaceColor | index<br/>id<br/> | The ReplaceColor() method allows you to quickly change a color to an existing color without triggering the DisplayChip to parse and cache a new hex value.|
| TotalColors | ignoreEmpty<br/> | The TotalColors() method simply returns the total number of colors in the ColorChip. This method returns the total number of colors in the color chip based on the ignoreEmpty argument's value.|

## Display
| Name | Arguments | Description |
| ---- | ---- | ----------- |
| Clear | x<br/>y<br/>width<br/>height<br/> | Clearing the display removed all of the existing pixel data, replacing it with the default background color.|
| Display | visible<br/> | The display's size defines the visible area where pixel data exists on the screen.|
| DrawPixel | x<br/>y<br/>colorRef<br/>drawMode<br/> | This method allows you to draw a single pixel to the Tilemap Cache.|
| DrawPixels | pixelData<br/>x<br/>y<br/>width<br/>height<br/>drawMode<br/>flipH<br/>flipV<br/>colorOffset<br/> | This method allows you to draw raw pixel data directly to the display.|
| DrawRect | x<br/>y<br/>width<br/>height<br/>color<br/>drawMode<br/> | This method allows you to draw a rectangle with a fill color.|
| DrawSprite | id<br/>x<br/>y<br/>flipH<br/>flipV<br/>drawMode<br/>colorOffset<br/> | Sprites represent individual collections of pixel data at a fixed size.|
| DrawSpriteBlock | id<br/>x<br/>y<br/>width<br/>height<br/>flipH<br/>flipV<br/>drawMode<br/>colorOffset<br/>onScreen<br/>useScrollPos<br/> | DrawSpriteBlock() is similar to DrawSprites except you define the first sprite (upper left corner) and the width x height (in sprites) to sample from sprite ram.|
| DrawSprites | ids<br/>x<br/>y<br/>width<br/>flipH<br/>flipV<br/>drawMode<br/>colorOffset<br/>onScreen<br/>useScrollPos<br/>bounds<br/> | The DrawSprites method makes it easier to combine and draw groups of sprites to the display in a grid.|
| DrawText | text<br/>x<br/>y<br/>drawMode<br/>font<br/>colorOffset<br/>spacing<br/> | The DrawText() method allows you to render text to the display.|
| DrawTile | id<br/>c<br/>r<br/>drawMode<br/>colorOffset<br/> | The DrawTile method makes it easier to update the visuals of a tile on any of the map layers.|
| DrawTilemap | x<br/>y<br/>columns<br/>rows<br/>offsetX<br/>offsetY<br/>drawMode<br/> | By default, the tilemap renders to the display by simply calling DrawTilemap().|
| DrawTiles | ids<br/>c<br/>r<br/>width<br/>drawMode<br/>colorOffset<br/> | The DrawTiles method makes it easier to update the visuals of multiple tiles at once by leveraging the DrawTile method.|
| RedrawDisplay |  | You can use RedrawDisplay to make clearing and drawing the tilemap easier.|
| ScrollPosition | x<br/>y<br/> | You can scroll the tilemap by calling the ScrollPosition() method and supplying a new scroll X and Y position. By default, this method returns a vector with the current scroll X and Y position.|

## File IO
| Name | Arguments | Description |
| ---- | ---- | ----------- |
| ReadSaveData | key<br/>defaultValue<br/> | Allows you to read saved data by supplying a key. Returns string data associated with the supplied key.|
| WriteSaveData | key<br/>value<br/> | Allows you to save string data to the game file itself.|

## Input
| Name | Arguments | Description |
| ---- | ---- | ----------- |
| Button | button<br/>state<br/>controllerID<br/> | The main form of input for Pixel Vision 8 is the controller's buttons. Returns a bool based on the state of the button.|
| InputString |  | The InputString() method returns the keyboard input entered this frame.|
| Key | key<br/>state<br/> | While the main form of input in Pixel Vision 8 comes from the controllers, you can test for keyboard input by calling the Key() method. This method returns a bool based on the state of the button.|
| MouseButton | button<br/>state<br/> | Pixel Vision 8 supports mouse input. Returns a bool based on the state of the button.|
| MousePosition |  | The MousePosition() method returns a vector for the current cursor's X and Y position.|

## Sound
| Name | Arguments | Description |
| ---- | ---- | ----------- |
| PauseSong |  | Toggles the current playback state of the sequencer.|
| PlaySong | loopIDs<br/>loop<br/> | This helper method allows you to automatically load a set of loops as a complete song and plays them back.|
| PlaySound | id<br/>channel<br/> | This method plays back a sound on a specific channel.|
| RewindSong | position<br/>loopID<br/> | Rewinds the sequencer to the beginning of the currently loaded song.|
| Sound | id<br/>data<br/> | This method allows your read and write raw sound data on the SoundChip.|
| StopSong |  | Stops the sequencer.|
| StopSound | channel<br/> | Use StopSound() to stop any sound playing on a specific channel.|

## Sprite
| Name | Arguments | Description |
| ---- | ---- | ----------- |
| MaxSpriteCount | total<br/> | This method returns the maximum number of sprites the Display Chip can render in a single frame. Returns an int representing the total number of sprites on the screen at once.|
| Sprite | id<br/>data<br/> | This allows you to return the pixel data of a sprite or overwrite it with new data. Returns an array of int data which points to color ids.|
| SpriteSize | width<br/>height<br/> | Returns the size of the sprite as a Vector where X and Y represent the width and height. Returns a vector where the X and Y for the sprite's width and height.|
| Sprites | ids<br/>width<br/> | This allows you to get the pixel data of multiple sprites.|
| TotalSprites | ignoreEmpty<br/> | Returns the total number of sprites in the system. This method returns the total number of sprites in the color chip based on the ignoreEmpty argument's value.|

## Tilemap
| Name | Arguments | Description |
| ---- | ---- | ----------- |
| Flag | column<br/>row<br/>value<br/> | This allows you to quickly access just the flag value of a tile.|
| RebuildTilemap | columns<br/>rows<br/>spriteIDs<br/>colorOffsets<br/>flags<br/> | This forces the map to redraw its cached pixel data.|
| Tile | column<br/>row<br/>spriteID<br/>colorOffset<br/>flag<br/> | This allows you to get the current sprite id, color offset and flag values associated with a given tile. Returns a dictionary containing the spriteID, colorOffset, and flag for an individual tile.|
| TilemapSize | width<br/>height<br/> | This will return a vector representing the size of the tilemap in columns (x) and rows (y). Returns a vector of the tile maps size in tiles where x and y are the columns and rows of the tilemap.|
| UpdateTiles | column<br/>row<br/>columns<br/>ids<br/>colorOffset<br/>flag<br/> | A helper method which allows you to update several tiles at once.|

# Lua Game Chip API

The following APIs are specific to the Lua Game Chip found in the Game Creator. These methods are also available in the runner but are not part of the core C# API. These are helper functions that are available globally from any Lua script to bridge missing functionality not found in the core Game Chip itself.

## Lifecycle
| Name | Arguments | Description |
| ---- | ---- | ----------- |
| Init |  | Init() is called when a game is loaded into memory and is ready to be played.|

## Math
| Name | Arguments | Description |
| ---- | ---- | ----------- |
| CalculateIndex | x<br/>y<br/>width<br/> | Converts an X and Y position into an index. Returns an int value representing the X and Y position in a 1D array.|
| CalculatePosition | index<br/>width<br/> | Converts an index into an X and Y position to help when working with 1D arrays that represent 2D data. Returns a vector representing the X and Y position of an index in a 1D array.|
| Clamp | val<br/>min<br/>max<br/> | Limits a value between a minimum and maximum. Returns an int within the min and max range.|
| Repeat | val<br/>max<br/> | Repeats a value based on the max. Returns an int that is never less than 0 or greater than the max.|

## Utils
| Name | Arguments | Description |
| ---- | ---- | ----------- |
| SplitLines | str<br/> | This calls the TextUtil's SplitLines() helper to convert text with line breaks (\n) into a collection of lines. Returns an array of strings representing each line of text.|
| WordWrap | text<br/>width<br/> | This allows you to call the TextUtil's WordWrap helper to wrap a string of text to a specified character width.|

## Scripts
| Name | Arguments | Description |
| ---- | ---- | ----------- |
| AddScript | name<br/>script<br/> | This allows you to add your Lua scripts at runtime to a game from a string.|
| LoadScript | name<br/> | This allows you to load a script into memory.|

## Sound
| Name | Arguments | Description |
| ---- | ---- | ----------- |
| PlayRawSound | data<br/>channel<br/>frequency<br/> | This helper method allows you to pass raw SFXR string data to the sound chip for playback.|

## Geometry
| Name | Arguments | Description |
| ---- | ---- | ----------- |
| NewRect | x<br/>y<br/>w<br/>h<br/> | A Rect is a Pixel Vision 8 primitive used for defining the bounds of an object on the display. Returns a new instance of a Rect to be used as a Lua object.|
| NewVector | x<br/>y<br/> | A Vector is a Pixel Vision 8 primitive used for defining a position on the display as an x,y value. Returns a new instance of a Vector to be used as a Lua object.|

# Enums

Pixel Vision 8’s APIs leverage several Enums. You can find a full listing of the enums referenced in the API docs below.

## Buttons

The Button enum contains all of the valid buttons on the controller.

 

<table>
  <tr>
    <td>Enum</td>
    <td>Value</td>
  </tr>
  <tr>
    <td>Buttons.Up</td>
    <td>0</td>
  </tr>
  <tr>
    <td>Buttons.Down</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Buttons.Left</td>
    <td>2</td>
  </tr>
  <tr>
    <td>Buttons.Right</td>
    <td>3</td>
  </tr>
  <tr>
    <td>Buttons.A</td>
    <td>4</td>
  </tr>
  <tr>
    <td>Buttons.B</td>
    <td>5</td>
  </tr>
  <tr>
    <td>Buttons.Select</td>
    <td>6</td>
  </tr>
  <tr>
    <td>Buttons.Start</td>
    <td>7</td>
  </tr>
</table>


## InputState

The InputState enum contains the vaid states of a button.

<table>
  <tr>
    <td>Enum</td>
    <td>Value</td>
  </tr>
  <tr>
    <td>InputState.Down</td>
    <td>0</td>
  </tr>
  <tr>
    <td>InputState.Released</td>
    <td>1</td>
  </tr>
</table>


## DrawMode

The DrawMode enum contains all of the valid render layers and modes available to the DisplayChip.

<table>
  <tr>
    <td>Enum</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>DrawMode.Background</td>
    <td>0</td>
    <td>This is the clear layer and is usually reserved for filling the screen with a background color.</td>
  </tr>
  <tr>
    <td>DrawMode.SpriteBelow</td>
    <td>1</td>
    <td>This is a layer dedicated to sprites just above the background.</td>
  </tr>
  <tr>
    <td>DrawMode.Tile</td>
    <td>2</td>
    <td>This is the tilemap layer and is drawn above the SpriteBelow layer allowing sprites to appear behind the background.</td>
  </tr>
  <tr>
    <td>DrawMode.Sprite</td>
    <td>3</td>
    <td>This is the default layer for sprites to be rendered at. It is above the background.</td>
  </tr>
  <tr>
    <td>DrawMode.UI</td>
    <td>4</td>
    <td>This is a special layer which can be used to draw raw pixel data above the background and sprites. It's designed for HUDs in your game and other graphics that do not scroll with the tilemap.</td>
  </tr>
  <tr>
    <td>DrawMode.SpriteAbove</td>
    <td>5</td>
    <td>This layer allows sprites to render above the UI layer. It is useful for mouse cursors or other graphics that need to be on top of all other layers.</td>
  </tr>
</table>


## SaveFlags

The SaveFlags enum is used when loading or saving a game’s state. It helps define each of the pieces of data used to make a complete game when loading it into memory. This is used specifically for the GameEditor.

<table>
  <tr>
    <td>Enum</td>
    <td>Value</td>
  </tr>
  <tr>
    <td>SaveFlags.System</td>
    <td>1</td>
  </tr>
  <tr>
    <td>SaveFlags.Code</td>
    <td>2</td>
  </tr>
  <tr>
    <td>SaveFlags.Colors</td>
    <td>4</td>
  </tr>
  <tr>
    <td>SaveFlags.ColorMap</td>
    <td>8</td>
  </tr>
  <tr>
    <td>SaveFlags.Sprites</td>
    <td>16</td>
  </tr>
  <tr>
    <td>SaveFlags.Tilemap</td>
    <td>32</td>
  </tr>
  <tr>
    <td>SaveFlags.TilemapFlags</td>
    <td>64</td>
  </tr>
  <tr>
    <td>SaveFlags.Fonts</td>
    <td>128</td>
  </tr>
  <tr>
    <td>SaveFlags.Meta</td>
    <td>256</td>
  </tr>
  <tr>
    <td>SaveFlags.Music</td>
    <td>512</td>
  </tr>
  <tr>
    <td>SaveFlags.Sounds</td>
    <td>1024</td>
  </tr>
  <tr>
    <td>SaveFlags.SpriteCache</td>
    <td>2048</td>
  </tr>
  <tr>
    <td>SaveFlags.TilemapCache</td>
    <td>4096</td>
  </tr>
  <tr>
    <td>SaveFlags.SaveData</td>
    <td>8192</td>
  </tr>
</table>


