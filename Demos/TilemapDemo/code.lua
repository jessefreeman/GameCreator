--[[
  Pixel Vision 8 - Tilemap API Demo
  Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
  Created by Jesse Freeman (@jessefreeman)

  This project was designed to display some basic instructions when you create
  a new game.  Simply delete the following code and implement your own Init(),
  Update() and Draw() logic.

  Learn more about making Pixel Vision 8 games at https://www.gitbook.com/@pixelvision8
]]--

LoadScript("sb-sprites")

-- This this is an empty game, we will the following text. We combined two sets of fonts into
-- the default.font.png. Use uppercase for larger characters and lowercase for a smaller one.
local scrollX = 0
local scrollY = 0
local speed = 24
local rightBorder = 0
local bottomBorder = 0
local hudHeight = 16

local delay = .5
local delayTime = .5
local waveMode = 0

local direction = {x = 0, y = 0}

local skeletons = {
  {sprites = skeleton.spriteIDs, width = skeleton.width, flipH = false, aboveBG = DrawMode.Sprite, x = 104, y = 64},
  {sprites = skeleton.spriteIDs, width = skeleton.width, flipH = false, aboveBG = DrawMode.SpriteBelow, x = 64, y = 94},
  {sprites = skeleton.spriteIDs, width = skeleton.width, flipH = true, aboveBG = DrawMode.SpriteBelow, x = 120, y = 94},
  {sprites = skeleton.spriteIDs, width = skeleton.width, flipH = false, aboveBG = DrawMode.Sprite, x = 180, y = 144},

  {sprites = skeleton.spriteIDs, width = skeleton.width, flipH = false, aboveBG = DrawMode.Sprite, x = 72, y = 240},
  {sprites = skeleton.spriteIDs, width = skeleton.width, flipH = false, aboveBG = DrawMode.Sprite, x = 240, y = 280},
  {sprites = skeleton.spriteIDs, width = skeleton.width, flipH = false, aboveBG = DrawMode.Sprite, x = 160, y = 192},
  {sprites = skeleton.spriteIDs, width = skeleton.width, flipH = false, aboveBG = DrawMode.Sprite, x = 168, y = 248},
}

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.
function Init()

  -- Change the background color
  BackgroundColor(2)

  -- Get sprite, tilemap and display sizes
  local spriteSize = SpriteSize()
  local tilemapSize = TilemapSize()
  local displaySize = Display()

  -- Need to get a reference to the right edge of the tilemap
  rightBorder = (tilemapSize.x * spriteSize.x) - displaySize.x;
  bottomBorder = (tilemapSize.y * spriteSize.y) - displaySize.y;

  -- Get the current visual bounds and modify for the new HUD
  bounds = NewRect(-8, - 8, displaySize.x, displaySize.y)
  -- bounds.y = 8

  -- Setup water tiles before rendering map
  local waterColumns = 6
  local waterRows = tilemapSize.y
  local totalTiles = (waterColumns) * (waterRows)

  local waterTiles = {}
  for i = 1, totalTiles do
    --TODO need to use modulus to calculate the right tiles?
    waterTiles[i] = watertile.spriteIDs[1]
  end

  -- Left water
  UpdateTiles(0, 3, waterColumns, waterTiles, 3)

  -- -- Right Water
  UpdateTiles(34, 3, waterColumns, waterTiles, 3)

  scrollX = 0
  scrollY = 0

end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame
-- before the Draw() method. It accepts one argument, timeDelta, which is the difference in
-- milliseconds since the last frame.
function Update(timeDelta)

  scrollX = scrollX + ((speed * timeDelta) * direction.x)
  scrollY = scrollY + ((speed * timeDelta) * direction.y)

  if(scrollX >= rightBorder) then
    scrollX = rightBorder
    direction.x = -1
  elseif(scrollX <= 0) then
    scrollX = 0
    direction.x = 1
  end

  if(scrollY >= bottomBorder) then
    scrollY = bottomBorder
    direction.y = -1
  elseif(scrollY <= hudHeight) then
    scrollY = hudHeight
    direction.y = 1
  end

  -- We start by adding the time delta to the delay.
  delay = delay + timeDelta

  -- Next, we will need to test if the delay value is greater than the delayTime field we set up at the
  -- beginning of our class.
  if(delay > delayTime) then

    if(waveMode == 0) then
      waveMode = 1
      ReplaceColor(4, 2)
      ReplaceColor(6, 1)
    elseif(waveMode == 1) then
      waveMode = 0
      ReplaceColor(4, 1)
      ReplaceColor(6, 2)
    end

    -- We need to reset the delay so we can start tracking it again on the next frame.
    delay = 0

  end



end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

  Clear()

  -- Convert the scrollX value into a whole number
  newScrollX = math.floor(scrollX)
  newScrollY = math.floor(scrollY)

  -- scroll the tilemap map down below the HUD which is 16 pixels hight. Also apply the new scrollX value
  ScrollPosition(newScrollX, newScrollY)

  DrawTilemap(0, hudHeight, 20, 15, newScrollX, newScrollY + hudHeight)

  -- Draw sprites

  local total = #skeletons

  for i = 1, total do
    local skeleton = skeletons[i]
    DrawSprites(skeleton.sprites, skeleton.x, skeleton.y, skeleton.width, skeleton.flipH, false, skeleton.aboveBG, 0, true, true, bounds)
  end

  DrawSprites(chest.spriteIDs, 168, 72 + 32, chest.width, false, false, DrawMode.Sprite, 0, true, true, bounds)

  -- Read the current scroll position from the display
  local pos = ScrollPosition()

  -- Draw the scroll x and y position to the display
  DrawText(string.format("(%03d,%03d)", pos.x, pos.y), 8, 124, DrawMode.SpriteAbove, "default")

  -- Need to rest tiles under tilemap cache to force it to clear correctly and maintain the HUD bg color
  DrawTiles({17, 17, 17}, 12, 1, 3)
  DrawTiles({17, 17}, 16, 1, 2)

  -- Draw new text on top of the tilemap data cache so we can maintain the transparency
  DrawText(ReadTotalSprites(), 12 * 8, 8, DrawMode.TilemapCache, "default")
  DrawText(ReadFPS(), 16 * 8, 8, DrawMode.TilemapCache, "default")

  -- Draw the HUD layer after we update the tilemap
  DrawTilemap(0, 0, 20, 3, 0, 0, DrawMode.UI)

end
