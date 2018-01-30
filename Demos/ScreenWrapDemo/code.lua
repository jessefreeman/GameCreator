--[[
	Pixel Vision 8 - New Template Script
	Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
	Created by Jesse Freeman (@jessefreeman)

	This project was designed to display some basic instructions when you create
	a new game.	Simply delete the following code and implement your own Init(),
	Update() and Draw() logic.

	Learn more about making Pixel Vision 8 games at https://www.gitbook.com/@pixelvision8
]]--

LoadScript("sb-sprites")
LoadScript("micro-platformer")

local message = "SCREEN WRAP DEMO\n\nThis demo shows off how sprites wrap around the edges of the screen."

local cloudSpeed = 10

local clouds = {
	{
		x = 112,
		y = 96 + 4,
		speed = cloudSpeed,
		sprites = smallcloud.spriteIDs,
		width = smallcloud.width
	},
	{
		x = 88,
		y = 80,
		speed = cloudSpeed,
		sprites = largecloud.spriteIDs,
		width = largecloud.width
	},
	{
		x = 16,
		y = 128,
		speed = cloudSpeed,
		sprites = smallcloud.spriteIDs,
		width = smallcloud.width
	}
}

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.
function Init()

	-- Here we are manually changing the background color
	BackgroundColor(3)

	local display = Display()

	-- We are going to render the message in a box as tiles. To do this, we need to wrap the
	-- text, then split it into lines and draw each line.
	local wrap = WordWrap(message, (display.x / 8) - 2)
	local lines = SplitLines(wrap)
	local total = #lines

	-- We want to render the text from the bottom of the screen so we offset it and loop backwards.
	for i = total, 1, - 1 do
		DrawText(lines[i], 1, (i - 1) + 1, DrawMode.Tile, "default")
	end

	-- Create a new micro platformer instance
	microPlatformer = MicroPlatformer:Init()
	microPlatformer.player.spriteID = player.spriteIDs[1]

	microPlatformer.jumpSound = 0
	microPlatformer.hitSound = 1

end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame
-- before the Draw() method. It accepts one argument, timeDelta, which is the difference in
-- milliseconds since the last frame.
function Update(timeDelta)

	-- Update the player logic first so we always have the correct player x and y pos
	microPlatformer:Update(timeDelta)

	-- Update the clouds in the background
	local newCloudSpeed = cloudSpeed * timeDelta

	for i = 1, #clouds do
		clouds[i].x = clouds[i].x + newCloudSpeed
	end

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

	-- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a
	-- single call.
	RedrawDisplay()

	-- Create a temp variable for each cloud instance in the loop and the total clouds
	local cloud = nil
	local total = #clouds

	for i = 1, total do

		-- Get cloud data
		cloud = clouds[i]

		-- Draw clouds first since they are in the background layer
		DrawSprites(cloud.sprites, cloud.x, cloud.y, cloud.width, false, false, DrawMode.SpriteBelow, 0, false)

	end

	-- Need to draw the player last since the order of sprite draw calls matters
	microPlatformer:Draw()

end
