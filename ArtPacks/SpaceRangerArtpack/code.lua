--[[
  Pixel Vision 8 - New Template Script
  Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
  Created by Jesse Freeman (@jessefreeman)

  Space Ranger artwork created by Luis Zuno (@ansimuz) and was designed for use
  with the Pixel Vision 8 Game Creator. You are free to include this artwork in
  your own game as long as you give credit to the original creator.

  This project was designed to display some basic instructions when you create
  a new game.  Simply delete the following code and implement your own Init(),
  Update() and Draw() logic.

  Learn more about making Pixel Vision 8 games at https://www.gitbook.com/@pixelvision8
]]--

LoadScript("sb-sprites")

-- This this is an empty game, we will the following text. We combined two sets of fonts into
-- the default.font.png. Use uppercase for larger characters and lowercase for a smaller one.
local message = "SPACE RANGER BY LUIS ZUNO\n\n\nThis asset pack contains colors, sprites & a tilemap which can be imported into a project.\n\nVisit 'bit.ly/PV8GitBook' for the docs on how to use PV8.\n\n"

local speed = 32
local rightBorder = 0
local delay = .5
local delayTime = .5
local direction = {x = 0, y = 0}
local scrollX = 0
local lines = nil
local total = 0
local startY = 0
local entities = {
  -- Player Idle
  {
    x = 232,
    y = 112,
    frames = {
      idle1,
      idle2
    },
    frame = 1,
    delay = .2,
    time = 0,
    flipH = false
  },

  -- Player Climb
  {
    x = 727,
    y = 200,
    frames = {
      climbing1,
      climbing2
    },
    frame = 1,
    delay = .2,
    time = 0,
    flipH = false
  },

  -- Player Jump
  {
    x = 936,
    y = 112,
    frames = {
      jump
    },
    frame = 1,
    delay = .1,
    time = 0,
    flipH = false
  },

  -- Jumping Enemy
  {
    x = 512,
    y = 144,
    frames = {
      jumping1,
      jumping2,
      jumping3
    },
    frame = 1,
    delay = .2,
    time = 0,
    flipH = false
  },
  -- Flying Enemy
  {
    x = 360,
    y = 56,
    frames = {
      flying1,
      flying2,
      flying3,
      flying4
    },
    frame = 1,
    delay = .15,
    time = 0,
    flipH = false
  },
  -- Walking Enemy
  {
    x = 623,
    y = 176,
    frames = {
      walking1,
      walking2,
      walking3,
      walking4
    },
    frame = 1,
    delay = .1,
    time = 0,
    flipH = false
  }

}

local totalEntities = #entities

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.
function Init()

  -- Here we are manually changing the background color
  BackgroundColor(32)

  local display = Display()

  -- We are going to render the message in a box as tiles. To do this, we need to wrap the
  -- text, then split it into lines and draw each line.
  local wrap = WordWrap(message, (display.x / 8) - 2)
  lines = SplitLines(wrap)
  total = #lines
  startY = (((display.y / 8) - 1) - total) * 8

  -- Get sprite, tilemap and display sizes
  local spriteSize = SpriteSize()
  local tilemapSize = TilemapSize()

  rightBorder = (tilemapSize.x * spriteSize.x) - display.x;


end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame
-- before the Draw() method. It accepts one argument, timeDelta, which is the difference in
-- milliseconds since the last frame.
function Update(timeDelta)

  -- TODO add your own update logic here

  scrollX +  = ((speed * timeDelta) * direction.x)

  if(scrollX >= rightBorder) then
    scrollX = rightBorder
    direction.x = -1
  elseif(scrollX <= 0) then
    scrollX = 0
    direction.x = 1
  end

  -- scroll the tilemap map down below the HUD which is 16 pixels hight. Also apply the new scrollX value
  ScrollPosition(scrollX, 0)

  -- Loop through all of the entities and animate them
  for i = 1, totalEntities do

    local data = entities[i]

    data.time +  = timeDelta

    if(data.time > data.delay) then
      data.frame +  = 1
      if(data.frame > #data.frames) then
        data.frame = 1
      end

      data.time = 0
    end

  end

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

  -- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a
  -- single call.
  RedrawDisplay()

  -- We want to render the text from the bottom of the screen so we offset it and loop backwards.
  for i = total, 1, - 1 do
    DrawText(lines[i], 8, startY + (i * 8), DrawMode.UI, "default")
  end

  for i = 1, totalEntities do

    local entity = entities[i]

    local spriteData = entity.frames[entity.frame]

    if(spriteData ~= nil)then

      DrawSprites(spriteData.spriteIDs, entity.x, entity.y, spriteData.width, entity.flipH, false, DrawMode.Sprite, 0, true, true)

    end

  end

  -- TODO add your own draw logic here.

end
