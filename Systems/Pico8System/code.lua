--[[
  Pixel Vision 8 - New Template Script
  Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
  Created by Jesse Freeman (@jessefreeman)

  This project was designed to display some basic instructions when you create
  a new game.  Simply delete the following code and implement your own Init(),
  Update() and Draw() logic.

  Learn more about making Pixel Vision 8 games at https://www.gitbook.com/@pixelvision8
]]--

-- Loads in the pico-8 APIs
LoadScript("pico-8-shim")

-- TODO load a Pico8 Lua. Once loaded, Init, Update and Draw will call the p8 script's functions.

-- This this is an empty game, we will the following text. We combined two sets of fonts into
-- the default.font.png. Use uppercase for larger characters and lowercase for a smaller one.
local message = "EMPTY GAME\n\nThis is an empty game template. Press Ctrl + 1 to open the editor or modify the files found in your workspace game folder.\n\nVisit 'bit.ly/PV8GitBook' for the docs on how to use PV8."

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.
function Init()

	-- Test to see if a Pico8 _init function exists and call that.
	if(_init ~= nil) then
		_init()

		-- If no Pico8 Init exits, run the empty template code
	else

		-- Here we are manually changing the background color
		BackgroundColor(8)

		local display = Display()

		-- We are going to render the message in a box as tiles. To do this, we need to wrap the
		-- text, then split it into lines and draw each line.
		local wrap = WordWrap(message:lower(), ((display.x / 8) * 2) - 2)
		local lines = SplitLines(wrap)
		local total = #lines
		local startY = display.y - (total * 8)

		-- We want to render the text from the bottom of the screen so we offset it and loop backwards.
		for i = total, 1, - 1 do
			DrawText(lines[i], 4, startY + ((i - 1) * 8), DrawMode.TilemapCache, "default", 7, - 4)
		end
	end

end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame
-- before the Draw() method. It accepts one argument, timeDelta, which is the difference in
-- milliseconds since the last frame.
function Update(timeDelta)

	-- Test to see if a Pico8 _update function exists and call it on each update
	if(_update ~= nil) then
		_update()
	end

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

	-- Test to see if a Pico8 _draw function exits and call it on each draw
	if(_draw ~= nil) then
		_draw()
	else
		-- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a
		-- single call.
		RedrawDisplay()
	end

end
