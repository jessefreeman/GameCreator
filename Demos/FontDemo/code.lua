--
-- Copyright (c) 2017, Jesse Freeman. All rights reserved.
--
-- Licensed under the Microsoft Public License (MS-PL) License.
-- See LICENSE file in the project root for full license information.
--
-- Contributors
-- --------------------------------------------------------
-- This is the official list of Pixel Vision 8 contributors:
--
-- Jesse Freeman - @JesseFreeman
-- Christer Kaitila - @McFunkypants
-- Pedro Medeiros - @saint11
-- Shawn Rakowski - @shwany
--

-- The Font Demo illustrates how to render text to the DisplayChip.You'll learn how to display fronts as sprites
-- and how to also write font data into the ScreenBufferChip optimize draw calls.

-- This string represents the default characters fonts can display. Font sprites map to the ASCII
-- values of each character starting with an empty space at 32.
local characters = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
local longText = "This is a test to see how long we can make text in a text box? Blahblahblahblahblahablahblahblah";

local wrapWidth = 12

local White, Black, Blue, Orange, Grey = 51, 32, 52, 53, 19

-- We'll use this field to keep track of the current time that has elapsed since the game has started.
local time = 0
local counter = 0
local delay = 2
local colorOffset = 0

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw some text to the display.
function Init()

	-- Before we start, we need to set a background color.
	BackgroundColor(32)

	-- Pixel Vision 8 limits the number of sprites it can render to the display on each frame. This value is
	-- set to 64 by default. Since each font character is a single sprite it would be too expensive to draw
	-- significant amounts of text at once. To get around this limitation, we are going to render the font
	-- characters into the ScreenBufferChip which manages the background layer.

	DrawText("Font API Demo", 1, 1, DrawMode.Tile, "large-font", Blue)


	-- This will display the title for the first demo. When calling DrawFontToBuffer you'll need to pass in
	-- the text to render, an X and Y position as well as the font name and finally the letter spacing.
	--DrawText("Font Template (Large/Small)", 1, 3, DrawMode.Tile, "large-font", Blue)

	DrawTextBox("large-font Spacing 0", 1, 4, 10, "large-font", Orange)

	-- Now we can loop through each of the supported characters and display them in the ScreenBufferChip.
	local lines = DrawTextBox(characters, 1, 6, wrapWidth, "large-font", White, 0)

	DrawTextBox("small-font Spacing -4", 16, 4, 10, "large-font", Orange)

	-- This will draw the same set of characters using a font that is smaller. Here we are going to change the
	-- letter spacing to make the font look better. When drawing to TilemapCache mode the pixel data for the
	-- characters is copied over the tilemap's cache. If you clear the cache you will lose the text.
	DrawTextBox(characters, (wrapWidth + 4) * 8, 48, wrapWidth, "small-font", White, -4, DrawMode.TilemapCache)

	local offsetY = lines + 7

	-- Here we are going to draw the second font into the ScreenBufferChip. We'll change the letter space
	-- value to -4 since each character is 5 x 4 pixels instead of the default 8 x 8 pixels.
	DrawText("Long Text - No Wrap", 1, offsetY, DrawMode.Tile, "large-font", Orange)
	DrawText(longText, 1, offsetY + 2, DrawMode.Tile, "large-font", White)

	DrawText("Long Text - Wrap", 1, offsetY + 4, DrawMode.Tile, "large-font", Orange)

	-- By default, the engine treats each character as an 8x8 sprite. When working with fonts that are smaller
	-- than this size, you can change the offset to combine characters into more optimized sprite groups.

	-- Again we are going to draw all of the supported characters for the new font.
	--for i=1,#characters do
	DrawTextBox(longText, 1, offsetY + 6, 30, "large-font", White)
	--end

end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame before
-- the Draw() method. It accepts one argument, timeDelta, which is the difference in milliseconds since
-- the last frame. We are going to use this timeDelta value to keep track of the total time the game has
-- been running.
function Update(timeDelta)

	-- Increase time and keep track of how much has passed since the last frame.
	time = time + timeDelta
	counter = counter + timeDelta

	-- If the counter is greater than the delay we need to cycle to the next color.
	if(counter > delay) then

		-- Reset the counter and increment the colorOffset
		counter = 0
		colorOffset = colorOffset + 1

		-- We want to skip black since it is not going to show up correctly on the background.
		if(colorOffset == Black) then
			colorOffset = colorOffset + 1
		end

		-- The Nes only supported 53 colors so go back to 0 if we cycle throuhg all of them.
		if(colorOffset > 53) then
			colorOffset = 0
		end

	end

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and
-- is where all of our draw calls should go. We'll be using this to render font characters to the display.
function Draw()

	-- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a
	-- single call.
	RedrawDisplay()

	-- For dynamic text, such as the time value we are tracking, it will be too expensive to update the
	-- ScreenBufferChip on each frame. So, in this case, we are going to display the font characters as sprites.
	DrawText("Dynamic Text ".. time, 8, 28 * 8, DrawMode.Sprite, "large-font", colorOffset)

	-- If you leave the demo running for long enough, eventually characters will start to disappear when the
	-- DisplayChip hits the sprite limit. Rendering dynamic text in a game is very expensive and should be avoided as much as possible.

end

function DrawTextBox(text, x, y, width, font, colorOffset, spacing, drawMode)

	drawMode = drawMode or DrawMode.Tile
	spacing = spacing or 0
	colorOffset = colorOffset or 0
	local lineHeight = drawMode == DrawMode.TilemapCache and 8 or 1

	local wrap = WordWrap(text, width, "")
	local lines = SplitLines(wrap)
	local total = #lines

	for i = 1, total do
		DrawText(lines[i], x, y + ((i - 1) * lineHeight), drawMode, font, colorOffset, spacing)
	end

	return total

end
