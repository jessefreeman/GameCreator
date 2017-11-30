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

function EditorUI:CreateSlider(flag, rect, spriteName, toolTip, horizontal)

  -- Create a generic component data object
  local data = self:CreateData(flag, rect, spriteName, toolTip, forceDraw)

  -- Add the name of the component type to the default data name value
  data.name = "Slider" .. data.name

  -- Configure extra data properties needed to run the slider component
  data.horizontal = horizontal
  data.size = horizontal and rect.w or rect.h
  data.value = 0
  data.handleX = 0
  data.handleY = 0
  data.handleSize = 0

  -- This is applied to the top when horizontal and the left when vertical
  data.offset = -4

  -- Calculate the handle's size based on the sprite
  local spriteData = data.cachedSpriteData.up

  -- If there is a sprite calculate the handle size
  if(spriteData ~= nil) then
    -- Determine if the slider is horizontal or vertical and use the correct sprite dimensions
    if(horizontal == true) then
      data.handleSize = spriteData.width * self.spriteSize.x
    else
      data.handleSize = math.floor(#spriteData.spriteIDs / spriteData.width) * self.spriteSize.y
    end

    data.spriteDrawArgs = {spriteData.spriteIDs, 0, 0, spriteData.width, false, false, DrawMode.Sprite, 0, false}

  end
  -- Need to account for the correct orientation
  data.handleCenter = data.handleSize / 2

  -- Make sure that the tilemap has the correct flag values

  -- self:SetUIFlags(data.tiles.c, data.tiles.r, data.tiles.w, data.tiles.h, data.flagID)

  -- Return the data
  return data

end

function EditorUI:UpdateSlider(data)

  -- Make sure we have data to work with and the component isn't disabled, if not return out of the update method
  if(data == nil or data.enabled == false) then
    return
  end

  local size = data.size - data.handleSize

  local overrideFocus = (data.inFocus == true and self.collisionManager.mouseDown)

  -- Ready to test finer collision if needed
  if(self.collisionManager:MouseInRect(data.rect) == true or overrideFocus) then

    -- TODO need to fix focus when you have the mouse down from another UI element and roll over a slider
    -- Set focus
    self:SetFocus(data)

    -- Check to see if the mouse is down to update the handle position
    if(self.collisionManager.mouseDown == true) then

      -- Calculate the position
      local dir = data.horizontal and "x" or "y"
      local prop = "handle" .. string.upper(dir)

      -- Need to calculate the new x position
      local newPos = self.collisionManager.mousePos[dir] - data.handleCenter

      -- Make sure the position is in range
      if(newPos > size + data.rect[dir]) then
        newPos = size + data.rect[dir]
      elseif(newPos < data.rect[dir]) then
        newPos = data.rect[dir]
      end

      -- Save the new position
      data[prop] = newPos

      -- Need to calculate the value
      local percent = math.ceil(((data[prop] - data.rect[dir]) / size) * 100) / 100


      self:ChangeSlider(data, percent)

    end

  else

    -- If the mouse is not in the rect, clear the focus
    if(data.inFocus == true) then
      self:ClearFocus(data)
    end

  end

  -- else
  --
  --   -- If the mouse isn't over the component clear the focus
  --   self:ClearFocus(data)
  --
  --   -- If the component has changes and the mouse isn't over it, update the handle
  if(data.invalid == true) then

    -- If the mouse isn't on the slider, make sure it's position is correct
    data.handleX = data.rect.x
    data.handleY = data.rect.y

    if(data.horizontal == true) then
      data.handleX = data.handleX + (data.value * size)
      data.handleY = data.handleY + data.offset
    else
      data.handleX = data.handleX + data.offset
      data.handleY = data.handleY + (data.value * size)

    end

    -- Clear the validation
    self:ResetValidation(data)

  end
  --
  -- end

  -- Update the handle sprites
  local spriteData = data.enabled == true and data.cachedSpriteData.up or data.cachedSpriteData.disabled

  -- If the slider has focus, show the over state
  if(data.inFocus == true) then
    spriteData = data.cachedSpriteData.over
  end

  -- Make sure we have sprite data to render
  if(spriteData ~= nil and data.spriteDrawArgs ~= nil) then

    -- Update the draw arguments for the sprite

    -- Sprite Data
    data.spriteDrawArgs[1] = spriteData.spriteIDs

    -- X pos
    data.spriteDrawArgs[2] = data.handleX

    -- Y pos
    data.spriteDrawArgs[3] = data.handleY

    -- Color Offset
    data.spriteDrawArgs[8] = spriteData.colorOffset or 0

    self:NewDraw("DrawSprites", data.spriteDrawArgs)

  end

  -- Return the slider data value
  return data.value

end

function EditorUI:ChangeSlider(data, percent, trigger)

  -- If there is no data or the value is the same as what's being passed in, don't update the component
  if(data == nil or data.value == percent) then
    return
  end

  -- Set the new value
  data.value = percent

  -- TODO shouldn't this be onUpdate?
  if(data.onAction ~= nil and trigger ~= false) then
    data.onAction(percent)
  end

  -- Invalidate the component's display
  self:Invalidate(data)

end
