--[[
  Pixel Vision 8 - Save Demo
  Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
  Created by Jesse Freeman (@jessefreeman)

  This project was designed to display some basic instructions when you create
  a new game.  Simply delete the following code and implement your own Init(),
  Update() and Draw() logic.

  Learn more about making Pixel Vision 8 games at https://www.gitbook.com/@pixelvision8
]]--

-- This this is an empty game, we will the following text. We combined two sets of fonts into
-- the default.font.png. Use uppercase for larger characters and lowercase for a smaller one.
local title = "SAVE DEMO"
local message = "Last opened:"

local lastOpened = nil
-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.
function Init()

  -- Here we are manually changing the background color
  BackgroundColor(32)

  -- Let's draw the title into the tilemap
  DrawText(title, 1, 1, DrawMode.Tile, "default")

  -- We are going to render the message in a box as tiles.
  DrawText(message, 1, 4, DrawMode.Tile, "default", 0, 0, 31)

  -- Read the save data from the game cartridge
  lastOpened = ReadSaveData("lastOpened", "undefined")

  -- Finally we'll render the date below our message as tiles.
  DrawText(lastOpened, 1, 6, DrawMode.Tile, "default", 0, 0, 31)

  -- Finally we'll render the date below our message as tiles.
  DrawText("Hit Ctrl + 4 to reload.", 1, 10, DrawMode.Tile, "default", 0, 0, 31)

end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame
-- before the Draw() method. It accepts one argument, timeDelta, which is the difference in
-- milliseconds since the last frame.
function Update(timeDelta)

  -- TODO add your own update logic here

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

  -- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a
  -- single call.
  RedrawDisplay()

  -- TODO add your own draw logic here.

end

function Shutdown()

  -- Get the time stamp for shutting down
  lastOpened = os.date('%Y-%m-%d %H:%M:%S', ts)

  -- Save the timestamp back to the cartridge
  WriteSaveData("lastOpened", lastOpened)

end
