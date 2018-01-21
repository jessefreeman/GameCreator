# Code Migration Guide

From time to time, the underlying Pixel Vision API may change. This page documents those changes based on the version of the SDK. While we try not to introduce changes that break existing games or throw errors intentionally, it is best to check this page after a new release to understand how to migrate your code to a new version of the Game Creator.

## Game Creator v0.7.6a API Changes 

Pixel Vision Game Creator leverages version v1.7.6 of the open source Pixel Vision SDK. Here is a quick list of code APIs that have changed and require updating  in your game:

* `DrawSprite` now requires a DrawMode (DrawMode.Sprite/DrawMode.SpriteAbove or DrawMode.SpriteBelow) instead of a bool for defining to render above or below the tilemap layer.

* `DrawSprites` also requires DrawMode instead of a bool to render the sprites above or below the tilemap.

## Game Creator v0.7.0a API Changes 

Pixel Vision Game Creator leverages version v1.4 of the open source Pixel Vision SDK. Here is a quick list of code APIs that have changed and require updating  in your game:

* `ScreenBufferChip `is no longer part of the SDK. Remove any references to it in your code.

* `RebuildScreenBuffer()` has been deprecated and is no longer a valid API. Calling it will not throw an error but it does nothing.

* `ToggleDisplayWrap()` has been deprecated and is now set to true automatically. If you are looking to have sprites offscreen, set the overscan property on the `DisplayChip`.

The biggest change in v0.7.0a is that you no longer have to use the API Bridge to call core engine APIs. All new APIs are global, so they can be accessed anywhere in a game’s lua code. For example:

`apiBridge:DrawSprite(0, 10, 10)`

Is now

`DrawSprite(0, 10, 10)`

For a full list of all the API changes, refer to the following chart:

<table>
  <tr>
    <td>Old API Bridge</td>
    <td>New Global API</td>
    <td>Notes</td>
  </tr>
  <tr>
    <td>inputString</td>
    <td>InputString()</td>
    <td></td>
  </tr>
  <tr>
    <td>GetKey()
GetKeyDown()
GetKeyUp()</td>
    <td>Key()</td>
    <td>Use new Key Method. Accepts InputState enum for Down and Released (up) values</td>
  </tr>
  <tr>
    <td>mousePosition
mouseX
mouseY</td>
    <td>MousePosition()</td>
    <td>Returns x and y values for the mouse position</td>
  </tr>
  <tr>
    <td>GetMouseButton()
GetMouseButtonDown()
GetMouseButtonUp()</td>
    <td>MouseButton()</td>
    <td>Use new MouseButton Method. Accepts InputState enum for Down and Released (up) values</td>
  </tr>
  <tr>
    <td>paused</td>
    <td>n/a</td>
    <td>This has been removed from the engine.</td>
  </tr>
  <tr>
    <td>spriteWidth
spriteHeight</td>
    <td>SpriteSize()</td>
    <td>This returns a x (width) and y (height) value for the sprite size.</td>
  </tr>
  <tr>
    <td>displayWidth
displayHeight</td>
    <td>DisplaySize()</td>
    <td>This returns a x (width) and y (height) value for the display size.</td>
  </tr>
  <tr>
    <td>displayWrap</td>
    <td>n/a</td>
    <td>The engine now auto wraps pixel data. To hide sprites off screen, use OverscanBorder()</td>
  </tr>
  <tr>
    <td>scrollX
scrollY
ScrollTo()</td>
    <td>ScrollPosition()</td>
    <td>You can now get the x & y value of the scroll position by calling the method. Supply an x and y argument to update the position.</td>
  </tr>
  <tr>
    <td>DrawSprite()</td>
    <td>DrawSprite()</td>
    <td>Works the same as the old api.</td>
  </tr>
  <tr>
    <td>DrawSprites()</td>
    <td>DrawSprites()</td>
    <td>Works the same as the old API except for a new optional property to hide sprites when they go offscreen.</td>
  </tr>
  <tr>
    <td>UpdateTile()</td>
    <td>Tile()</td>
    <td>This method allows you to read a tile's properties (spriteID, colorOffset, flag) as well as update them.</td>
  </tr>
  <tr>
    <td>DrawFont()
DrawFontToBuffer()
DrawTextBox()
DrawTextBoxToBuffer()</td>
    <td>DrawText()</td>
    <td>The new DrawText method accepts a draw mode enum which defines how the text will be draw to the display. You can also wrap any DrawText call with the optional argument.</td>
  </tr>
  <tr>
    <td>DrawTileToBuffer()
DrawTilesToBuffer</td>
    <td>n/a</td>
    <td>This has been removed. The legacy API now uses DrawPixels() with a draw mode of TilemapCache.</td>
  </tr>
  <tr>
    <td>ReadFlagAt()</td>
    <td>Flag()</td>
    <td></td>
  </tr>
  <tr>
    <td>DrawPixelData()
DrawBufferData()</td>
    <td>DrawPixels()</td>
    <td>All raw pixel draw calls are now routed through DrawPixels(). You can use the DrawMode enum to define where the pixels are drawn to.</td>
  </tr>
  <tr>
    <td>Clear()</td>
    <td>Clear()</td>
    <td>The new clear method allows you to define the x, y, width and height of the clear area. Calling it without any arguments will simply clear the entire display similar to how the old API worked.</td>
  </tr>
  <tr>
    <td>ChangeBackgroundColor()
backgroundColor</td>
    <td>BackgroundColor()</td>
    <td>You can now get the current background color by calling the method without any arguments or change it by supplying a color id.</td>
  </tr>
  <tr>
    <td>DrawScreenBuffer()</td>
    <td>RedrawDisplay()</td>
    <td>The new RedrawDisplay method will automatically call Clear and DrawTilemap in one call.</td>
  </tr>
  <tr>
    <td>RebuildScreenBuffer()</td>
    <td>RebuildTilemap()</td>
    <td>Calling RebuildTilemap() with no arguments will clear the tilemap cache, including any pixel data you've drawn to it, and rebuild the map based on the existing tiles.</td>
  </tr>
  <tr>
    <td>PlaySound()</td>
    <td>PlaySound()</td>
    <td>Works the same as the old API.</td>
  </tr>
  <tr>
    <td>ButtonDown()
ButtonReleased()</td>
    <td>Button()</td>
    <td>Uses the new Buttons enum or accepts the old button IDs. Use InputeState enum for Down or Released (up).</td>
  </tr>
  <tr>
    <td>SpritesToRawData()</td>
    <td>n/a</td>
    <td>This has been removed. Use the Sprite() method to get the raw sprite data based on a sprite ID argument.</td>
  </tr>
  <tr>
    <td>TogglePause()</td>
    <td>n/a</td>
    <td>This has been removed.</td>
  </tr>
  <tr>
    <td>ToggleDisplayWrap()</td>
    <td>n/a</td>
    <td>This has been removed.</td>
  </tr>
  <tr>
    <td>SaveData()</td>
    <td>WriteSaveData()</td>
    <td></td>
  </tr>
  <tr>
    <td>ReadData()</td>
    <td>ReadSaveData()</td>
    <td></td>
  </tr>
  <tr>
    <td>LoadSong()
PlaySong()</td>
    <td>PlaySong()</td>
    <td>These two methods have been combined into a single call. Simply pass in the song id and loop value. Play song now accepts an array of loop IDs to build out a playlist.</td>
  </tr>
  <tr>
    <td>PauseSong()</td>
    <td>PauseSong()</td>
    <td>Works the same as the old API.</td>
  </tr>
  <tr>
    <td>StopSong()</td>
    <td>StopSong()</td>
    <td>Works the same as the old API.</td>
  </tr>
  <tr>
    <td>RewindSong()</td>
    <td>RewindSong()</td>
    <td>Calling this with no arguments acts the same as the old method. You can supply an option position and loop ID to rewind to a specific point in a song's loop.</td>
  </tr>
  <tr>
    <td>ReplaceColorID()
ReplaceColorIDs</td>
    <td>n/a</td>
    <td>This has been removed, use color offset to change a sprite's color or update the colors the sprite uses via the Color or SwapColor APIs.</td>
  </tr>
  <tr>
    <td>FormatWordWrap()</td>
    <td>n/a</td>
    <td>This has been removed.</td>
  </tr>
</table>


You can view a full list of all the APIs [here](https://pixelvision8.gitbooks.io/game-creator-instruction-manual/content/Scripting/LuaAPI.html).

