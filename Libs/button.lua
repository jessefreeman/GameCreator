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

function EditorUI:CreateButton(flag, rect, spriteName, toolTip, forceDraw)

  -- Create the button's default data
  local data = self:CreateData(flag, rect, spriteName, toolTip, forceDraw)

  data.doubleClick = false
  data.doubleClickTime = 0
  data.doubleClickDelay = .35

  -- Customize the default name by adding Button to it
  data.name = "Button" .. data.name
  data.onClick = function(tmpData)

    self:ClickButton(tmpData, true, tmpData.doubleClickTime < tmpData.doubleClickDelay)

    tmpData.doubleClickTime = 0

    -- self:ClickButton(tmpData)
  end
  -- Make sure the button correctly sizes itself based on the cached sprite data
  self:UpdateButtonSizeFromCache(data)

  return data

end

function EditorUI:UpdateButtonSizeFromCache(data)
  local spriteData = nil

  -- Get the default sprite data for the button
  if(data.cachedSpriteData ~= nil) then

    spriteData = data.cachedSpriteData.up or data.cachedSpriteData.disabled

  end

  -- Calculate rect and hit rect
  if(spriteData ~= nil) then

    -- Update the UI tile width and height
    data.tiles.w = spriteData.width
    data.tiles.h = math.floor(#spriteData.spriteIDs / spriteData.width)

    -- Update the rect width and height with the new sprite size
    data.rect.w = data.tiles.w * self.spriteSize.x
    data.rect.h = data.tiles.h * self.spriteSize.y

    -- Cache the tile draw arguments for rendering
    data.spriteDrawArgs = {spriteData.spriteIDs, 0, 0, spriteData.width, false, false, DrawMode.Sprite, 0, false}
    data.tileDrawArgs = {spriteData.spriteIDs, data.tiles.c, data.tiles.r, spriteData.width, DrawMode.Tile, 0}--{0, 0, spriteData.width, spriteData.spriteIDs, 0, data.flagID}

    self:SetUIFlags(data.tiles.c, data.tiles.r, data.tiles.w, data.tiles.h, data.flagID)

  end

end

function EditorUI:UpdateButton(data, hitRect)

  -- Make sure we have data to work with and the component isn't disabled, if not return out of the update method
  if(data == nil) then
    return
  end

  -- If the button has data but it's not enabled exit out of the update
  if(data.enabled == false) then

    -- If the button is disabled but still in focus we need to remove focus
    if(data.inFocus == true) then
      self:ClearFocus(data)
    end

    -- See if the button needs to be redrawn.
    self:RedrawButton(data)

    -- Shouldn't update the button if its disabled
    return

  end

  -- Make sure we don't detect a collision if the mouse is down but not over this button
  if(self.collisionManager.mouseDown and data.inFocus == false) then
    -- See if the button needs to be redrawn.
    self:RedrawButton(data)
    return
  end

  -- Do the first test to see if we are in the right area to detect a collision
  if(self.collisionManager.hovered == data.flagID) then

    -- If the hit rect hasn't been overridden, then use the buttons own hit rect
    if(hitRect == nil) then
      hitRect = data.hitRect or data.rect
    end

    local overrideFocus = (data.inFocus == true and self.collisionManager.mouseDown)

    -- Ready to test finer collision if needed
    if(self.collisionManager:MouseInRect(hitRect) == true or overrideFocus) then

      if(data.doubleClick == true) then


        -- If the button wasn't in focus before, reset the timer since it's about to get focus
        if(data.inFocus == false) then
          data.doubleClickTime = 0
        end

        data.doubleClickTime = data.doubleClickTime + self.timeDelta

      end

      -- If we are in the collision area, set the focus
      self:SetFocus(data)

      -- calculate the correct button over state
      local state = "over"

      if(data.selected == true) then
        state = "selected" .. state
      end

      local spriteData = data.cachedSpriteData[state]

      if(spriteData ~= nil and data.spriteDrawArgs ~= nil) then

        -- Sprite Data
        data.spriteDrawArgs[1] = spriteData.spriteIDs

        -- X pos
        data.spriteDrawArgs[2] = data.rect.x

        -- Y pos
        data.spriteDrawArgs[3] = data.rect.y

        -- Color Offset
        data.spriteDrawArgs[8] = spriteData.colorOffset or 0

        self:NewDraw("DrawSprites", data.spriteDrawArgs)

      end

      -- Check to see if the button is pressed and has an onAction callback
      if(self.collisionManager.active == data.flagID) then

        -- Click the button
        data.onClick(data)
        -- end

      end

    else

      -- If we are not in the button's rect, clear the focus
      self:ClearFocus(data)

    end

  else

    -- If the mouse is not over the button, clear the focus for this button
    self:ClearFocus(data)

  end

  -- Make sure we don't need to redraw the button.
  self:RedrawButton(data)

end

function EditorUI:RedrawButton(data)

  if(data == nil) then
    return
  end

  -- If the button changes state we need to redraw it to the tilemap
  if(data.invalid == true) then

    -- The default state is up
    local state = "up"

    -- If the button is selected, we will use the selected up state
    if(data.selected == true) then
      state = "selected" .. state
    end

    -- Test to see if the button is disabled. If there is a disabled sprite data, we'll change the state to disabled. By default, always use the up state.
    if(data.enabled == false and data.cachedSpriteData["disabled"] ~= nil and data.selected ~= true) then --_G[spriteName .. "disabled"] ~= nil) then
      state = "disabled"

    end

    -- Test to see if the sprite data exist before updating the tiles
    if(data.cachedSpriteData[state] ~= nil and data.tileDrawArgs ~= nil) then

      -- Update the tile draw arguments
      data.tileDrawArgs[1] = data.cachedSpriteData[state].spriteIDs

      -- Color offset
      data.tileDrawArgs[6] = data.cachedSpriteData[state].colorOffset or 0

      self:NewDraw("DrawTiles", data.tileDrawArgs)

    end

    self:ResetValidation(data)

  end

end

-- TODO make sure this still works

function EditorUI:ClearButton(data, flag)

  -- We want to clear the flag if no value is supplied
  flag = flag or - 1

  -- Get the cached empty sprite data
  local spriteData = data.cachedSpriteData["empty"]

  print("Clear Button")

  -- make sure we have sprite data to draw
  if(spriteData ~= nil) then

    -- Get the correct color offset
    -- local colorOffset = spriteData.colorOffset or 0
    -- print("Erase Button", button.name)

    -- Update the tile draw arguments
    data.tileDrawArgs[1] = spriteData.spriteIDs

    -- Color offset
    data.tileDrawArgs[6] = spriteData.colorOffset or 0

    self:NewDraw("DrawTiles", data.tileDrawArgs)

    self:SetUIFlags(data.tiles.c, data.tiles.r, data.tiles.w, data.tiles.h, flag)

    -- TODO need to use the tile position not recalculate it
    -- Draw the tiles to the background
    -- local args = {math.floor((data.rect.x) / self.spriteSize.x), math.floor((data.rect.y) / self.spriteSize.y), spriteData.width, spriteData.spriteIDs, colorOffset, flag}
    --
    -- self:NewDraw("UpdateTiles", args)

    -- local args = {,, spriteData.spriteIDs, colorOffset, flag}

    -- local x = math.floor((data.rect.x) / self.spriteSize.x)
    -- local y = math.floor((data.rect.y) / self.spriteSize.y)
    -- local args = {spriteData.spriteIDs, data.tiles.c, data.tiles.r, total, DrawMode.Sprite, colorOffset}
    --
    -- self:NewDraw("DrawTiles", args)

    -- Update the flag
    -- Flag(data.tiles.c, data.tiles.r, flag)

  end

end

-- Use this to perform a click action on a button. It's used internally when a mouse click is detected.
function EditorUI:ClickButton(data, callAction, doubleClick)

  if(data.onAction ~= nil and callAction ~= false) then

    -- Trigger the onAction call back and pass in the double click value if the button is set up to use it
    data.onAction(doubleClick)

  end

end

function EditorUI:SelectButton(data, value)
  data.selected = value
  self:Invalidate(data)
end
