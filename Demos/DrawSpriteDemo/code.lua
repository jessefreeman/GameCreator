--[[
	Pixel Vision 8 - New Template Script
	Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
	Created by Jesse Freeman (@jessefreeman)

	This project was designed to display some basic instructions when you create
	a new game.	Simply delete the following code and implement your own Init(),
	Update() and Draw() logic.

	Learn more about making Pixel Vision 8 games at https://www.gitbook.com/@pixelvision8
]]--

-- spritelib-start
face1 = {width = 1, unique = 1, total = 1, spriteIDs = {24}}
face2 = {width = 1, unique = 1, total = 1, spriteIDs = {25}}
fireball1 = {width = 1, unique = 1, total = 1, spriteIDs = {6}}
fireball2 = {width = 1, unique = 1, total = 1, spriteIDs = {7}}
flower = {width = 2, unique = 4, total = 4, spriteIDs = {16, 17, 26, 27}}
ghost = {width = 2, unique = 4, total = 4, spriteIDs = {4, 5, 14, 15}}
pipe = {width = 2, unique = 4, total = 4, spriteIDs = {8, 9, 18, 19}}
playerframe1 = {width = 2, unique = 6, total = 6, spriteIDs = {0, 1, 10, 11, 20, 21}}
playerframe2 = {width = 2, unique = 6, total = 6, spriteIDs = {2, 3, 12, 13, 22, 23}}
-- spritelib-end

-- This this is an empty game, we will the following text. We combined two sets of fonts into
-- the default.font.png. Use uppercase for larger characters and lowercase for a smaller one.
local title = "Drawing API Demo"
local message = "This demo shows off how to draw sprites to the display."

-- create some references to the sprites we'll use based on the generated spritedata

-- Lets create a table containing the two sprite IDs for the fireball
local fireballSprites = { fireball1.spriteIDs[1], fireball2.spriteIDs[1] }

-- Now we create a table that contains the data for each frame of animation
local fireballAnimation = {
	{sprite = fireballSprites[1], hFlip = false, vFlip = false},
	{sprite = fireballSprites[2], hFlip = false, vFlip = false},
	{sprite = fireballSprites[1], hFlip = true, vFlip = true},
	{sprite = fireballSprites[2], hFlip = true, vFlip = true}
}

local rawSpriteData = {
	00, 00, 00, 00, 00, 00, 00, 00,
	00, - 1, - 1, - 1, - 1, - 1, - 1, 00,
	00, - 1, 00, 00, 00, 00, - 1, 00,
	00, - 1, 00, - 1, - 1, 00, - 1, 00,
	00, - 1, 00, 00, 00, 00, - 1, 00,
	00, - 1, 00, 00, - 1, - 1, - 1, 00,
	00, - 1, 00, - 1, - 1, - 1, - 1, 00,
	00, 00, 00, 00, 00, 00, 00, 00,
}
-- Here we will store the fireball animation data
local fireballDelay = .2
local fireballTime = 0
local fireballFrame = 1

local ghostSprites = {
	body = ghost.spriteIDs,
	faces = {face1.spriteIDs[1], face2.spriteIDs[1]},
	width = ghost.width
}

local ghostPos = {
	x = 8,
	y = 28,
}

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.
function Init()

	-- Here we are manually changing the background color
	BackgroundColor(32)

	DrawText("Drawing API Demo", 1, 1, DrawMode.Tile, "default")

	DrawText("1. Single Sprites", 1, 4, DrawMode.Tile, "default")

	DrawText("2. Composit Sprites", 1, 8, DrawMode.Tile, "default")

	DrawText("3. Palette Shifting", 1, 13, DrawMode.Tile, "default")

	DrawText("4. Above/Below Tiles", 1, 18, DrawMode.Tile, "default")

	DrawText("5. Raw Pixel Data", 1, 24, DrawMode.Tile, "default")

	local pipeX = 1
	local pipeY = 21

	-- Draw a pipe into the background
	Tile(pipeX, pipeY, pipe.spriteIDs[1], 12)
	Tile(pipeX + 1, pipeY, pipe.spriteIDs[2], 12)
	Tile(pipeX, pipeY + 1, pipe.spriteIDs[3], 12)
	Tile(pipeX + 1, pipeY + 1, pipe.spriteIDs[4], 12)

	-- Draw a second pipe into the background
	pipeX = pipeX + 3
	Tile(pipeX, pipeY, pipe.spriteIDs[1], 12)
	Tile(pipeX + 1, pipeY, pipe.spriteIDs[2], 12)
	Tile(pipeX, pipeY + 1, pipe.spriteIDs[3], 12)
	Tile(pipeX + 1, pipeY + 1, pipe.spriteIDs[4], 12)

end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame
-- before the Draw() method. It accepts one argument, timeDelta, which is the difference in
-- milliseconds since the last frame.
function Update(timeDelta)

	-- TODO add your own update logic here


	-- Here we are tracking the fireball animation
	fireballTime = fireballTime + timeDelta

	if(fireballTime > fireballDelay) then

		fireballFrame = fireballFrame + 1

		if(fireballFrame > #fireballAnimation) then
			fireballFrame = 1
		end

		fireballTime = 0

	end

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

	-- We can use the DrawScreenBuffer() method to clear the screen and redraw the tilemap in a
	-- single call.

	Clear()

	DrawTilemap(0, 0, 32, 30)

	local newX = 8
	local newY = 48

	-- Here we are going to draw a single sprite to the screen.
	DrawSprite(fireballSprites[1], newX, newY)

	newX = newX + 16
	DrawSprite(fireballSprites[2], newX, newY)

	-- Next we will draw the same sprite but flip it horizontally and vertically to create 3 new
	-- animaion frames from the same sprite
	newX = newX + 16
	DrawSprite(fireballSprites[1], newX, newY, true, true)
	newX = newX + 16
	DrawSprite(fireballSprites[2], newX, newY, true, true)

	-- Now we will animate the fireball while trying to use the least amout of sprites possible.
	local frameData = fireballAnimation[fireballFrame]
	newX = newX + 16
	DrawSprite(frameData.sprite, newX, newY, frameData.hFlip, frameData.vFlip)

	-- Now it's time to draw a more complex sprite. First we'll start with the ghost's body. We'll
	-- use DrawSprites which allows us to draw multiple sprites in a grid
	newX = 8
	newY = newY + 32
	DrawSprites(ghostSprites.body, newX, newY, ghostSprites.width)

	newX = newX + 24
	DrawSprite(ghostSprites.faces[1], newX, newY)

	-- Now lets build the full ghost by drawing the body first then the face on top.
	newX = newX + 16
	DrawSprites(ghostSprites.body, newX, newY, ghostSprites.width)
	DrawSprite(ghostSprites.faces[1], newX + 6, newY + 4)

	-- We can also flip the ghost and readjust the face sprite.
	newX = newX + 24
	DrawSprites(ghostSprites.body, newX, newY, ghostSprites.width, true)
	DrawSprite(ghostSprites.faces[1], newX + 2, newY + 4, true)

	-- Finally we could even change the ghosts face since it's just a single sprite on top of the ghost's
	-- body sprites.
	newX = newX + 28
	DrawSprites(ghostSprites.body, newX, newY, ghostSprites.width)
	DrawSprite(ghostSprites.faces[2], newX + 6, newY + 4)

	-- Here is an example of palette shifting. First we draw the sprite based on its normal colors.
	newX = 8
	newY = newY + 40
	DrawSprites(flower.spriteIDs, newX, newY, flower.width)

	-- Now we can shift the flower sprite's color IDs to change the way it looks. Here you'll see the
	-- flower now has color but we need to make the stem green
	newX = newX + 24
	DrawSprites(flower.spriteIDs, newX, newY, flower.width, false, false, DrawMode.SpriteAbove, 3)

	-- To shift the palette for each sprite differently, we'll have to draw them by hand
	newX = newX + 24
	DrawSprite(flower.spriteIDs[1], newX, newY, false, false, DrawMode.SpriteAbove, 3)

	-- Since the top left and top right sprites are the same, we can just flip them horizontally and
	-- move it over by 8 pixels
	DrawSprite(flower.spriteIDs[1], newX + 8, newY, true, false, DrawMode.SpriteAbove, 3)

	-- Since the top left and top right sprites are the same, we can just flip them horizontally and
	-- move it over by 8 pixels
	DrawSprite(flower.spriteIDs[3], newX, newY + 8, false, false, DrawMode.SpriteAbove, 6)
	DrawSprite(flower.spriteIDs[3], newX + 8, newY + 8, true, false, DrawMode.SpriteAbove, 6)

	-- In this demo we will look at rendering a player in front of a background tile.
	newX = 12
	newY = newY + 40
	DrawSprite(playerframe1.spriteIDs[1], newX, newY, false, false, DrawMode.SpriteAbove, 3)
	DrawSprite(playerframe1.spriteIDs[2], newX + 8, newY, false, false, DrawMode.SpriteAbove, 3)
	DrawSprite(playerframe1.spriteIDs[3], newX, newY + 8, false, false, DrawMode.SpriteAbove, 3)
	DrawSprite(playerframe1.spriteIDs[4], newX + 8, newY + 8, false, false, DrawMode.SpriteAbove, 3)
	DrawSprite(playerframe1.spriteIDs[5], newX, newY + 16, false, false, DrawMode.SpriteAbove, 9)
	DrawSprite(playerframe1.spriteIDs[6], newX + 8, newY + 16, false, false, DrawMode.SpriteAbove, 9)

	-- Now we can render the same sprite but have it display behind the tilemap.
	newX = newX + 28
	DrawSprite(playerframe1.spriteIDs[1], newX, newY, false, false, DrawMode.SpriteBelow, 3)
	DrawSprite(playerframe1.spriteIDs[2], newX + 8, newY, false, false, DrawMode.SpriteBelow, 3)
	DrawSprite(playerframe1.spriteIDs[3], newX, newY + 8, false, false, DrawMode.SpriteBelow, 3)
	DrawSprite(playerframe1.spriteIDs[4], newX + 8, newY + 8, false, false, DrawMode.SpriteBelow, 3)
	DrawSprite(playerframe1.spriteIDs[5], newX, newY + 16, false, false, DrawMode.SpriteBelow, 9)
	DrawSprite(playerframe1.spriteIDs[6], newX + 8, newY + 16, false, false, DrawMode.SpriteBelow, 9)

	-- In this demo we are going to push raw pixel data to the display as a sprite
	newX = 8
	newY = newY + 48
	DrawPixels(rawSpriteData, newX, newY, 8, 8)

	newX = newX + 16
	DrawPixels(rawSpriteData, newX, newY, 8, 8, 0, true)

	newX = newX + 16
	DrawPixels(rawSpriteData, newX, newY, 8, 8, 0, false, true)

	newX = newX + 16
	DrawPixels(rawSpriteData, newX, newY, 8, 8, 0, true, true)

	newX = newX + 16
	DrawPixels(rawSpriteData, newX, newY, 8, 8, 0, false, false, 3)

end
