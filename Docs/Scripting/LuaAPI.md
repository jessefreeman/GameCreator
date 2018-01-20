# Complete Lua API

This is a complete list of Pixel Vision 8’s Lua APIs. Some of these methods may contain optional arguments allowing you to provide only the values you need. Be sure to read the description to understand how each method is used. While the engine itself contains lots of separate system working together, only a small subset of these are exposed to the Lua API. Additional APIs can be accessed through other bridges which are automatically loaded by each chip.

## Lifecycle
### Draw (  )
#### Summary
 Draw() is called once per frame after the Update() has completed. This is where all visual updates to your game should take place such as clearing the display, drawing sprites, and pushing raw pixel data into the display. 

---
### Reset (  )
#### Summary
 Reset() is called when a game is restarted. This is usually called instead of reloading the entire game. It allows you to perform additional configuration that would not be able to happen if the Init() method is not called. This is mostly ignored in the Runner and is mainly used in the Game Creator. 

---
### Shutdown (  )
#### Summary
 Shutdown() is called when quitting a game or shutting down the Runner/Game Creator. This hook allows you to perform any last minute changes to the game's data such as saving or removing any temp files that will not be needed. 

---

## Color
### BackgroundColor ( id )
#### Summary
 The background color is used to fill the screen when clearing the display. You can use this method to read or update the background color at any point during the GameChip's draw phase. When calling BackgroundColor(), without an argument, it returns the current background color int. You can pass in an optional int to update the background color by calling BackgroundColor(0) where 0 is any valid ID in the ColorChip. Passing in a value such as -1, or one that is out of range, defaults the background color to magenta (#ff00ff) which is the engine's default transparent color. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| id | int? |  This argument is optional. Supply an int to update the existing background color value.  |

#### Returns
 This method returns the current background color ID. If no color exists, it returns -1 which is magenta (#FF00FF). 

---
### Color ( id, value )
#### Summary
 The Color() method allows you to read and update color values in the ColorChip. This method has two modes which require a color ID to work. By calling the method with just an ID, like Color(0), it returns a hex string for the given color at the supplied color ID. By passing in a new hex string, like Color(0, "#FFFF00"), you can change the color with the given ID. While you can use this method to modify color values directly, you should avoid doing this at run time since the DisplayChip must parse and cache the new hex value. If you just want to change a color to an existing value, use the ReplaceColor() method. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| id | int |  The ID of the color you want to access.  |
| value | string |  This argument is optional. It accepts a hex as a string and updates the supplied color ID's value.  |

#### Returns
 This method returns a hex string for the supplied color ID. If the color has not been set or is out of range, it returns magenta (#FF00FF) which is the default transparent system color. 

---
### ColorsPerSprite (  )
#### Summary
 Pixel Vision 8 sprites have limits around how many colors they can display at once which is called the Colors Per Sprite or CPS. The ColorsPerSprite() method returns this value from the SpriteChip. While this is read-only at run-time, it has other important uses. If you set up your ColorChip in palettes, grouping sets of colors together based on the SpriteChip's CPS value, you can use this to shift a sprite's color offset up or down by a fixed amount when drawing it to the display. Since this value does not change when a game is running, it is best to get a reference to it when the game starts up and store it in a local variable. 

---
### ReplaceColor ( index, id )
#### Summary
 The ReplaceColor() method allows you to quickly change a color to an existing color without triggering the DisplayChip to parse and cache a new hex value. Consider this an alternative to the Color() method. It is useful for simulating palette swapping animation on sprites pointed to a fixed group of color IDs. Simply cal the ReplaceColor() method and supply a target color ID position, then the new color ID it should point to. Since you are only changing the color's ID pointer, there is little to no performance penalty during the GameChip's draw phase. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| index | int | The ID of the color you want to change. |
| id | int | The ID of the color you want to replace it with. |


---
### TotalColors ( ignoreEmpty )
#### Summary
 The TotalColors() method simply returns the total number of colors in the ColorChip. By default, it returns only colors that have been set to value other than magenta (#FF00FF) which is the default transparent value used by the engine. By calling TotalColors(false), it returns the total available color slots in the ColorChip. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| ignoreEmpty | bool |  This is an optional value that defaults to true. When set to true, the ColorChip returns the total number of colors not set to magenta (#FF00FF). Set this value to false if you want to get all of the available color slots in the ColorChip regardless if they are empty or not.  |

#### Returns
 This method returns the total number of colors in the color chip based on the ignoreEmpty argument's value. 

---

## Display
### Clear ( x, y, width, height )
#### Summary
 Clearing the display removed all of the existing pixel data, replacing it with the default background color. The Clear() method allows you specify what region of the display to clear. By simply calling Clear(), with no arguments, it automatically clears the entire display. You can manually define an area of the screen to clear by supplying option x, y, width and height arguments. When clearing a specific area of the display, anything outside of the defined boundaries remains on the next draw phase. This is useful for drawing a HUD but clearing the display below for a scrolling map and sprites. Clear can only be used once during the draw phase. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| x | int |  This is an optional value that defaults to 0 and defines where the clear's X position should begin. When X is 0, clear starts on the far left-hand side of the display. Values less than 0 or greater than the width of the display are ignored.  |
| y | int |  This is an optional value that defaults to 0 and defines where the clear's Y position should begin. When Y is 0, clear starts at the top of the display. Values less than 0 or greater than the height of the display are ignored.  |
| width | int? |  This is an optional value that defaults to the width of the display and defines how many horizontal pixels to clear. When the width is 0, clear starts at the x position and ends at the far right-hand side of the display. Values less than 0 or greater than the width are adjusted to stay within the boundaries of the screen's visible pixels.  |
| height | int? |  This is an optional value that defaults to the height of the display and defines how many vertical pixels to clear. When the height is 0, clear starts at the Y position and ends at the bottom of the display. Values less than 0 or greater than the height are adjusted to stay within the boundaries of the screen's visible pixels.  |


---
### Display ( visible )
#### Summary
 The display's size defines the visible area where pixel data exists on the screen. Calculating this is important for knowing how to position sprites on the screen. The Display() method allows you to get the resolution of the display at run time. By default, this will return the visble screen area based on the overscan value set on the display chip. To calculate the exact overscan in pixels, you must subtract the full size from the visible size. Simply supply false as an argument to get the full display dimensions. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| visible | bool |  |


---
### DrawPixel ( x, y, colorRef, drawMode )
#### Summary
 This method allows you to draw a single pixel to the Tilemap Cache. It's an expensive operation which leverages DrawPixels(). This should only be used in special occasions when batching pixel data draw request aren't possible. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| x | int |  The x position where to display the new pixel data. The display's horizontal 0 position is on the far left-hand side. When using DrawMode.TilemapCache, the pixel data is drawn into the tilemap's cache instead of directly on the display when using DrawMode.Sprite.  |
| y | int |  The Y position where to display the new pixel data. The display's vertical 0 position is on the top. When using DrawMode.TilemapCache, the pixel data is drawn into the tilemap's cache instead of directly on the display when using DrawMode.Sprite.  |
| colorRef | int |  The color ID to use when drawing the pixel.  |
| drawMode | DrawMode |  This argument only accepts the DrawMode.TilemapCache enum.  |


---
### DrawPixels ( pixelData, x, y, width, height, drawMode, flipH, flipV, colorOffset )
#### Summary
 This method allows you to draw raw pixel data directly to the display. Depending on which draw mode you use, the pixel data could be rendered as a sprite or drawn directly onto the tilemap cache. Sprites drawn with this method still count against the total number the display can render but you can draw irregularly shaped sprites by defining a custom width and height. For drawnig into the tilemap cache directly, you can use this to change the way the tilemap looks at run-time without having to modify a sprite's pixel data. It is important to note that when you change a tile's sprite ID or color offset, the tilemap redraws it back to the cache overwriting any pixel data that was previously there. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| pixelData | int[] |  The pixelData argument accepts an int array representing references to color IDs. The pixelData array length needs to be the same size as the supplied width and height, or it will throw an error.  |
| x | int |  The x position where to display the new pixel data. The display's horizontal 0 position is on the far left-hand side. When using DrawMode.TilemapCache, the pixel data is drawn into the tilemap's cache instead of directly on the display when using DrawMode.Sprite.  |
| y | int |  The Y position where to display the new pixel data. The display's vertical 0 position is on the top. When using DrawMode.TilemapCache, the pixel data is drawn into the tilemap's cache instead of directly on the display when using DrawMode.Sprite.  |
| width | int |  The width of the pixel data to use when rendering to the display.  |
| height | int |  The height of the pixel data to use when rendering to the display.  |
| drawMode | DrawMode |  This argument accepts the DrawMode enum. You can use Sprite, SpriteBelow, and TilemapCache to change where the pixel data is drawn to. By default, this value is DrawMode.Sprite.  |
| flipH | bool |  This is an optional argument which accepts a bool. The default value is set to false but passing in true flips the pixel data horizontally.  |
| flipV | bool |  This is an optional argument which accepts a bool. The default value is set to false but passing in true flips the pixel data vertically.  |
| colorOffset | int |  This optional argument accepts an int that offsets all the color IDs in the pixel data array. This value is added to each int, in the pixel data array, allowing you to simulate palette shifting.  |


---
### DrawRect ( x, y, width, height, color, drawMode )
#### Summary
 This method allows you to draw a rectangle with a fill color. By default, this method is used to clear the screen but you can supply a color offset to change the color value and use it to fill a rectangle area with a specific color instead. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| x | int |  |
| y | int |  |
| width | int |  |
| height | int |  |
| color | int |  |
| drawMode | DrawMode |  |


---
### DrawSprite ( id, x, y, flipH, flipV, drawMode, colorOffset )
#### Summary
 Sprites represent individual collections of pixel data at a fixed size. By default, Pixel Vision 8 sprites are 8 x 8 pixels and have a set limit of visible colors. You can use the DrawSprite() method to render any sprite stored in the Sprite Chip. The display also has a limitation on how many sprites can be on the screen at one time. Each time you call DrawSprite(), the sprite counts against the total amount the display can render. If you attempt to draw more sprites than the display can handle, the call is ignored. One thing to keep in mind when drawing sprites is that their x and y position wraps if they reach the right or bottom border of the screen. You need to change the overscan border to hide sprites offscreen. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| id | int |  The unique ID of the sprite to use in the SpriteChip.  |
| x | int |  An int value representing the X position to place sprite on the display. If set to 0, it renders on the far left-hand side of the screen.  |
| y | int |  An int value representing the Y position to place sprite on the display. If set to 0, it renders on the top of the screen.  |
| flipH | bool |  This is an optional argument which accepts a bool. The default value is set to false but passing in true flips the pixel data horizontally.  |
| flipV | bool |  This is an optional argument which accepts a bool. The default value is set to false but passing in true flips the pixel data vertically.  |
| drawMode | DrawMode |  |
| colorOffset | int |  This optional argument accepts an int that offsets all the color IDs in the pixel data array. This value is added to each int, in the pixel data array, allowing you to simulate palette shifting.  |


---
### DrawSpriteBlock ( id, x, y, width, height, flipH, flipV, drawMode, colorOffset, onScreen, useScrollPos )
#### Summary
 DrawSpriteBlock() is similar to DrawSprites except you define the first sprite (upper left corner) and the width x height (in sprites) to sample from sprite ram. This will create a larger sprite by using neighbor sprites. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| id | int | The top left sprite to start with.  |
| x | int |  An int value representing the X position to place sprite on the display. If set to 0, it renders on the far left-hand side of the screen.  |
| y | int |  An int value representing the Y position to place sprite on the display. If set to 0, it renders on the top of the screen.  |
| width | int |  The width, in sprites, of the grid. A value of 2 renders 2 sprites wide. The DrawSprites method continues to run through all of the sprites in the ID array until reaching the end. Sprite groups do not have to be perfect squares since the width value is only used to wrap sprites to the next row.  |
| height | int |  |
| flipH | bool |  This is an optional argument which accepts a bool. The default value is set to false but passing in true flips the pixel data horizontally.  |
| flipV | bool |  This is an optional argument which accepts a bool. The default value is set to false but passing in true flips the pixel data vertically.  |
| drawMode | DrawMode |  |
| colorOffset | int |  This optional argument accepts an int that offsets all the color IDs in the pixel data array. This value is added to each int, in the pixel data array, allowing you to simulate palette shifting.  |
| onScreen | bool |  This flag defines if the sprites should not render when they are off the screen. Use this in conjunction with overscan border control what happens to sprites at the edge of the display. If this value is false, the sprites wrap around the screen when they reach the edges of the screen.  |
| useScrollPos | bool | This will automatically offset the sprite's x and y position based on the scroll value. |


---
### DrawSprites ( ids, x, y, width, flipH, flipV, drawMode, colorOffset, onScreen, useScrollPos, bounds )
#### Summary
 The DrawSprites method makes it easier to combine and draw groups of sprites to the display in a grid. This is useful when trying to render 4 sprites together as a larger 16x16 pixel graphic. While there is no limit on the size of the sprite group which can be rendered, it is important to note that each sprite in the array still counts as an individual sprite. Sprites passed into the DrawSprites() method are visible if the display can render it. Under the hood, this method uses DrawSprite but solely manages positioning the sprites out in a grid. Another unique feature of his helper method is that it automatically hides sprites that go offscreen. When used with overscan border, it greatly simplifies drawing larger sprites to the display. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| ids | int[] |  An array of sprite IDs to display on the screen.  |
| x | int |  An int value representing the X position to place sprite on the display. If set to 0, it renders on the far left-hand side of the screen.  |
| y | int |  An int value representing the Y position to place sprite on the display. If set to 0, it renders on the top of the screen.  |
| width | int |  The width, in sprites, of the grid. A value of 2 renders 2 sprites wide. The DrawSprites method continues to run through all of the sprites in the ID array until reaching the end. Sprite groups do not have to be perfect squares since the width value is only used to wrap sprites to the next row.  |
| flipH | bool |  This is an optional argument which accepts a bool. The default value is set to false but passing in true flips the pixel data horizontally.  |
| flipV | bool |  This is an optional argument which accepts a bool. The default value is set to false but passing in true flips the pixel data vertically.  |
| drawMode | DrawMode |  |
| colorOffset | int |  This optional argument accepts an int that offsets all the color IDs in the pixel data array. This value is added to each int, in the pixel data array, allowing you to simulate palette shifting.  |
| onScreen | bool |  This flag defines if the sprites should not render when they are off the screen. Use this in conjunction with overscan border control what happens to sprites at the edge of the display. If this value is false, the sprites wrap around the screen when they reach the edges of the screen.  |
| useScrollPos | bool | This will automatically offset the sprite's x and y position based on the scroll value. |
| bounds | Rect |  |


---
### DrawText ( text, x, y, drawMode, font, colorOffset, spacing )
#### Summary
 The DrawText() method allows you to render text to the display. By supplying a custom DrawMode, you can render characters as individual sprites (DrawMode.Sprite), tiles (DrawMode.Tile) or drawn directly into the tilemap cache (DrawMode.TilemapCache). When drawing text as sprites, you have more flexibility over position, but each character counts against the displays' maximum sprite count. When rendering text to the tilemap, more characters are shown and also increase performance when rendering large amounts of text. You can also define the color offset, letter spacing which only works for sprite and tilemap cache rendering, and a width in characters if you want the text to wrap. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| text | string |  A text string to display on the screen.  |
| x | int |  An int value representing the X position to start the text on the display. If set to 0, it renders on the far left-hand side of the screen.  |
| y | int |  An int value representing the Y position to place sprite on the display. If set to 0, it renders on the top of the screen.  |
| drawMode | DrawMode |  This argument accepts the DrawMode enum. You can use Sprite, SpriteBelow, and TilemapCache to change where the pixel data is drawn to. By default, this value is DrawMode.Sprite.  |
| font | string |  The name of the font to use. You do not need to add the font's file extension. If the file is called The name of the font to use. You do not need to add the font's file extension. If the file is called default.font.png, you can simply refer to it as "default" when supplying an argument value.  |
| colorOffset | int |  This optional argument accepts an int that offsets all the color IDs in the pixel data array. This value is added to each color ID in the font's pixel data, allowing you to simulate palette shifting.  |
| spacing | int |  This optional argument sets the number of pixels between each character when rendering text. This value is ignored when rendering text as tiles. This value can be positive or negative depending on your needs. By default, it is 0.  |


---
### DrawTile ( id, c, r, drawMode, colorOffset )
#### Summary
 The DrawTile method makes it easier to update the visuals of a tile on any of the map layers. By default, this will modify a single tile's sprite id and color offset. You can also define the DrawMode to target a specific layer. By default, DrawMode.Tile is used, but this method also accepts DrawMode.TilemapCache and DrawMode.UI to target the UI layer above the tilemap. It's important to note that this method can only draw a tile at a specific column and row. If you need pixel perfect drawing on the TilemapCache or UI layer, use the DrawPixels method. Finally, drawing a tile into the tilemap itself will force that tile to be copied to the Tilemap Cache on the next render pass just like calling the Tile() method. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| id | int | Sprite ID to use for the tile. |
| c | int | The column in the layer. |
| r | int | The row in the layer. |
| drawMode | DrawMode | This accepts DrawMode.Tile, DrawMode.TilemapCache and DrawMode.UI. |
| colorOffset | int | This is the color offset to use for the tile. |


---
### DrawTilemap ( x, y, columns, rows, offsetX, offsetY, drawMode )
#### Summary
 By default, the tilemap renders to the display by simply calling DrawTilemap(). This automatically fills the entire display with the visible portion of the tilemap. To have more granular control over how to render the tilemap, you can supply an optional X and Y position to change where it draws on the screen. You can also modify the width (columns) and height (rows) that are displayed too. This is useful if you want to show a HUD or some other kind of image on the screen that is not overridden by the tilemap. To scroll the tilemap, you need to call the ScrollPosition() and supply a new scroll X and Y value. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| x | int |  An optional int value representing the X position to render the tilemap on the display. If set to 0, it renders on the far left-hand side of the screen.  |
| y | int |  An optional int value representing the Y position to render the tilemap on the display. If set to 0, it renders on the top of the screen.  |
| columns | int |  An optional int value representing how many horizontal tiles to include when drawing the map. By default, this is 0 which automatically uses the full visible width of the display, while taking into account the X position offset.  |
| rows | int |  An optional int value representing how many vertical tiles to include when drawing the map. By default, this is 0 which automatically uses the full visible height of the display, while taking into account the Y position offset.  |
| offsetX | int? |  An optional int value to override the scroll X position. This is useful when you need to change the left x position from where to sample the tilemap data from.  |
| offsetY | int? |  An optional int value to override the scroll Y position. This is useful when you need to change the top y position from where to sample the tilemap data from.  |
| drawMode | DrawMode |  |


---
### DrawTiles ( ids, c, r, width, drawMode, colorOffset )
#### Summary
 The DrawTiles method makes it easier to update the visuals of multiple tiles at once by leveraging the DrawTile method. Simply pass in an Array of sprite IDs, the column, row and width (in tiles) to make bulk changes to a tilemap layer. You can also define the DrawMode to target a specific layer. By default, DrawMode.Tile is used, but this method also accepts DrawMode.TilemapCache and DrawMode.UI to target the UI layer above the tilemap. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| ids | int[] | An Array of Sprite IDs. |
| c | int | The column in the layer. |
| r | int | The row in the layer. |
| width | int | The number of horizontal tiles in the group. |
| drawMode | DrawMode | This accepts DrawMode.Tile, DrawMode.TilemapCache and DrawMode.UI. |
| colorOffset | int | This is the color offset to use for the tile. |


---
### RedrawDisplay (  )
#### Summary
 You can use RedrawDisplay to make clearing and drawing the tilemap easier. This is a helper method automatically calls both Clear() and DrawTilemap() for you. 

---
### ScrollPosition ( x, y )
#### Summary
 You can scroll the tilemap by calling the ScrollPosition() method and supplying a new scroll X and Y position. By default, calling ScrollPosition() with no arguments returns a vector with the current scroll X and Y values. If you supply an X and Y value, it updates the tilemap's scroll position the next time you call the DrawTilemap() method. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| x | int? |  An optional int value representing the scroll X position of the tilemap. If set to 0, it starts on the far left-hand side of the tilemap.  |
| y | int? |  An optional int value representing the scroll Y position of the tilemap. If set to 0, it starts on the top of the tilemap.  |

#### Returns
 By default, this method returns a vector with the current scroll X and Y position. 

---

## File IO
### ReadSaveData ( key, defaultValue )
#### Summary
 Allows you to read saved data by supplying a key. If no matching key exists, "undefined" is returned. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| key | string |  The string key used to find the data.  |
| defaultValue | string |  The optional string to use if data does not exist.  |

#### Returns
 Returns string data associated with the supplied key. 

---
### WriteSaveData ( key, value )
#### Summary
 Allows you to save string data to the game file itself. This data persistent even after restarting a game. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| key | string |  A string to use as the key for the data.  |
| value | string |  A string representing the data to be saved.  |


---

## Input
### Button ( button, state, controllerID )
#### Summary
 The main form of input for Pixel Vision 8 is the controller's buttons. You can get the current state of any button by calling the Button() method and supplying a button ID, an InputState enum, and the controller ID. When called, the Button() method returns a bool for the requested button and its state. The InputState enum contains options for testing the Down and Released states of the supplied button ID. By default, Down is automatically used which returns true when the key was pressed in the current frame. When using Released, the method returns true if the key is currently up but was down in the last frame. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| button | Buttons |  Accepts the Buttons enum or int for the button's ID.  |
| state | InputState |  Optional InputState enum. Returns down state by default.  |
| controllerID | int |  An optional InputState enum. Uses InputState.Down default.  |

#### Returns
 Returns a bool based on the state of the button. 

---
### InputString (  )
#### Summary
 The InputString() method returns the keyboard input entered this frame. This method is useful for capturing keyboard text input. 

---
### Key ( key, state )
#### Summary
 While the main form of input in Pixel Vision 8 comes from the controllers, you can test for keyboard input by calling the Key() method. When called, this method returns the current state of a key. The method accepts the Keys enum, or an int, for a specific key. In additon, you need to provide the input state to check for. The InputState enum has two states, Down and Released. By default, Down is automatically used which returns true when the key is being pressed in the current frame. When using Released, the method returns true if the key is currently up but was down in the last frame. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| key | Keys |  This argument accepts the Keys enum or an int for the key's ID.  |
| state | InputState |  Optional InputState enum. Returns down state by default. This argument accepts InputState.Down (0) or InputState.Released (1).  |

#### Returns
 This method returns a bool based on the state of the button. 

---
### MouseButton ( button, state )
#### Summary
 Pixel Vision 8 supports mouse input. You can get the current state of the mouse's left (0) and right (1) buttons by calling MouseButton(). In addition to supplying a button ID, you also need to provide the InputState enum. The InputState enum contains options for testing the Down and Released states of the supplied button ID. By default, Down is automatically used which returns true when the key was pressed in the current frame. When using Released, the method returns true if the key is currently up but was down in the last frame. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| button | int |  Accepts an int for the left (0) or right (1) mouse button.  |
| state | InputState |  An optional InputState enum. Uses InputState.Down default.  |

#### Returns
 Returns a bool based on the state of the button. 

---
### MousePosition (  )
#### Summary
 The MousePosition() method returns a vector for the current cursor's X and Y position. This value is read-only. The mouse's 0,0 position is in the upper left-hand corner of the display 

---

## Sound
### PauseSong (  )
#### Summary
 Toggles the current playback state of the sequencer. If the song is playing it will pause, if it is paused it will play. 

---
### PlaySong ( loopIDs, loop )
#### Summary
 This helper method allows you to automatically load a set of loops as a complete song and plays them back. You can also define if the tracks should loop when they are done playing. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| loopIDs | int[] |  An array of loop IDs to playback as a single song.  |
| loop | bool |  A bool that determines if the song should loop back to the first ID when it is done playing.  |


---
### PlaySound ( id, channel )
#### Summary
 This method plays back a sound on a specific channel. The SoundChip has a limit of active channels so playing a sound effect while another was is playing on the same channel will cancel it out and replace with the new sound. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| id | int |  The ID of the sound in the SoundCollection.  |
| channel | int |  The channel the sound should play back on. Channel 0 is set by default.  |


---
### RewindSong ( position, loopID )
#### Summary
 Rewinds the sequencer to the beginning of the currently loaded song. You can define the position in the loop and the loop where playback should begin. Calling this method without any arguments will simply rewind the song to the beginning of the first loop. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| position | int |  Position in the loop to start playing at.  |
| loopID | int |  The loop to rewind too.  |


---
### Sound ( id, data )
#### Summary
 This method allows your read and write raw sound data on the SoundChip. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| id | int |  |
| data | string |  |


---
### StopSong (  )
#### Summary
 Stops the sequencer. 

---
### StopSound ( channel )
#### Summary
 Use StopSound() to stop any sound playing on a specific channel. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| channel | int | The channel ID to stop a sound on. |


---

## Sprite
### MaxSpriteCount ( total )
#### Summary
 This method returns the maximum number of sprites the Display Chip can render in a single frame. Use this to better understand the limitations of the hardware your game is running on. This is a read only property at runtime. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| total | int? |  |

#### Returns
Returns an int representing the total number of sprites on the screen at once.

---
### Sprite ( id, data )
#### Summary
 This allows you to return the pixel data of a sprite or overwrite it with new data. Sprite pixel data is an array of color reference ids. When calling the method with only an id argument, you will get the sprite's pixel data. If you supply data, it will overwrite the sprite. It is important to make sure that any new pixel data should be the same length of the existing sprite's pixel data. This can be calculated by multiplying the sprite's width and height. You can add the transparent area to a sprite's data by using -1. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| id | int |  The sprite to access.  |
| data | int[] |  Optional data to write over the sprite's current pixel data.  |

#### Returns
 Returns an array of int data which points to color ids. 

---
### SpriteSize ( width, height )
#### Summary
 Returns the size of the sprite as a Vector where X and Y represent the width and height. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| width | int? |  Optional argument to change the width of the sprite. Currently not enabled.  |
| height | int? |  Optional argument to change the height of the sprite. Currently not enabled.  |

#### Returns
 Returns a vector where the X and Y for the sprite's width and height. 

---
### Sprites ( ids, width )
#### Summary
 This allows you to get the pixel data of multiple sprites. This is a read only method but can be used to copy a collection of sprites into memory and draw them to the display in a single pass. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| ids | int[] |  |
| width | int |  |


---
### TotalSprites ( ignoreEmpty )
#### Summary
 Returns the total number of sprites in the system. You can pass in an optional argument to get a total number of sprites the Sprite Chip can store by passing in false for ignoreEmpty. By default, only sprites with pixel data will be included in the total return. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| ignoreEmpty | bool |  This is an optional value that defaults to true. When set to true, the SpriteChip returns the total number of sprites that are not empty (where all the pixel data is set to -1). Set this value to false if you want to get all of the available color slots in the ColorChip regardless if they are empty or not.  |

#### Returns
 This method returns the total number of sprites in the color chip based on the ignoreEmpty argument's value. 

---

## Tilemap
### Flag ( column, row, value )
#### Summary
 This allows you to quickly access just the flag value of a tile. This is useful when trying to the caluclate collision on the tilemap. By default, you can call this method and return the flag value. If you supply a new value, it will be overridden on the tile. Changing a tile's flag value does not force the tile to be redrawn to the tilemap cache. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| column | int |  The X position of the tile in the tilemap. The 0 position is on the far left of the tilemap.  |
| row | int |  The Y position of the tile in the tilemap. The 0 position is on the top of the tilemap.  |
| value | int? |  The new value for the flag. Setting the flag to -1 means no collision.  |


---
### RebuildTilemap ( columns, rows, spriteIDs, colorOffsets, flags )
#### Summary
 This forces the map to redraw its cached pixel data. Use this to clear any pixel data added after the map created the pixel data cache. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| columns | int? |  |
| rows | int? |  |
| spriteIDs | int[] |  |
| colorOffsets | int[] |  |
| flags | int[] |  |


---
### Tile ( column, row, spriteID, colorOffset, flag )
#### Summary
 This allows you to get the current sprite id, color offset and flag values associated with a given tile. You can optionally supply your own if you want to change the tile's values. Changing a tile's sprite id or color offset will for the tilemap to redraw it to the cache on the next frame. If you are drawing raw pixel data into the tilemap cache in the same position, it will be overwritten with the new tile's pixel data. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| column | int |  The X position of the tile in the tilemap. The 0 position is on the far left of the tilemap.  |
| row | int |  The Y position of the tile in the tilemap. The 0 position is on the top of the tilemap.  |
| spriteID | int? |  The sprite id to use for the tile.  |
| colorOffset | int? |  Shift the color IDs by this value.  |
| flag | int? |  An int value between -1 and 16 used for collision detection.  |

#### Returns
 Returns a dictionary containing the spriteID, colorOffset, and flag for an individual tile. 

---
### TilemapSize ( width, height )
#### Summary
 This will return a vector representing the size of the tilemap in columns (x) and rows (y). To find the size in pixels, you will need to multiply the returned vectors x and y values by the sprite size's x and y. This method also allows you to resize the tilemap by passing in an optional new width and height. Resizing the tile map is destructive, so any changes will automatically clear the tilemap's sprite ids, color offsets, and flag values. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| width | int? |  An optional parameter for the width in tiles of the map.  |
| height | int? |  An option parameter for the height in tiles of the map.  |

#### Returns
 Returns a vector of the tile maps size in tiles where x and y are the columns and rows of the tilemap. 

---
### UpdateTiles ( column, row, columns, ids, colorOffset, flag )
#### Summary
 A helper method which allows you to update several tiles at once. Simply define the start column and row position, the width of the area to update in tiles and supply a new int array of sprite IDs. You can also modify the color offset and flag value of the tiles via the optional parameters. This helper method uses calls the Tile() method to update each tile, so any changes to a tile will be automatically redrawn to the tilemap's cache. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| column | int |  Start column of the first tile to update. The 0 column is on the far left of the tilemap.  |
| row | int |  Start row of the first tile to update. The 0 row is on the top of the tilemap.  |
| columns | int |  The width of the area in tiles to update.  |
| ids | int[] |  An array of sprite IDs to use for each tile being updated.  |
| colorOffset | int? |  An optional color offset int value to be applied to each updated tile.  |
| flag | int? |  An optional flag int value to be applied to each updated tile.  |


---

# Lua Game Chip API

The following APIs are specific to the Lua Game Chip found in the Game Creator. These methods are also available in the runner but are not part of the core C# API. These are helper functions that are available globally from any Lua script to bridge missing functionality not found in the core Game Chip itself.

## Lifecycle
### Init (  )
#### Summary
 Init() is called when a game is loaded into memory and is ready to be played. Use this hook to initialize your game's logic. It is only called once. 

---

## Math
### CalculateIndex ( x, y, width )
#### Summary
 Converts an X and Y position into an index. This is useful for finding positions in 1D arrays that represent 2D data. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| x | int |  The x position.  |
| y | int |  The y position.  |
| width | int |  The width of the data if it was represented as a 2D array.  |

#### Returns
 Returns an int value representing the X and Y position in a 1D array. 

---
### CalculatePosition ( index, width )
#### Summary
 Converts an index into an X and Y position to help when working with 1D arrays that represent 2D data. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| index | int |  The position of the 1D array.  |
| width | int |  The width of the data if it was a 2D array.  |

#### Returns
 Returns a vector representing the X and Y position of an index in a 1D array. 

---
### Clamp ( val, min, max )
#### Summary
 Limits a value between a minimum and maximum. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| val | int |  The value to clamp.  |
| min | int |  The minimum the value can be.  |
| max | int |  The maximum the value can be.  |

#### Returns
 Returns an int within the min and max range. 

---
### Repeat ( val, max )
#### Summary
 Repeats a value based on the max. When the value is greater than the max, it starts over at 0 plus the remaining value. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| val | int |  The value to repeat.  |
| max | int |  The maximum the value can be.  |

#### Returns
 Returns an int that is never less than 0 or greater than the max. 

---

## Utils
### SplitLines ( str )
#### Summary
 This calls the TextUtil's SplitLines() helper to convert text with line breaks (\n) into a collection of lines. This can be used in conjunction with the WordWrap() helper to render large blocks of text line by line with the DrawText() API. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| str | string | The string of text to split. |

#### Returns
Returns an array of strings representing each line of text.

---
### WordWrap ( text, width )
#### Summary
 This allows you to call the TextUtil's WordWrap helper to wrap a string of text to a specified character width. Since the FontChip only knows how to render characters as sprites, this can be used to calculate blocks of text then each line can be rendered with a DrawText() call. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| text | string | The string of text to wrap. |
| width | int | The width of characters to wrap each line of text. |


---

## Scripts
### AddScript ( name, script )
#### Summary
 This allows you to add your Lua scripts at runtime to a game from a string. This could be useful for dynamically generating code such as level data or other custom Lua objects in memory. Simply give the script a name and pass in a string with valid Lua code. If a script with the same name exists, this will override it. Make sure to call LoadScript() after to parse it. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| name | string | Name of the script. This should contain the .lua extension. |
| script | string | The string text representing the Lua script data. |


---
### LoadScript ( name )
#### Summary
 This allows you to load a script into memory. External scripts can be located in the System/Libs/, Workspace/Libs/ or Workspace/Sandbox/ directory. All scripts, including built-in ones from the Game Creator, are accessible via their file name (with or without the extension). You can keep additional scripts in your game folder and load them up. Call this method before Init() in your game's Lua file to have access to any external code loaded by the Game Creator or Runner. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| name | string |  Name of the Lua file. You can drop the .lua extension since only Lua files will be accessible to this method.  |


---

## Sound
### PlayRawSound ( data, channel, frequency )
#### Summary
 This helper method allows you to pass raw SFXR string data to the sound chip for playback. It works just like the normal PlaySound() API but accepts a string instead of a sound ID. Calling PlayRawSound() could be expensive since the sound effect data is not cached by the engine. It is mostly used for sound effects in tools and shouldn't be called when playing a game. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| data | string | Raw string data representing SFXR sound properties in a comma-separated list. |
| channel | int |  The channel the sound should play back on. Channel 0 is set by default.  |
| frequency | float |  An optional float argument to change the frequency of the raw sound. The default setting is 0.1266.  |


---

## Geometry
### NewRect ( x, y, w, h )
#### Summary
 A Rect is a Pixel Vision 8 primitive used for defining the bounds of an object on the display. It contains an x, y, width and height property. The Rect class also has some additional methods to aid with collision detection such as Intersect(rect, rect), IntersectsWidth(rect) and Contains(x,y). 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| x | int | The x position of the rect as an int. |
| y | int | The y position of the rect as an int. |
| w | int | The width value of the rect as an int. |
| h | int | The height value of the rect as an int. |

#### Returns
Returns a new instance of a Rect to be used as a Lua object.

---
### NewVector ( x, y )
#### Summary
 A Vector is a Pixel Vision 8 primitive used for defining a position on the display as an x,y value. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| x | int | The x position of the Vector as an int. |
| y | int | The y position of the Vector as an int. |

#### Returns
Returns a new instance of a Vector to be used as a Lua object.

---

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


# Game Creator API

The following APIs are exposed directly through the Game Creator’s Runner.  These methods allow you to access loading and quitting games, managing files in the workspace, and even making changes to the system volume and resolution. These APIs are used by the Game Creator’s built-in tools. These APIs are not part of the core engine so they will only work when called inside of the Game Creator itself.

## Debugging
### DebugLayers ( value )
#### Summary
 This allows you to toggle hotkeys to enable/disable rendering layers with the 1-6 and 0 key.  Pass in true to make the number keys active but note this will make text input not work for number keys. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| value | bool | Supply true to active layer debugging hotkeys or false to disable them. |


---
### ReadFPS (  )
#### Summary
 This returns the averaged FPS that is calculated by the Game Creator on each frame. This is not always accurate and should only be used as the best guest estimate into the real framerate of your game. 

---
### ReadSessionID (  )
#### Summary
 Reads the current session ID which is a time stamp of when the Game Creator was booted up. This can be used to help identify the state a tool should return too based on if it was last used in the same session. 

---
### ReadTotalSprites (  )
#### Summary
 Returns the total number of sprites on the display in the current frame. Call this at the end of the Draw() method to get an accurate count of sprite draw calls. 

---
### SystemName (  )
#### Summary
 Returns the system name such as Game Creator Free or Game Creator Pro. This is useful to see which version of the Game Creator the user has and limiting functionality based on what APIs are available. 

---
### SystemVersion (  )
#### Summary
 Returns the Game Creator's system version. Useful for limiting functionality based on specific Game Creator version APIs. 

---

## Workspace
### DefaultWorkspaceSystemPath (  )
#### Summary
 This is a read-only value of where the default workspace path should be on the user's system. It is designed to allow the Game Creator to revert to a safe location to rebuild or reload the workspace if a custom path fails to work. Also, this location allows you to store files in a place that is marked "safe" by the file system and belongs exclusively to the Game Creator for storing additional files on the file system. 

---
### EmptyTrash (  )
#### Summary
 Empties the workspace's trash folder. All files in the trash will be perminently deleted. 

---
### WorkspaceSystemPath ( newPath )
#### Summary
 This will return the current path on the user's computer where their workspace folder is stored. This is used internally to verify the workspace folder exists and is accessible when booting up the Game Creator. If you supply a path as an argument, it will change the path assuming it is valid on the user's system. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| newPath | string | This is an optional argument to set a new workspace path on the user's system. |

#### Returns
Returns the user's system path to their active workspace folder.

---

## Game Creator
### ArchiveGame ( fileName, safeDelete )
#### Summary
 This method allows you to archive the current game in the Workspace/Sandbox/ directory and create a PV8 archive which is then copied to the Workspace/Games directory. Just supply a file name for the new archive and an option bool to safely delete any existing archive in the Workspace/Games/ directory by moving it to the trash. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| fileName | string | The string filename with the extension for the archive. |
| safeDelete | bool |  An option bool that will move a previous archive to the trash if one exists with the same filename.  |


---
### DeleteGame ( path, safeDelete )
#### Summary
 This will move the contents of the supplied workspace path into the trash. You can pass in false to just delete it immediately which is useful for temporary copies of games that are not being worked on directly. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| path | string | A valid system path to a PV8 game or game folder. |
| safeDelete | bool |  This optional bool will safely delete the contents of the Workspace/Sandbox/ directory by zipping it up and moving it to the Workspace/Trash.  |

#### Returns
Returns true if the operation was successful.

---
### EditGame ( path, safeDelete )
#### Summary
 This method accepts a path to a game and will copy it into the Workspace/Sandbox/ directory, replacing the current contents, with a copy of the source. This is used in the GameCreator to open a game to be worked on with the built-in tools. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| path | string | A valid system path to a PV8 game or game folder. |
| safeDelete | bool |  This optional bool will safely delete the contents of the Workspace/Sandbox/ directory by zipping it up and moving it to the Workspace/Trash.  |

#### Returns
Returns true if the operation was successful.

---
### EditorExits ( editorName )
#### Summary
 Tests to see if a built-in editor exists by its name. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| editorName | string | A string name for one of the built-in tools which are defined in the bios. |

#### Returns
Returns true if the tool is found.

---
### Fullscreen ( newValue )
#### Summary
 Toggles the Game Creator's full-screen mode. This will scale the Game Creator to take over the entire screen based on the operating system's full-screen mode support. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| newValue | bool? | An optional bool to active or deactivate the full-screen mode. |

#### Returns
Returns a bool representing the full-screen state. True is active and false is windowed mode.

---
### LoadGame ( path, metaData )
#### Summary
 This loads a game from a workspace path. Workspace paths start with either System/ or Workspace/. This will accept a path to a directory or a PV8 zip file (.pv8 or .pvt). You can also pass in metadata to retain state of values between game instances. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| path | string | A valid workspace path to load a game from. |
| metaData | Dictionary<string, string> |  A table with a string key and string values which will be passed into the game that is being loaded.  |

#### Returns
Will return false if the game was not loaded.

---
### LoadTool ( path, metaData )
#### Summary
 This loads a game as a tool which enables returning to it when exiting playing a game. When a tool is loaded by the Game Creator, it is added to the load history allowing you to easily switch between the last tool loaded and an active game. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| path | string | The workspace path to where the tool is located. |
| metaData | Dictionary<string, string> | Optional metadata to pass into the tool. This should be set up in string key, value pairs. |

#### Returns
Returns true if the tool can load or false if there was an issue.

---
### NewGame ( path, fileName, ext )
#### Summary
 This method allows you to create a new game from an existing PV8 archive or game. Supply a path to the source project to copy, a new filename and extension. If the path is valid, the project is copied to the Workspace/Sandbox/ directory. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| path | string | A valid path as a string to a game inside of the workspace. |
| fileName | string | An optional string filename without an extension. |
| ext | string | An optional string for the file extension such as ".pv8" or ".pvt". |


---
### OpenEditor ( editorName, metaData )
#### Summary
 Attempts to open a built-in editor based on the supplied editorName value. You can also pass in optional metadata to the tool when it loads. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| editorName | string | A string name for one of the built-in tools which are defined in the bios. |
| metaData | Dictionary<string, string> | An optional table with string key, value pairs to be used as metadata for the tool being loaded. |

#### Returns
Returns false if the tool is unable to be found or loaded.

---
### PlayGame (  )
#### Summary
 Switches the Game Creator over into Play mode which loads the contents of the Workspace/Sandbox/ directory into memory. 

---
### QuitCurrentTool ( metaData, tool )
#### Summary
 This quits the current tool and returns to the default tool which should be the workspace explorer. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| metaData | Dictionary<string, string> | An optional argument to supply additional metadata back to the tool that is loaded when quitting. |
| tool | string | An optional argument that allows you to supply a string name for a built-in tool to load instead of the default workspace explorer. |


---
### ReadMetaData ( key, defaultValue )
#### Summary
 Reads a metadata property from the active game engine. It requires a string for the key and returns a string value. You can also supply an optional default value. When a game is loaded, it can be passed metadata to help retain state between loading, and this allows you to read that data. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| key | string | A string for the metadata property's key. |
| defaultValue | string |  |

#### Returns
If no key is found, this will return the default data, so it does not return nil.

---
### ResetGame ( showBoot )
#### Summary
 Resets the currently running game. This is good for restarting a game without having to reload all of the contents. Will call the game's Restart() hook. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| showBoot | bool | Optional value to force a boot animation. |


---
### Scale ( value )
#### Summary
 Changes the scale of the Game Creator window. The default resolution of the Game Creator is 256 x 240. You can increase this value by supplying an optional int value which will be multiplied by the default resolution. The scale is capped at 6. Any changes to the scale are written back to the bios file. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| value | int? | An optional value ( 1 - 6) to multiply against the default resolution. |

#### Returns
Returns the current scale value.

---

## Filesystem
### Clipboard ( newValue )
#### Summary
 Provides access to the computer's clipboard for copying data out of the GameCreator. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| newValue | string | Optional string value to go into the clipboard. |

#### Returns
Returns the current contents of the computer's clipboard.

---
### CopyGameToTemp ( srcPath, destPath )
#### Summary
 This copies a PV8 archive or directory over to the Workspace/Tmp Directory. This is useful for looking at the contents of a game without having to load it into the Workspace/Sandbox directory which may be occupied by a game. It's important to note that this will only copy over valid game files such as data.json and any .png or .lua file. Anything else in the directory will be ignored. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| srcPath | string | The source game's path as a string inside of the workspace. |
| destPath | string | A destination path as a string inside of the workspace. |


---
### DeleteCurrentGame ( safeDelete )
#### Summary
 This method deletes the current game located in the Workspace/Sandbox/ directory. By default, the project will be archived and moved into the trash. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| safeDelete | bool |  An optional bool that determines if the project should be moved to the trash if true or permanently delete if false.  |


---
### DirectoryExits ( path )
#### Summary
 Checks to see if a workspace directory exists. Useful before moving a file or creating a new directory with a similar name. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| path | string | String workspace path to the directory. |

#### Returns
Returns true if the directory exists.

---
### GameNameFromPath ( path )
#### Summary
 This simply returns the name of a game from a path. If the game path is a folder, it will read the info.json file. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| path | string | A valid path as a string to a game inside of the workspace. |

#### Returns
Returns the name as a string.

---
### GetFileSize ( path )
#### Summary
 This returns a numeric value for the file size of a file in a valid workspace path. The value is based on bytes. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| path | string | A valid workspace path. |

#### Returns
Returns a long value in bytes.

---
### GetFileSizeAsString ( path )
#### Summary
 This leverages GetFileSize but converts the size into a string. It attempts to round the size up to the nearest size, bytes, kilobytes, megs, etc. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| path | string | A valid workspace path. |

#### Returns
Returns a string value.

---
### ImportFiles ( sourceDir, files )
#### Summary
 This method helps copy files over to the Workspace/Sandbox/ directory. It is useful for importing the contents of another game into the one the user is currently editing. The list of paths should be valid workspace paths for them to be copied over. Returns false if there is an error during the import process. It is important to note that when a file is imported, the original one is deleted from its source. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| sourceDir | string | The source path as a string. |
| files | string[] | An array of files to import from the source path. |

#### Returns
Returns false if there is an error performing the import.

---
### MoveFile ( src, dest )
#### Summary
 Moves a file from one location to another location inside of the workspace. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| src | string | A valid string workspace path for the source file to move. |
| dest | string | A valid string workspace path for the destination including the full filename. |

#### Returns
Returns true if the move was successful.

---
### ReadGameMetaData ( path )
#### Summary
 Returns the meta data from a game folder. This containes the name, ext, version and description. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| path | string | A valid workspace path to the PV8 archive or game directory. |

#### Returns
Returns a table with the metadata from the pv8 project.

---
### ReadSystemData ( path )
#### Summary
 This reads the system data from a path and returns an array with values for each of the chip settings. The array is organized in the following order: Display Width, Display Height, supported colors, colors per sprite, sprites per page, max sprite count, tilemap columns, tilemap rows, total sound channels, total sounds, total tracks and total loops. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| path | string | A string workspace path to a PV8 project folder. |

#### Returns
Returns an array of chip setting values.

---
### ReadTextFile ( path )
#### Summary
 This will read a text file from a valid workspace path and return it as a string. This can read .txt, .json and .lua files. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| path | string | A valid workspace path. |

#### Returns
Returns the contents of the file as a string.

---
### SaveTextToFile ( path, text )
#### Summary
 This allows you to save a text file back to the workspace directory. Simply provide a full path, including the file name, and it will attempt to save the file. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| path | string | A valid workspace path. |
| text | string | The string text to save into the file. |


---
### ValidateGameInDir ( path )
#### Summary
 Tests to see if a directory has the files needed to be run as a game. This includes an info.json and data.json file. If no path is supplied, it will automatically look in the Workspace/Sandbox/ directory. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| path | string | An optional workspace path to validate a game in a directory. This can only be used on directories, not game archives. |

#### Returns
Returns a bool if the directory contains the necessary files to be considered a PV8 game.

---

## Volume
### Mute ( value )
#### Summary
 This toggles the mute value of the Game Creator. Setting it to true will disable sounds and false will restore sounds to the last volume value. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| value | bool? | An optional bool to enable or disable mute. |

#### Returns
Returns a bool whether mute is activated.

---
### Volume ( value )
#### Summary
 This allows you to change the volume for the Game Creator. You can get the current volume or pass in an option int between 0 and 100 to change it. Any changes to the volume are written to the bios. 
#### Arguments
| Name | Value | Description |
| ---- | ---- | ----------- |
| value | int? | An optional int value between 0 - 100 to change the Game Creator's volume. |

#### Returns
Returns the current int value of the Game Creator's volume.

---

