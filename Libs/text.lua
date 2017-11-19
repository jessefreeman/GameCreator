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

function EditorUI:CreateText(rect, text, font, colorOffset, spacing, drawMode)

  local data = self:CreateData(-1, rect)

  data.font = font or "default"
  data.colorOffset = colorOffset or 0
  data.spacing = spacing or 0
  data.drawMode = DrawMode.TilemapCache

  data.drawArguments = {
    "", -- text (1)
    data.rect.x, -- x (2)
    data.rect.y, -- y (3)
    data.drawMode, -- drawMode (4)
    data.font, -- font (5)
    data.colorOffset, -- colorOffset (6)
    data.spacing, -- spacing (7)
    data.tiles.w -- width (8)
  }

  -- After the component's data is set, update the text
  self:ChangeText(data, text)

  return data

end

function EditorUI:UpdateText(data)

  -- Exit out of update if there is nothing to update
  if(data == nil) then
    return
  end

  -- Test to see if we should draw the component
  if(data.invalid == true or DrawMode.Sprite == true) then
    -- Push a draw call into the UI's draw queue
    self:NewDraw("DrawText", data.drawArguments)

    if(data.invalid == true) then
      -- We only want to reset the validation if it's invalid since sprite text will keep drawing
      self:ResetValidation(data)

    end
  end

end

function EditorUI:ChangeText(data, text)

  -- If the text is the same, don't update the text component and exit out of the method
  if(data.drawArguments[1] == text) then
    return
  end

  self:Invalidate(data)

  -- Save the text on the draw arguments
  data.drawArguments[1] = text

  -- Make sure we have the correct position for the draw
  if(data.drawMode == DrawMode.Tile) then
    data.drawArguments[2] = data.tiles.c
    data.drawArguments[3] = data.tiles.r
  else
    data.drawArguments[2] = data.rect.x
    data.drawArguments[3] = data.rect.y
  end

end
