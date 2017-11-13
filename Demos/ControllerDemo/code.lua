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

-- Before we can display the input, we'll want to track each button state. These Boolean Arrays will 
-- help us track if each button is down (false) or up (true).
local player1States = {}
local player2States = {}

-- We'll use these values to help lay out the button state text.
local pos = {x = 1, y = 3, xOffset = 13}

-- Pixel Vision 8 supports 8 unique buttons: Up, Down, Left, Right, A, B, Select and Start.
local totalButtons = 8

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw some text to the display.
function Init()

	-- Before we start, we need to set a background color.
	BackgroundColor(32)
	
	-- We need to display some default text for our demo explaining what is going on. This text will just be 
	-- drawn into the screen buffer.
	DrawText("CONTROLLER TEST", pos.x , pos.y - 2, DrawMode.Tile, "large-font")

	local labels = {"PLAYER ", " ", "    Up:", "  Down:", " Right:", "  Left:", "     A:", "     B:", "Select:", " Start:"}

	local startX = pos.x
	local startY = pos.y
	
	local total = #labels
	for i=1,total do

		local label1 = labels[i]
		local label2 = labels[i]

		if(i == 1) then
			label1 = label1 .. "ONE"
			label2 = label2 .. "TWO"
		end

		DrawText(label1, pos.x , pos.y + i, DrawMode.Tile, "large-font")
		DrawText(label2, pos.x + pos.xOffset, pos.y + i, DrawMode.Tile, "large-font")

	end

end

-- The Update() method is part of the game's life cycle. The engine
-- calls Update() on every frame before the Draw() method. It accepts
-- one argument, timeDelta, which is the difference in milliseconds
-- since the last frame. We are going to track each player's button state.
function Update()
	
	-- We'll need to loop through each of the buttons. We can use the totalButtons to limit the for loop and
	-- we'll move through each controller's button states at the same time.
	for i=1,totalButtons do

		-- The ButtonDown() method returns true when a button is down and false if the player is not pressing it.
		-- We'll save this value into our player1States and player2States Arrays.
		player1States[i] = Button(i-1, InputState.Down, 0)
		player2States[i] = Button(i-1, InputState.Down, 1)

	end

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and
-- is where all of our draw calls should go. We'll be using this to render font characters to the display.
function Draw()

	-- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a 
	-- single call.
	RedrawDisplay()

	-- This resets the x and y values we use to draw the fonts to the display.
	local x = 0
	local y = 0

	-- In this loop, we set up the X and Y positions for our text then draw the font to the display to show the
	-- current state of each button.
	for i=1,totalButtons do
		x = (pos.x + 8) * 8
		y = (( i + pos.y + 2) * 8) + pos.y 
		DrawText(player1States[i] == true and "DOWN" or "UP", x, y - 3, DrawMode.Sprite, "large-font", 2)
	end

	-- We'll do the same thing for player two but adjust for the text being in the second column by adding the xOffset the x value.
	for i=1,totalButtons do
		x = (pos.x + pos.xOffset + 8) * 8
		y = (( i + pos.y + 2) * 8) + pos.y 
		DrawText(player2States[i] == true and "DOWN" or "UP", x, y - 3, DrawMode.Sprite, "large-font", 2)
	end
	
end
