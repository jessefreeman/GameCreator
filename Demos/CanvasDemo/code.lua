--[[
  Pixel Vision 8 - New Template Script
  Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
  Created by Jesse Freeman (@jessefreeman)

  This project was designed to display some basic instructions when you create
  a new game.  Simply delete the following code and implement your own Init(),
  Update() and Draw() logic.

  Learn more about making Pixel Vision 8 games at https://www.gitbook.com/@pixelvision8
]]--


local tool = "Pen"
local fill = false
local cursorSprite = 94
local display = nil
local startPos = nil
local lastDrawing = nil

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.
function Init()

	-- Here we are manually changing the background color
	BackgroundColor(1)

	-- Get the display size
	display = Display()

	-- Create a new custom cursor
	local cursorData = NewCanvas(SpriteSize().x, SpriteSize().y)
	cursorData:DrawLine(3, 0, 3, 6, 0)
	cursorData:DrawLine(0, 3, 6, 3, 0)
	cursorData:SetPixel(3, 3, 1)

	-- Save the cursor pixel data to a sprite
	Sprite(cursorSprite, cursorData:GetPixels())

	-- Create a new canvas for drawing into
	canvas = NewCanvas(display.x, display.y)

	-- Set a default pattern for fills
	local pattern = {
		1, 0, 1, 0,
		0, 1, 0, 1,
		1, 0, 1, 0,
		0, 1, 0, 1
	}
	canvas:SetPattern(pattern, 4, 4)

end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame
-- before the Draw() method. It accepts one argument, timeDelta, which is the difference in
-- milliseconds since the last frame.
function Update(timeDelta)

	-- Save the current mouse position
	mousePos = MousePosition()

	-- Test to see if the mouse if offscreen
	onScreen = mousePos.x >= 0 and mousePos.y >= 0 and mousePos.x <= display.x and mousePos.y <= display.y

	-- Test to see if the mouse is on the screen
	if(onScreen == false) then

		-- Release the drawing tool if mouse is offscreen
		OnRelease()

	else

		-- If the mouse is on the screen look to see if the mouse button is down
		if( MouseButton(0)) then

			-- If the position array is empty, create a new one with the start position
			if(startPos == nil) then
				-- print("Create pos")
				startPos = NewVector(mousePos.x, mousePos.y)
			end

			-- The mouse is not down
		else

			-- Test to see if the startPos still exists
			if(startPos ~= nil) then

				-- Release the drawing tool
				OnRelease()

			end

		end

	end

	-- Capture keys to switch between different tools and options
	if( Key(Keys.Alpha1, InputState.Released) ) then
		tool = "Pen"
	elseif( Key(Keys.Alpha2, InputState.Released) ) then
		tool = "Eraser"
	elseif( Key(Keys.Alpha3, InputState.Released) ) then
		tool = "Line"
	elseif( Key(Keys.Alpha4, InputState.Released) ) then
		tool = "Square"
	elseif( Key(Keys.Alpha5, InputState.Released) ) then
		tool = "Circle"
	elseif( Key(Keys.f, InputState.Released) ) then
		fill = not fill
	elseif( Key(Keys.C, InputState.Released) ) then
		Clear()
	end

end

function OnRelease()

	-- Clear the start position
	startPos = nil

	-- Save the last drawing
	lastDrawing = canvas:GetPixels()

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

	-- If there was a drawing on the previous frame, copy it over to the tilemap cache
	if(lastDrawing ~= nil) then

		-- Draw the last canvas pixel data into the tilemap cache
		DrawPixels(lastDrawing, 0, 0, canvas.width, canvas.height, DrawMode.TilemapCache, false, true)

		-- Clear the last drawing value
		lastDrawing = nil

		-- Clear the canvas
		canvas:Clear()

	end

	-- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a
	-- single call.
	RedrawDisplay()

	-- Get the start position for a new drawing
	if(startPos ~= nil) then

		-- Test for the tool and perform a draw action
		if(tool == "Pen") then

			-- Change the stroke to a single pixel
			canvas:SetStroke({0}, 1, 1)

			canvas:DrawLine(startPos.x, startPos.y, mousePos.x, mousePos.y)
			startPos = NewVector(mousePos.x, mousePos.y)

		elseif(tool == "Eraser") then

			-- Change the stroke to 4 x 4 pixel box
			canvas:SetStroke({1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 4, 4)

			canvas:DrawLine(startPos.x, startPos.y, mousePos.x, mousePos.y)
			startPos = NewVector(mousePos.x, mousePos.y)

		elseif(tool == "Line") then

			canvas:Clear()

			-- Change the stroke to a single pixel
			canvas:SetStroke({0}, 1, 1)

			canvas:DrawLine(startPos.x, startPos.y, mousePos.x, mousePos.y, fill)

		elseif(tool == "Square") then

			canvas:Clear()

			-- Change the stroke to a single pixel
			canvas:SetStroke({0}, 1, 1)

			canvas:DrawSquare(startPos.x, startPos.y, mousePos.x, mousePos.y, fill)

		elseif(tool == "Circle") then

			canvas:Clear()

			-- Change the stroke to a single pixel
			canvas:SetStroke({0}, 1, 1)

			canvas:DrawCircle(startPos.x, startPos.y, mousePos.x, mousePos.y, fill)

		end

		-- Draw the canvas to the UI layer.
		canvas:DrawPixels(DrawMode.UI)

	end

	-- Make sure that the mouse is on screen before drawing the cursor sprite
	if(onScreen) then
		DrawSprite(cursorSprite, MousePosition().x - 4, MousePosition().y - 4, false, false, DrawMode.SpriteAbove)
	end

	-- Create a new label starting with the tool name
	local label = tool

	-- Add fill option to the label for tools that support it.
	if(tool == "Square" or tool == "Circle") then
		label = tool .. " Fill " .. tostring(fill)
	end

	-- Draw the label to the screen above the UI layer
	DrawText(label, 4, 4, DrawMode.SpriteAbove, "default")

end

function Clear()

	-- Clear the entire tilemap cache by drawing a rect over it
	DrawRect(0, 0, Display().x, Display().y, 1, DrawMode.TilemapCache)

end
