# Inside a Game Project

A game is simply a collection of files that PV8 loads into its memory. Each of these files has a specific purpose in the project. Here are the supported files that can go inside of a zipped up game:

<table>
  <tr>
    <td>Name</td>
    <td>Ext.</td>
    <td>Description</td>
  </tr>
  <tr>
    <td>code</td>
    <td>.lua</td>
    <td>This Lua file, which contains all the code to run the game.</td>
  </tr>
  <tr>
    <td>color-map</td>
    <td>.png</td>
    <td>The color map represents a file that can be used to match up colors in the sprite.png to the order in the colors.png.</td>
  </tr>
  <tr>
    <td>colors</td>
    <td>.png</td>
    <td>The colors image contains all the system colors used for rendering. These colors should be 1x1 pixel for each color.</td>
  </tr>
  <tr>
    <td>data</td>
    <td>.json</td>
    <td>The data file represents chips and their settings that make up the fantasy console the game should run on.</td>
  </tr>
  <tr>
    <td>font</td>
    <td>.png</td>
    <td>This is a default font to be used at run-time. It works similar to the sprite.png, except the order is based on ASCII code. It starts at 32 (spaces) and supports any number of characters you add.</td>
  </tr>
  <tr>
    <td>info</td>
    <td>.json</td>
    <td>This is a metadata file that describes the contents of the game’s zip project. It is used to simplify editing things like the game’s name without having to dig through the data file.</td>
  </tr>
  <tr>
    <td>sprites</td>
    <td>.png</td>
    <td>This .png contains all of the sprites the game uses. It is automatically loaded and cut up into 8x8 sprites based on the order of images in the file. </td>
  </tr>
  <tr>
    <td>tilemap</td>
    <td>.png</td>
    <td>This represents a map to be used in the game. It’s cut up in a similar way to the sprites.png, except each sprite in the tile map is compared to the sprites in the memory. If found, the ID is stored internally. If the sprite doesn’t exist, it’s added to the sprites in the RAM, assuming there is enough memory space.</td>
  </tr>
  <tr>
    <td>tilemap-flags</td>
    <td>.png</td>
    <td>This .png represents collision data in the tile map. It uses a grayscale color system to identify what ID the flag represents. By default, it supports 16 colors or flags.  </td>
  </tr>
</table>


Pv8 will ignore any additional files in a project. In order for a game to load correctly,  you need at least the following files:

1. data.json

2. code.lua

3. info.json

All the other files are optional. Files like sprites and tilemap are automatically generated when saving a project; they will simply be empty .pngs.

