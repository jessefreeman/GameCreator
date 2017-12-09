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

local delay = .5
local delayTime = .5
local waveMode = 0

local direction = {x = 0, y = 0}

local skeletons = {
  {sprites = skeleton.spriteIDs, width = skeleton.width, flipH = false, aboveBG = DrawMode.SpriteAbove, x = 104, y = 40},
  {sprites = skeleton.spriteIDs, width = skeleton.width, flipH = false, aboveBG = DrawMode.SpriteBelow, x = 64, y = 70},
  {sprites = skeleton.spriteIDs, width = skeleton.width, flipH = true, aboveBG = DrawMode.SpriteBelow, x = 120, y = 70},
  {sprites = skeleton.spriteIDs, width = skeleton.width, flipH = false, aboveBG = DrawMode.SpriteAbove, x = 180, y = 120},

  {sprites = skeleton.spriteIDs, width = skeleton.width, flipH = false, aboveBG = DrawMode.SpriteAbove, x = 72, y = 216},
  {sprites = skeleton.spriteIDs, width = skeleton.width, flipH = false, aboveBG = DrawMode.SpriteAbove, x = 240, y = 256},
  {sprites = skeleton.spriteIDs, width = skeleton.width, flipH = false, aboveBG = DrawMode.SpriteAbove, x = 160, y = 168},
  {sprites = skeleton.spriteIDs, width = skeleton.width, flipH = false, aboveBG = DrawMode.SpriteAbove, x = 168, y = 224},
}

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.
function Init()


  -- Get sprite, tilemap and display sizes
  local spriteSize = SpriteSize()
  local tilemapSize = TilemapSize()
  local displaySize = DisplaySize()

  -- Need to get a reference to the right edge of the tilemap
  rightBorder = (tilemapSize.x * spriteSize.x) - displaySize.x;
  bottomBorder = (tilemapSize.y * spriteSize.y) - displaySize.y;

  -- Setup water tiles before rendering map
  local waterColumns = 6
  local waterRows = tilemapSize.y
  local totalTiles = (waterColumns) * (waterRows)

  local waterTiles = {}
  for i = 1, totalTiles do
    --TODO need to use modulous to calculate the right tiles?
    waterTiles[i] = watertile.spriteIDs[1]
  end

  -- Left water
  UpdateTiles(0, 0, waterColumns, waterTiles, 3)

  -- -- Right Water
  UpdateTiles(34, 0, waterColumns, waterTiles, 3)

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
  elseif(scrollY <= 0) then
    scrollY = 0
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

  -- Change the background color
  BackgroundColor(2)

  -- Convert the scrollX value into a whole number
  newScrollX = math.ceil(scrollX)
  newScrollY = math.ceil(scrollY)

  -- scroll the tilemap map down below the HUD which is 16 pixels hight. Also apply the new scrollX value
  ScrollPosition(newScrollX, newScrollY)

  -- Redraw the entire display
  RedrawDisplay()

  -- Draw sprites

  local total = #skeletons

  for i = 1, total do
    local skeleton = skeletons[i]
    DrawSprites(skeleton.sprites, skeleton.x, skeleton.y, skeleton.width, skeleton.flipH, false, skeleton.aboveBG)
  end

  DrawSprites(chest.spriteIDs, 168, 72, chest.width)

  -- Read the current scroll position from the display
  local pos = ScrollPosition()

  -- Draw the scroll x and y position to the display
  DrawText(string.format("(%03d,%03d)", pos.x, pos.y), 8, 124, DrawMode.Sprite, "default")

end
