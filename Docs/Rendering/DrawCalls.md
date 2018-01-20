# Draw Calls

Pixel Vision 8’s renderer takes pixel data and converts it into draw calls. These calls are sorted based on their priority and are stored until the display is ready to be drawn to. While the process of how this works isn’t important, it’s helpful to understand the types of draw calls, how they are sorted and the arguments you can use to configure them. At the rendering pipeline’s core, there is a single process which accepts raw pixel data and copies it to the display. This is part of the DisplayChip and is called NewDrawCall().

Pixel Vision 8 abstracts the Display’s NewDrawCall() method and provides several helper APIs which make pushing pixel data into the display easier. When you call DrawSprite(), DrawText() and DrawTile() these methods leverage a single GameChip API called DrawPixels(). The DrawPixels() API is the bridge between the GameChip and the DisplayChip. You can always call DrawPixels() directly and pass in an array of color IDs to have it show up on display but, the helper APIs are there to make this process easier. Also pushing raw pixel data to the display by hand is expensive. Pixel Vision 8 does many data caching under the hood to optimize rendering sprites and tiles.

When you use the Drawing APIs, you will need to set the layer. This layer is used to sort the priority of the draw call when rendering. Calls with lower values are drawn first, and higher levels are drawn over previous requests. Depending on how you configured the system, you may have fewer layers to work with. Here are the layers which are defined in the DrawMode enum.

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


When you look through the GameChip APIs, you’ll see methods that have an optional DrawMode argument. You can use this enum to explicitly state where the pixel data should be renderer on display.

