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

CollisionManager = {}
CollisionManager.__index = CollisionManager

function CollisionManager:Init()

  -- Create a new object for the instance and register it
  local manager = {}
  setmetatable(manager, CollisionManager)

  -- Get a reference to the sprite size on startup
  manager.spriteSize = SpriteSize()
  manager.currentFocus = nil

  -- Current state
  manager.active = nil
  manager.hovered = nil
  manager.mousePos = {x = -1, y = -1, c = -1, r = -1}
  manager.mouseDown = false
  manager.mouseReleased = false

  -- This defines which set of data to use when drawing the cursor
  -- manager.cursorID = 1

  -- Past state
  manager.lastHovered = nil
  manager.lastActive = nil
  manager.lastMousePos = {x = -1, y = -1, c = -1, r = -1}
  manager.lastMouseDown = false

  manager.scrollPos = {x = 0, y = 0}
  manager.ignoreScrollPos = false

  -- Hold a string for a tool tip. Read by the editor ui component
  manager.toolTip = nil
  manager.overrideMessage = false

  -- manager.focus = nil

  return manager

end

function CollisionManager:Update(timeDelta)

  -- Copy current values over to old state
  self.lastHovered = self.hovered
  self.lastActive = self.active
  self.lastMousePos = self.mousePos

  -- Clear any tool tip
  self.toolTip = nil
  self.overrideMessage = false

  -- Update the current mouse position and button state
  local mousePointer = MousePosition()

  self.mousePos.x = mousePointer.x
  self.mousePos.y = mousePointer.y

  -- Before clearing hover, test to see if the mouse is still down
  self.mouseDown = MouseButton(0, InputState.Down)

  -- If the mouse is down, don't update the collision state while it moves
  if(self.mouseDown == true and self.lastMouseDown == true) then

    -- Mouse is down and has focus on an object so exit out of the update
    return

  elseif(self.mouseDown == false and self.lastMouseDown == true) then

    -- Mouse has been released
    self.mouseReleased = true

    -- -- Test to see if a UI element is in focus
    -- if(self.focus ~= nil) then
    --
    --   print("Remove focus")
    --
    --   -- Remove focus and clear focus object
    --   self.focus.inFocus = false
    --   self.focus = nil
    --
    -- end

  end

  -- Clear current values
  self:ClearHovered()

  -- Calculate what flag the mouse is under
  self.hovered = self:CalculateFlag()

  -- look to see if the mouse is over an interactive object
  -- if(self.hovered > - 1) then
  --   -- Set the mouse to the hand by default
  --   self:ChangeCursor(2)
  -- end

  -- If the mouse is down, set the hovered id to active
  if(self.mouseReleased == true and self.hovered == self.lastHovered) then
    -- Only change the active value if we are still on the same object the mouse started on
    self.active = self.hovered
  end

  -- Save the current value of the mouse down for the next frame
  self.lastMouseDown = self.mouseDown
  self.mouseReleased = false

end

function CollisionManager:ClearHovered()

  -- If no collision was detected, set the hovered and active state to -1
  self.hovered = -1
  self.active = -1

  -- Also need to manually reset the mouse cursor since it's not over anything
  -- self.cursorID = 1

end

-- -- TODO need to remove this
-- function CollisionManager:ChangeCursor(id)
--   -- self.cursorID = id
-- end

function CollisionManager:CalculateFlag()

  -- local mousePointer = MousePosition()
  --
  -- self.mousePos.x = mousePointer.x
  -- self.mousePos.y = mousePointer.y

  if(self.ignoreScrollPos == false) then

    -- Update scroll position
    self.scrollPos = ScrollPosition()

    -- Update mouse x and y position
    self.mousePos.x = self.mousePos.x + self.scrollPos.x
    self.mousePos.y = self.mousePos.y + self.scrollPos.y

  end

  -- Calculate the current mouse column
  self.mousePos.c = math.floor(self.mousePos.x / self.spriteSize.x)

  -- Calculate the current mouse row
  self.mousePos.r = math.floor(self.mousePos.y / self.spriteSize.y)

  -- Return the flag under the mouse
  return Flag(self.mousePos.c, self.mousePos.r)

end

function CollisionManager:MouseInRect(rect)
  -- Test for collision in a rect {x,y,w,h}
  return self.mousePos.x >= rect.x and self.mousePos.y >= rect.y and
  self.mousePos.x < (rect.x + rect.w) and self.mousePos.y < (rect.y + rect.h)
end
