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

MouseCursor = {}
MouseCursor.__index = MouseCursor

-- TODO this should be set up like all of the other UI components and not its own object
function MouseCursor:Init()

  -- Create a new object for the instance and register it
  local _mouseCursor = {}
  setmetatable(_mouseCursor, MouseCursor)

  -- This defines which set of data to use when drawing the cursor
  _mouseCursor.cursorID = 1

  -- Reference data for each of the different mouse cursors
  _mouseCursor.cursors = {
    -- Pointer
    {
      spriteData = cursorpointer,
      offset = {
        x = 0,
        y = 0
      }
    },
    -- Hand (for interaction)
    {
      spriteData = cursorhand,
      offset = {
        x = -6,
        y = 0
      }
    },

    -- Input
    {
      spriteData = cursortext,
      offset = {
        x = -2,
        y = -3
      }
    },

    -- Help (for showing tool tips)
    {
      spriteData = cursorhelp,
      offset = {
        x = -2,
        y = -3
      }
    },
    -- Wait
    {
      spriteData = cursorwait,
      offset = {
        x = -2,
        y = -3
      }
    },
    -- Pencil
    {
      spriteData = cursordraw,
      offset = {
        x = -2,
        y = -3
      }
    },
    -- Eraser
    {
      spriteData = cursorerase,
      offset = {
        x = -2,
        y = -3
      }
    }
  }

  _mouseCursor.pos = {x = -1, y = -1}

  -- Return the new instance of the editor ui
  return _mouseCursor

end

function MouseCursor:Update(timeDelta, collisionState)

  -- Get the collision state's mouse cursor values
  --self.cursorID = collisionState.cursorID

  -- save the current mouse position
  self.pos.x = collisionState.mousePos.x
  self.pos.y = collisionState.mousePos.y

end

function MouseCursor:Draw()

  -- Need to make sure the mouse is not off screen before drawing it
  if(self.pos.x < 0 or self.pos.y < 0) then
    return
  end

  -- get the current sprite data for the current cursor
  local cursorData = self.cursors[self.cursorID]

  -- Make sure the data isn't undefined
  if(cursorData ~= nil) then

    local spriteData = cursorData.spriteData

    if(spriteData ~= nil) then

      -- Draw the new cursor taking into account the cursors offset
      DrawSprites(cursorData.spriteData.spriteIDs, self.pos.x + cursorData.offset.x, self.pos.y + cursorData.offset.y, spriteData.width, false, false, DrawMode.Sprite, 0, true, false)

    end

  end

end
