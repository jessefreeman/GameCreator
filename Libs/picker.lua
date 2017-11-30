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

function EditorUI:CreatePicker(flag, rect, itemWidth, itemHeight, total, spriteName, toolTip)

  local data = self:CreateData(flag, rect, nil, toolTip, forceDraw)

  -- data.w = width
  data.columns = math.floor(data.rect.w / itemWidth)
  data.rows = math.floor(total / itemHeight)
  data.total = total
  data.itemWidth = itemWidth
  data.itemHeight = itemHeight
  -- data.spriteName = spriteName
  data.toolTip = toolTip
  data.hoverIndex = -1
  data.selected = -1
  data.overIndex = -1
  -- TODO need to use the sprite cache instead

  local selectedSpriteData = _G[spriteName .. "selected"]

  if(selectedSpriteData ~= nil) then
    data.selectedDrawArgs = {selectedSpriteData.spriteIDs, 0, 0, selectedSpriteData.width}
  end

  selectedSpriteData = _G[spriteName .. "over"]

  if(selectedSpriteData ~= nil) then
    data.overDrawArgs = {selectedSpriteData.spriteIDs, 0, 0, selectedSpriteData.width}
  end

  return data

end

function EditorUI:UpdatePicker(data)

  local overrideFocus = (data.inFocus == true and self.collisionManager.mouseDown)

  -- Ready to test finer collision if needed
  if(self.collisionManager:MouseInRect(data.rect) == true) then

    data.tmpX = math.floor((self.collisionManager.mousePos.x - data.rect.x) / data.itemWidth)
    data.tmpY = math.floor((self.collisionManager.mousePos.y - data.rect.y) / data.itemHeight)

    local index = math.index(data.tmpX, data.tmpY, data.columns)



    if(index == data.selected or index > data.total) then

      data.overIndex = -1

      if(data.inFocus == true) then

        data.overIndex = -1

        -- If we are not in the button's rect, clear the focus
        self:ClearFocus(data)

      end

    else

      -- data.hoverPos.x = math.floor((self.collisionManager.mousePos.x - data.x) / data.itemWidth) * data.itemWidth
      -- data.hoverPos.y = math.floor((self.collisionManager.mousePos.y - data.y) / data.itemHeight) * data.itemHeight

      -- If we are in the collision area, set the focus
      self:SetFocus(data)

      data.overIndex = index

      -- update over sprite position


      if(self.collisionManager.mouseReleased == true) then
        self:PickerSelect(data, index)
      end
    end


  else

    if(data.inFocus == true) then

      data.overIndex = -1

      -- If we are not in the button's rect, clear the focus
      self:ClearFocus(data)

    end

  end

  self:RedrawPicker(data)


  -- if(self.collisionManager.hovered ~= data.flagID) then
  --
  --
  --   if(data.inFocus == true) then
  --     self:ClearFocus(data)
  --   end
  --
  --   -- return
  -- else

  -- TODO we only want to do this if the mouse is inside of the bounds of the Picker


  -- end

  -- push the sprites into the draw queue


end

function EditorUI:RedrawPicker(data)

  if(data.overIndex > - 1) then
    data.overDrawArgs[2] = (data.tmpX * data.itemWidth) + data.rect.x
    data.overDrawArgs[3] = (data.tmpY * data.itemHeight) + data.rect.y
    self:NewDraw("DrawSprites", data.overDrawArgs)

    -- Reset the over index for the next frame
    data.overIndex = -1
  end

  if(data.selectedDrawArgs ~= nil) then

    self:NewDraw("DrawSprites", data.selectedDrawArgs)

  end
end

function EditorUI:PickerSelect(data, value, triggerAction)

  -- Set the new value
  data.selected = value

  -- Update the sprite position
  if(data.selectedDrawArgs) then

    -- Calculate the x and y position of the selected tile
    local tmpX, tmpY = math.pos(data.selected, data.columns)

    -- Update the selected draw arguments with the new position
    data.selectedDrawArgs[2] = (tmpX * data.itemWidth) + data.rect.x
    data.selectedDrawArgs[3] = (tmpY * data.itemHeight) + data.rect.y

  end

  -- if trigger action is not false and one exists, call it
  if(data.onAction ~= nil and triggerAction ~= false) then
    data.onAction(value)
  end

end
