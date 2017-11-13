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

-- The Sound Effect Demos shows off how to play back SFXR sounds 
-- in Pixel Vision 8. This demo loads a sound effect from the 
-- Sound Chip then play it back when the mouse button is down.

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw some text to the display.
function Init()
	
	-- Before we start, we need to set a background color and rebuild the ScreenBufferChip. The screen buffer
	-- allows us to draw our fonts into the background layer to save on draw calls.
	BackgroundColor(32)
	
	-- This default text will help display the current state of the mouse. We'll render it into the 
    -- ScreenBufferChip to cut down on sprite draw calls.
	DrawText("Sound Test", 1, 1, DrawMode.Tile, "large-font", 0)
	DrawText("Click anywhere to play!", 1, 4, DrawMode.Tile, "large-font", 1)

end

function Update()

	-- Detect if the left mouse button is down.
	if(MouseButton(0, InputState.Released) == true) then

		-- Play the first sound effect in the first channel.
		PlaySound(0)

	end

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and
-- is where all of our draw calls should go. We'll be using this to render font characters and the
-- mouse cursor to the display.
function Draw()

	-- It's important to clear the display on each frame. There are two ways to do this. Here 
	-- we are going to use the DrawScreenBuffer() way to copy over the existing buffer and clear
	-- all of the previous pixel data.
	RedrawDisplay()

end