# Lua API

All Lua games have access to a set of APIs that communicate directly with the Pixel Vision 8 engine. These are exposed via the Game Chip. This bridge allows you to access the native properties and methods of the core framework. While the engine itself contains lots of separate system working together, only a small subset of these are exposed to the Lua API. Additional APIs can be accessed through other bridges which are automatically loaded by each chip. 

## Game Lifecycle

The game has several built-in methods you can implement to hook into the engine as it runs. These are the main methods:

<table>
  <tr>
    <td>Name</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>Init()</td>
    <td>This is called when a game is initialized. It is only called once when the game is first loaded.</td>
  </tr>
  <tr>
    <td>Update()</td>
    <td>This is called when the game is updated before the draw call. Use this method for non-visual updates, such as calculations, input detection, etc.
</td>
  </tr>
  <tr>
    <td>Draw()</td>
    <td>This is used for render logic. Place draw calls in this method.</td>
  </tr>
  <tr>
    <td>Reset()
</td>
    <td>This is called when a game is reset.</td>
  </tr>
</table>


Be sure to check out the source code for each of the demo games to see how all of this works.

## Methods

### BackgroundColor ( id )

#### Summary

The background color is used to fill the screen when clearing the display. You can use this method to read or update the background color at any point during the GameChip's draw phase. When calling BackgroundColor(), without an argument, it returns the current background color int. You can pass in an optional int to update the background color by calling BackgroundColor(0) where 0 is any valid ID in the ColorChip. Passing in a value such as -1, or one that is out of range, defaults the background color to magenta (#ff00ff) which is the engine's default transparent color.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>id</td>
    <td>int</td>
    <td>This argument is optional. Supply an int to update the existing background color value.</td>
  </tr>
</table>


#### Returns

This method returns the current background color ID. If no color exists, it returns -1 which is magenta (#FF00FF).

* * *


### Button ( button, state, controllerID )

#### Summary

The main form of input for Pixel Vision 8 is the controller's buttons. You can get the current state of any button by calling the Button() method and supplying a button ID, an InputState enum, and the controller ID. When called, the Button() method returns a bool for the requested button and its state. The InputState enum contains options for testing the Down and Released states of the supplied button ID. By default, Down is automatically used which returns true when the key was pressed in the current frame. When using Released, the method returns true if the key is currently up but was down in the last frame.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>button</td>
    <td>Buttons</td>
    <td>Accepts the Buttons enum or int for the button's ID.</td>
  </tr>
  <tr>
    <td>state</td>
    <td>InputState</td>
    <td>Optional InputState enum. Returns down state by default.</td>
  </tr>
  <tr>
    <td>controllerID</td>
    <td>int</td>
    <td>An optional InputState enum. Uses InputState.Down default.</td>
  </tr>
</table>


#### Returns

Returns a bool based on the state of the button.

* * *


### CalculateIndex ( x, y, width )

#### Summary

Converts an X and Y position into an index. This is useful for finding positions in 1D arrays that represent 2D data.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>x</td>
    <td>int</td>
    <td>The x position.</td>
  </tr>
  <tr>
    <td>y</td>
    <td>int</td>
    <td>The y position.</td>
  </tr>
  <tr>
    <td>width</td>
    <td>int</td>
    <td>The width of the data if it was represented as a 2D array.</td>
  </tr>
</table>


#### Returns

Returns an int value representing the X and Y position in a 1D array.

* * *


### CalculatePosition ( index, width )

#### Summary

Converts an index into an X and Y position to help when working with 1D arrays that represent 2D data.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>index</td>
    <td>int</td>
    <td>The position of the 1D array.</td>
  </tr>
  <tr>
    <td>width</td>
    <td>int</td>
    <td>The width of the data if it was a 2D array.</td>
  </tr>
</table>


#### Returns

Returns a vector representing the X and Y position of an index in a 1D array.

* * *


### Clamp ( val, min, max )

#### Summary

Limits a value between a minimum and maximum.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>val</td>
    <td>int</td>
    <td>The value to clamp.</td>
  </tr>
  <tr>
    <td>min</td>
    <td>int</td>
    <td>The minimum the value can be.</td>
  </tr>
  <tr>
    <td>max</td>
    <td>int</td>
    <td>The maximum the value can be.</td>
  </tr>
</table>


#### Returns

Returns an int within the min and max range.

* * *


### Clear ( x, y, width, height )

#### Summary

Clearing the display removed all of the existing pixel data, replacing it with the default background color. The Clear() method allows you specify what region of the display to clear. By simply calling Clear(), with no arguments, it automatically clears the entire display. You can manually define an area of the screen to clear by supplying option x, y, width and height arguments. When clearing a specific area of the display, anything outside of the defined boundaries remains on the next draw phase. This is useful for drawing a HUD but clearing the display below for a scrolling map and sprites. Clear can only be used once during the draw phase.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>x</td>
    <td>int</td>
    <td>This is an optional value that defaults to 0 and defines where the clear's X position should begin. When X is 0, clear starts on the far left-hand side of the display. Values less than 0 or greater than the width of the display are ignored.</td>
  </tr>
  <tr>
    <td>y</td>
    <td>int</td>
    <td>This is an optional value that defaults to 0 and defines where the clear's Y position should begin. When Y is 0, clear starts at the top of the display. Values less than 0 or greater than the height of the display are ignored.</td>
  </tr>
  <tr>
    <td>width</td>
    <td>int</td>
    <td>This is an optional value that defaults to the width of the display and defines how many horizontal pixels to clear. When the width is 0, clear starts at the x position and ends at the far right-hand side of the display. Values less than 0 or greater than the width are adjusted to stay within the boundaries of the screen's visible pixels.</td>
  </tr>
  <tr>
    <td>height</td>
    <td>int</td>
    <td>This is an optional value that defaults to the height of the display and defines how many vertical pixels to clear. When the height is 0, clear starts at the Y position and ends at the bottom of the display. Values less than 0 or greater than the height are adjusted to stay within the boundaries of the screen's visible pixels.</td>
  </tr>
</table>


* * *


### Color ( id, value )

#### Summary

The Color() method allows you to read and update color values in the ColorChip. This method has two modes which require a color ID to work. By calling the method with just an ID, like Color(0), it returns a hex string for the given color at the supplied color ID. By passing in a new hex string, like Color(0, "#FFFF00"), you can change the color with the given ID. While you can use this method to modify color values directly, you should avoid doing this at run time since the DisplayChip must parse and cache the new hex value. If you just want to change a color to an existing value, use the ReplaceColor() method.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>id</td>
    <td>int</td>
    <td>The ID of the color you want to access.</td>
  </tr>
  <tr>
    <td>value</td>
    <td>string</td>
    <td>This argument is optional. It accepts a hex as a string and updates the supplied color ID's value.</td>
  </tr>
</table>


#### Returns

This method returns a hex string for the supplied color ID. If the color has not been set or is out of range, it returns magenta (#FF00FF) which is the default transparent system color.

* * *


### ColorsPerSprite ( )

#### Summary

Pixel Vision 8 sprites have limits around how many colors they can display at once which is called the Colors Per Sprite or CPS. The ColorsPerSprite() method returns this value from the SpriteChip. While this is read-only at run-time, it has other important uses. If you set up your ColorChip in palettes, grouping sets of colors together based on the SpriteChip's CPS value, you can use this to shift a sprite's color offset up or down by a fixed amount when drawing it to the display. Since this value does not change when a game is running, it is best to get a reference to it when the game starts up and store it in a local variable.

* * *


### DisplaySize ( width, height )

#### Summary

The display's size defines the visible area where pixel data exists on the screen. Calculating this is important for knowing how to position sprites on the screen. The DisplaySize() method allows you to get the resolution of the display at run time. While you can also define a new resolution by providing a width and height value, this may not work correctly at runtime and is currently experimental. You should instead set the resolution before loading the game. If you are using overscan, you must subtract it from the width and height of the returned vector to find the "visible pixel" dimensions.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>width</td>
    <td>int</td>
    <td>An optional value that defaults to null. Setting this argument changes the pixel width of the display. Avoid using this at run-time.</td>
  </tr>
  <tr>
    <td>height</td>
    <td>int</td>
    <td>New height for the display.</td>
  </tr>
</table>


#### Returns

This method returns a Vector representing the display's size. The X and Y values refer to the pixel width and height of the screen.

* * *


### DrawPixels ( pixelData, x, y, width, height, drawMode, flipHflipV, colorOffset )

#### Summary

This method allows you to draw raw pixel data directly to the display. Depending on which draw mode you use, the pixel data could be rendered as a sprite or drawn directly onto the tilemap cache. Sprites drawn with this method still count against the total number the display can render but you can draw irregularly shaped sprites by defining a custom width and height. For drawnig into the tilemap cache directly, you can use this to change the way the tilemap looks at run-time without having to modify a sprite's pixel data. It is important to note that when you change a tile's sprite ID or color offset, the tilemap redraws it back to the cache overwriting any pixel data that was previously there.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>pixelData</td>
    <td>int[]</td>
    <td>The pixelData argument accepts an int array representing references to color IDs. The pixelData array length needs to be the same size as the supplied width and height, or it will throw an error.</td>
  </tr>
  <tr>
    <td>x</td>
    <td>int</td>
    <td>The x position where to display the new pixel data. The display's horizontal 0 position is on the far left-hand side. When using DrawMode.TilemapCache, the pixel data is drawn into the tilemap's cache instead of directly on the display when using DrawMode.Sprite.</td>
  </tr>
  <tr>
    <td>y</td>
    <td>int</td>
    <td>The Y position where to display the new pixel data. The display's vertical 0 position is on the top. When using DrawMode.TilemapCache, the pixel data is drawn into the tilemap's cache instead of directly on the display when using DrawMode.Sprite.</td>
  </tr>
  <tr>
    <td>width</td>
    <td>int</td>
    <td>The width of the pixel data to use when rendering to the display.</td>
  </tr>
  <tr>
    <td>height</td>
    <td>int</td>
    <td>The height of the pixel data to use when rendering to the display.</td>
  </tr>
  <tr>
    <td>drawMode</td>
    <td>DrawMode</td>
    <td>This argument accepts the DrawMode enum. You can use Sprite, SpriteBelow, and TilemapCache to change where the pixel data is drawn to. By default, this value is DrawMode.Sprite.</td>
  </tr>
  <tr>
    <td>flipH</td>
    <td>bool</td>
    <td>This is an optional argument which accepts a bool. The default value is set to false but passing in true flips the pixel data horizontally.</td>
  </tr>
  <tr>
    <td>flipV</td>
    <td>bool</td>
    <td>This is an optional argument which accepts a bool. The default value is set to false but passing in true flips the pixel data vertically.</td>
  </tr>
  <tr>
    <td>colorOffset</td>
    <td>int</td>
    <td>This optional argument accepts an int that offsets all the color IDs in the pixel data array. This value is added to each int, in the pixel data array, allowing you to simulate palette shifting.</td>
  </tr>
</table>


* * *


### DrawSprite ( id, x, y, flipH, flipV, aboveBG, colorOffset )

#### Summary

Sprites represent individual collections of pixel data at a fixed size. By default, Pixel Vision 8 sprites are 8 x 8 pixels and have a set limit of visible colors. You can use the DrawSprite() method to render any sprite stored in the Sprite Chip. The display also has a limitation on how many sprites can be on the screen at one time. Each time you call DrawSprite(), the sprite counts against the total amount the display can render. If you attempt to draw more sprites than the display can handle, the call is ignored. One thing to keep in mind when drawing sprites is that their x and y position wraps if they reach the right or bottom border of the screen. You need to change the overscan border to hide sprites offscreen.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>id</td>
    <td>int</td>
    <td>The unique ID of the sprite to use in the SpriteChip.</td>
  </tr>
  <tr>
    <td>x</td>
    <td>int</td>
    <td>An int value representing the X position to place sprite on the display. If set to 0, it renders on the far left-hand side of the screen.</td>
  </tr>
  <tr>
    <td>y</td>
    <td>int</td>
    <td>An int value representing the Y position to place sprite on the display. If set to 0, it renders on the top of the screen.</td>
  </tr>
  <tr>
    <td>flipH</td>
    <td>bool</td>
    <td>This is an optional argument which accepts a bool. The default value is set to false but passing in true flips the pixel data horizontally.</td>
  </tr>
  <tr>
    <td>flipV</td>
    <td>bool</td>
    <td>This is an optional argument which accepts a bool. The default value is set to false but passing in true flips the pixel data vertically.</td>
  </tr>
  <tr>
    <td>aboveBG</td>
    <td>bool</td>
    <td>An optional bool that defines if the sprite is above or below the tilemap. Sprites are set to render above the tilemap by default. When rendering below the tilemap, the sprite is visible in the transparent area of the tile above the background color.</td>
  </tr>
  <tr>
    <td>colorOffset</td>
    <td>int</td>
    <td>This optional argument accepts an int that offsets all the color IDs in the pixel data array. This value is added to each int, in the pixel data array, allowing you to simulate palette shifting.</td>
  </tr>
</table>


* * *


### DrawSprites ( ids, x, y, width, flipH, flipV, aboveBG, colorOffset, onScreen )

#### Summary

The DrawSprites method makes it easier to combine and draw groups of sprites to the display in a grid. This is useful when trying to render 4 sprites together as a larger 16x16 pixel graphic. While there is no limit on the size of the sprite group which can be rendered, it is important to note that each sprite in the array still counts as an individual sprite. Sprites passed into the DrawSprites() method are visible if the display can render it. Under the hood, this method uses DrawSprite but solely manages positioning the sprites out in a grid. Another unique feature of his helper method is that it automatically hides sprites that go offscreen. When used with overscan border, it greatly simplifies drawing larger sprites to the display.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>ids</td>
    <td>int[]</td>
    <td>An array of sprite IDs to display on the screen.</td>
  </tr>
  <tr>
    <td>x</td>
    <td>int</td>
    <td>An int value representing the X position to place sprite on the display. If set to 0, it renders on the far left-hand side of the screen.</td>
  </tr>
  <tr>
    <td>y</td>
    <td>int</td>
    <td>An int value representing the Y position to place sprite on the display. If set to 0, it renders on the top of the screen.</td>
  </tr>
  <tr>
    <td>width</td>
    <td>int</td>
    <td>The width, in sprites, of the grid. A value of 2 renders 2 sprites wide. The DrawSprites method continues to run through all of the sprites in the ID array until reaching the end. Sprite groups do not have to be perfect squares since the width value is only used to wrap sprites to the next row.</td>
  </tr>
  <tr>
    <td>flipH</td>
    <td>bool</td>
    <td>This is an optional argument which accepts a bool. The default value is set to false but passing in true flips the pixel data horizontally.</td>
  </tr>
  <tr>
    <td>flipV</td>
    <td>bool</td>
    <td>This is an optional argument which accepts a bool. The default value is set to false but passing in true flips the pixel data vertically.</td>
  </tr>
  <tr>
    <td>aboveBG</td>
    <td>bool</td>
    <td>An optional bool that defines if the sprite is above or below the tilemap. Sprites are set to render above the tilemap by default. When rendering below the tilemap, the sprite is visible in the transparent area of the tile above the background color.</td>
  </tr>
  <tr>
    <td>colorOffset</td>
    <td>int</td>
    <td>This optional argument accepts an int that offsets all the color IDs in the pixel data array. This value is added to each int, in the pixel data array, allowing you to simulate palette shifting.</td>
  </tr>
  <tr>
    <td>onScreen</td>
    <td>bool</td>
    <td>This flag defines if the sprites should not render when they are off the screen. Use this in conjunction with overscan border control what happens to sprites at the edge of the display. If this value is false, the sprites wrap around the screen when they reach the edges of the screen.</td>
  </tr>
</table>


* * *


### DrawText ( text, x, y, drawMode, font, colorOffset, spacing, width )

#### Summary

The DrawText() method allows you to render text to the display. By supplying a custom DrawMode, you can render characters as individual sprites (DrawMode.Sprite), tiles (DrawMode.Tile) or drawn directly into the tilemap cache (DrawMode.TilemapCache). When drawing text as sprites, you have more flexibility over position, but each character counts against the displays' maximum sprite count. When rendering text to the tilemap, more characters are shown and also increase performance when rendering large amounts of text. You can also define the color offset, letter spacing which only works for sprite and tilemap cache rendering, and a width in characters if you want the text to wrap.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>text</td>
    <td>string</td>
    <td>A text string to display on the screen.</td>
  </tr>
  <tr>
    <td>x</td>
    <td>int</td>
    <td>An int value representing the X position to start the text on the display. If set to 0, it renders on the far left-hand side of the screen.</td>
  </tr>
  <tr>
    <td>y</td>
    <td>int</td>
    <td>An int value representing the Y position to place sprite on the display. If set to 0, it renders on the top of the screen.</td>
  </tr>
  <tr>
    <td>drawMode</td>
    <td>DrawMode</td>
    <td>This argument accepts the DrawMode enum. You can use Sprite, SpriteBelow, and TilemapCache to change where the pixel data is drawn to. By default, this value is DrawMode.Sprite.</td>
  </tr>
  <tr>
    <td>font</td>
    <td>string</td>
    <td>The name of the font to use. You do not need to add the font's file extension. If the file is called default.font.png, you can simply refer to it as "default" when supplying an argument value.</td>
  </tr>
  <tr>
    <td>colorOffset</td>
    <td>int</td>
    <td>This optional argument accepts an int that offsets all the color IDs in the pixel data array. This value is added to each color ID in the font's pixel data, allowing you to simulate palette shifting.</td>
  </tr>
  <tr>
    <td>spacing</td>
    <td>int</td>
    <td>This optional argument sets the number of pixels between each character when rendering text. This value is ignored when rendering text as tiles. This value can be positive or negative depending on your needs. By default, it is 0.</td>
  </tr>
  <tr>
    <td>width</td>
    <td>int</td>
    <td>This optional argument allows you to wrap text. This accepts an int representing the number of characters before wrapping the text. Only set a value if you want the text to wrap. By default, it is set to null and is ignored.</td>
  </tr>
</table>


* * *


### DrawTilemap ( x, y, columns, rows )

#### Summary

By default, the tilemap renders to the display by simply calling DrawTilemap(). This automatically fills the entire display with the visible portion of the tilemap. To have more granular control over how to render the tilemap, you can supply an optional X and Y position to change where it draws on the screen. You can also modify the width (columns) and height (rows) that are displayed too. This is useful if you want to show a HUD or some other kind of image on the screen that is not overridden by the tilemap. To scroll the tilemap, you need to call the ScrollPosition() and supply a new scroll X and Y value.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>x</td>
    <td>int</td>
    <td>An optional int value representing the X position to render the tilemap on the display. If set to 0, it renders on the far left-hand side of the screen.</td>
  </tr>
  <tr>
    <td>y</td>
    <td>int</td>
    <td>An optional int value representing the Y position to render the tilemap on the display. If set to 0, it renders on the top of the screen.</td>
  </tr>
  <tr>
    <td>columns</td>
    <td>int</td>
    <td>An optional int value representing how many horizontal tiles to include when drawing the map. By default, this is 0 which automatically uses the full visible width of the display, while taking into account the X position offset.</td>
  </tr>
  <tr>
    <td>rows</td>
    <td>int</td>
    <td>An optional int value representing how many vertical tiles to include when drawing the map. By default, this is 0 which automatically uses the full visible height of the display, while taking into account the Y position offset.</td>
  </tr>
</table>


* * *


### Flag ( column, row, value )

#### Summary

This allows you to quickly access just the flag value of a tile. This is useful when trying to the caluclate collision on the tilemap. By default, you can call this method and return the flag value. If you supply a new value, it will be overridden on the tile. Changing a tile's flag value does not force the tile to be redrawn to the tilemap cache.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>column</td>
    <td>int</td>
    <td>The X position of the tile in the tilemap. The 0 position is on the far left of the tilemap.</td>
  </tr>
  <tr>
    <td>row</td>
    <td>int</td>
    <td>The Y position of the tile in the tilemap. The 0 position is on the top of the tilemap.</td>
  </tr>
  <tr>
    <td>value</td>
    <td>int</td>
    <td>The new value for the flag. Setting the flag to -1 means no collision.</td>
  </tr>
</table>


* * *


### InputString ( )

#### Summary

The InputString() method returns the keyboard input entered this frame. This method is useful for capturing keyboard text input.

* * *


### Key ( key, state )

#### Summary

While the main form of input in Pixel Vision 8 comes from the controllers, you can test for keyboard input by calling the Key() method. When called, this method returns the current state of a key. The method accepts the Keys enum, or an int, for a specific key. In additon, you need to provide the input state to check for. The InputState enum has two states, Down and Released. By default, Down is automatically used which returns true when the key is being pressed in the current frame. When using Released, the method returns true if the key is currently up but was down in the last frame.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>key</td>
    <td>Keys</td>
    <td>This argument accepts the Keys enum or an int for the key's ID.</td>
  </tr>
  <tr>
    <td>state</td>
    <td>InputState</td>
    <td>Optional InputState enum. Returns down state by default. This argument accepts InputState.Down (0) or InputState.Released (1).</td>
  </tr>
</table>


#### Returns

This method returns a bool based on the state of the button.

* * *


### MouseButton ( button, state )

#### Summary

Pixel Vision 8 supports mouse input. You can get the current state of the mouse's left (0) and right (1) buttons by calling MouseButton(). In addition to supplying a button ID, you also need to provide the InputState enum. The InputState enum contains options for testing the Down and Released states of the supplied button ID. By default, Down is automatically used which returns true when the key was pressed in the current frame. When using Released, the method returns true if the key is currently up but was down in the last frame.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>button</td>
    <td>int</td>
    <td>Accepts an int for the left (0) or right (1) mouse button.</td>
  </tr>
  <tr>
    <td>state</td>
    <td>InputState</td>
    <td>An optional InputState enum. Uses InputState.Down default.</td>
  </tr>
</table>


#### Returns

Returns a bool based on the state of the button.

* * *


### MousePosition ( )

#### Summary

The MousePosition() method returns a vector for the current cursor's X and Y position. This value is read-only. The mouse's 0,0 position is in the upper left-hand corner of the display

* * *


### OverscanBorder ( x, y )

#### Summary

Pixel Vision 8's overscan value allows you to define parts of the screen that are not visible similar to how older CRT TVs rendered images. This overscan border allows you to hide sprites off the screen so they do not wrap around the edges. You can call OverscanBorder() without any arguments to return a vector for the right and bottom border value. This value represents a full column and row that the renderer crops from the tilemap. To get the actual pixel value of the right and bottom border, multiply this value by the sprite's size. It is also important to note that Pixel Vision 8 automatically crops the display to reflect the overscan. So a resolution of 256x244, with an overscan x and y value of 1, actually displays 248x236 pixels. While you can change the OverscanBorder at run-time by calling OverscanBorder() and supplying a new X and Y value, this should not be done while a game is running.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>x</td>
    <td>int</td>
    <td>An optional argument that represents the number of columns from the right edge of the screen to not display. Each column value removes 8 pixels. So setting X to 1 eliminates the width of a single sprite from the screen's right-hand border.</td>
  </tr>
  <tr>
    <td>y</td>
    <td>int</td>
    <td>An optional argument that represents the number of rows from the bottom edge of the screen to not display. Each row value removes 8 pixels. So setting Y to 1 eliminates the height of a single sprite from the screen's bottom border.</td>
  </tr>
</table>


#### Returns

This method returns the overscan's X (right) and Y (bottom) border value as a vector. Each X and Y value needs to be multiplied by 8 to get the actual pixel size of the overscan border. Use this value to calculate the actual visible screen area which may be different than the display's native resolution. Also useful to position sprites offscreen when not needed, so they do not wrap around the screen.

* * *


### PauseSong ( )

#### Summary

Toggles the current playback state of the sequencer. If the song is playing it will pause, if it is paused it will play.

* * *


### PlaySong ( trackIDs, loop )

#### Summary

This helper method allows you to automatically load a set of loops as a complete song and plays them back. You can also define if the tracks should loop when they are done playing.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>trackIDs</td>
    <td>int[]</td>
    <td>An array of loop IDs to playback as a single song.</td>
  </tr>
  <tr>
    <td>loop</td>
    <td>bool</td>
    <td>A bool that determines if the song should loop back to the first ID when it is done playing.</td>
  </tr>
</table>


* * *


### PlaySound ( id, channel )

#### Summary

This method plays back a sound on a specific channel. The SoundChip has a limit of active channels so playing a sound effect while another was is playing on the same channel will cancel it out and replace with the new sound.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>id</td>
    <td>int</td>
    <td>The ID of the sound in the SoundCollection.</td>
  </tr>
  <tr>
    <td>channel</td>
    <td>int</td>
    <td>The channel the sound should play back on. Channel 0 is set by default.</td>
  </tr>
</table>


* * *


### ReadSaveData ( key, defaultValue )

#### Summary

Allows you to read saved data by supplying a key. If no matching key exists, "undefined" is returned.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>key</td>
    <td>string</td>
    <td>The string key used to find the data.</td>
  </tr>
  <tr>
    <td>defaultValue</td>
    <td>string</td>
    <td>The optional string to use if data does not exist.</td>
  </tr>
</table>


#### Returns

Returns string data associated with the supplied key.

* * *


### RebuildTilemap ( )

#### Summary

This forces the map to redraw its cached pixel data. Use this to clear any pixel data added after the map created the pixel data cache.

* * *


### RedrawDisplay ( )

#### Summary

You can use RedrawDisplay to make clearing and drawing the tilemap easier. This is a helper method automatically calls both Clear() and DrawTilemap() for you.

* * *


### Repeat ( val, max )

#### Summary

Repeats a value based on the max. When the value is greater than the max, it starts over at 0 plus the remaining value.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>val</td>
    <td>int</td>
    <td>The value to repeat.</td>
  </tr>
  <tr>
    <td>max</td>
    <td>int</td>
    <td>The maximum the value can be.</td>
  </tr>
</table>


#### Returns

Returns an int that is never less than 0 or greater than the max.

* * *


### ReplaceColor ( index, id )

#### Summary

The ReplaceColor() method allows you to quickly change a color to an existing color without triggering the DisplayChip to parse and cache a new hex value. Consider this an alternative to the Color() method. It is useful for simulating palette swapping animation on sprites pointed to a fixed group of color IDs. Simply cal the ReplaceColor() method and supply a target color ID position, then the new color ID it should point to. Since you are only changing the color's ID pointer, there is little to no performance penalty during the GameChip's draw phase.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>index</td>
    <td>int</td>
    <td>The ID of the color you want to change.</td>
  </tr>
  <tr>
    <td>id</td>
    <td>int</td>
    <td>The ID of the color you want to replace it with.</td>
  </tr>
</table>


* * *


### RewindSong ( position, loopID )

#### Summary

Rewinds the sequencer to the beginning of the currently loaded song. You can define the position in the loop and the loop where playback should begin. Calling this method without any arguments will simply rewind the song to the beginning of the first loop.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>position</td>
    <td>int</td>
    <td>Position in the loop to start playing at.</td>
  </tr>
  <tr>
    <td>loopID</td>
    <td>int</td>
    <td>The loop to rewind too.</td>
  </tr>
</table>


* * *


### ScrollPosition ( x, y )

#### Summary

You can scroll the tilemap by calling the ScrollPosition() method and supplying a new scroll X and Y position. By default, calling ScrollPosition() with no arguments returns a vector with the current scroll X and Y values. If you supply an X and Y value, it updates the tilemap's scroll position the next time you call the DrawTilemap() method.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>x</td>
    <td>int</td>
    <td>An optional int value representing the scroll X position of the tilemap. If set to 0, it starts on the far left-hand side of the tilemap.</td>
  </tr>
  <tr>
    <td>y</td>
    <td>int</td>
    <td>An optional int value representing the scroll Y position of the tilemap. If set to 0, it starts on the top of the tilemap.</td>
  </tr>
</table>


#### Returns

By default, this method returns a vector with the current scroll X and Y position.

* * *


### Sprite ( id, data )

#### Summary

This allows you to return the pixel data of a sprite or overwrite it with new data. Sprite pixel data is an array of color reference ids. When calling the method with only an id argument, you will get the sprite's pixel data. If you supply data, it will overwrite the sprite. It is important to make sure that any new pixel data should be the same length of the existing sprite's pixel data. This can be calculated by multiplying the sprite's width and height. You can add the transparent area to a sprite's data by using -1.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>id</td>
    <td>int</td>
    <td>The sprite to access.</td>
  </tr>
  <tr>
    <td>data</td>
    <td>int[]</td>
    <td>Optional data to write over the sprite's current pixel data.</td>
  </tr>
</table>


#### Returns

Returns an array of int data which points to color ids.

* * *


### SpriteSize ( width, height )

#### Summary

Returns the size of the sprite as a Vector where X and Y represent the width and height.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>width</td>
    <td>int</td>
    <td>Optional argument to change the width of the sprite. Currently not enabled.</td>
  </tr>
  <tr>
    <td>height</td>
    <td>int</td>
    <td>Optional argument to change the height of the sprite. Currently not enabled.</td>
  </tr>
</table>


#### Returns

Returns a vector where the X and Y for the sprite's width and height.

* * *


### StopSong ( )

#### Summary

Stops the sequencer.

* * *


### Tile ( column, row, spriteID, colorOffset, flag )

#### Summary

This allows you to get the current sprite id, color offset and flag values associated with a given tile. You can optionally supply your own if you want to change the tile's values. Changing a tile's sprite id or color offset will for the tilemap to redraw it to the cache on the next frame. If you are drawing raw pixel data into the tilemap cache in the same position, it will be overwritten with the new tile's pixel data.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>column</td>
    <td>int</td>
    <td>The X position of the tile in the tilemap. The 0 position is on the far left of the tilemap.</td>
  </tr>
  <tr>
    <td>row</td>
    <td>int</td>
    <td>The Y position of the tile in the tilemap. The 0 position is on the top of the tilemap.</td>
  </tr>
  <tr>
    <td>spriteID</td>
    <td>int</td>
    <td>The sprite id to use for the tile.</td>
  </tr>
  <tr>
    <td>colorOffset</td>
    <td>int</td>
    <td>Shift the color IDs by this value.</td>
  </tr>
  <tr>
    <td>flag</td>
    <td>int</td>
    <td>An int value between -1 and 16 used for collision detection.</td>
  </tr>
</table>


#### Returns

Returns a dictionary containing the spriteID, colorOffset, and flag for an individual tile.

* * *


### TilemapSize ( width, height )

#### Summary

This will return a vector representing the size of the tilemap in columns (x) and rows (y). To find the size in pixels, you will need to multiply the returned vectors x and y values by the sprite size's x and y. This method also allows you to resize the tilemap by passing in an optional new width and height. Resizing the tile map is destructive, so any changes will automatically clear the tilemap's sprite ids, color offsets, and flag values.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>width</td>
    <td>int</td>
    <td>An optional parameter for the width in tiles of the map.</td>
  </tr>
  <tr>
    <td>height</td>
    <td>int</td>
    <td>An option parameter for the height in tiles of the map.</td>
  </tr>
</table>


#### Returns

Returns a vector of the tile maps size in tiles where x and y are the columns and rows of the tilemap.

* * *


### TotalColors ( ignoreEmpty )

#### Summary

The TotalColors() method simply returns the total number of colors in the ColorChip. By default, it returns only colors that have been set to value other than magenta (#FF00FF) which is the default transparent value used by the engine. By calling TotalColors(false), it returns the total available color slots in the ColorChip.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>ignoreEmpty</td>
    <td>bool</td>
    <td>This is an optional value that defaults to true. When set to true, the ColorChip returns the total number of colors not set to magenta (#FF00FF). Set this value to false if you want to get all of the available color slots in the ColorChip regardless if they are empty or not.</td>
  </tr>
</table>


#### Returns

This method returns the total number of colors in the color chip based on the ignoreEmpty argument's value.

* * *


### TotalSprites ( ignoreEmpty )

#### Summary

Returns the total number of sprites in the system. You can pass in an optional argument to get a total number of sprites the Sprite Chip can store by passing in false for ignoreEmpty. By default, only sprites with pixel data will be included in the total return.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>ignoreEmpty</td>
    <td>bool</td>
    <td>This is an optional value that defaults to true. When set to true, the SpriteChip returns the total number of sprites that are not empty (where all the pixel data is set to -1). Set this value to false if you want to get all of the available color slots in the ColorChip regardless if they are empty or not.</td>
  </tr>
</table>


#### Returns

This method returns the total number of sprites in the color chip based on the ignoreEmpty argument's value.

* * *


### UpdateTiles ( column, row, columns, ids, colorOffset, flag )

#### Summary

A helper method which allows you to update several tiles at once. Simply define the start column and row position, the width of the area to update in tiles and supply a new int array of sprite IDs. You can also modify the color offset and flag value of the tiles via the optional parameters. This helper method uses calls the Tile() method to update each tile, so any changes to a tile will be automatically redrawn to the tilemap's cache.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>column</td>
    <td>int</td>
    <td>Start column of the first tile to update. The 0 column is on the far left of the tilemap.</td>
  </tr>
  <tr>
    <td>row</td>
    <td>int</td>
    <td>Start row of the first tile to update. The 0 row is on the top of the tilemap.</td>
  </tr>
  <tr>
    <td>columns</td>
    <td>int</td>
    <td>The width of the area in tiles to update.</td>
  </tr>
  <tr>
    <td>ids</td>
    <td>int[]</td>
    <td>An array of sprite IDs to use for each tile being updated.</td>
  </tr>
  <tr>
    <td>colorOffset</td>
    <td>int</td>
    <td>An optional color offset int value to be applied to each updated tile.</td>
  </tr>
  <tr>
    <td>flag</td>
    <td>int</td>
    <td>An optional flag int value to be applied to each updated tile.</td>
  </tr>
</table>


* * *


### WriteSaveData ( key, value )

#### Summary

Allows you to save string data to the game file itself. This data persistent even after restarting a game.

#### Arguments

<table>
  <tr>
    <td>Name</td>
    <td>Value</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>key</td>
    <td>string</td>
    <td>A string to use as the key for the data.</td>
  </tr>
  <tr>
    <td>value</td>
    <td>string</td>
    <td>A string representing the data to be saved.</td>
  </tr>
</table>


