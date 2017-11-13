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

function EditorUI:CreateInputArea(flag, rect, text, toolTip, pattern, font, forceDraw, maxChars, maxLines)

  -- TODO need to calculate the lines from the height



  local data = self:CreateData(flag, rect, spriteName, toolTip, forceDraw)

  data.name = "InputArea" .. data.name

  data.width = data.tiles.w
  data.height = data.tiles.h
  -- data.width = width
  -- data.height = height
  data.text = ""
  data.font = font or "input"
  data.maxChars = maxChars
  data.maxLines = maxLines
  -- invalid = forceDraw or true,
  data.drawMode = DrawMode.Tile
  data.colorOffset = 0
  data.disabledColorOffset = 0
  data.spacing = 0
  data.editing = false
  data.onValidate = nil
  -- data.scrollFirst = 0
  -- data.toolTip = toolTip
  data.onAction = nil
  data.cursor = {c = 0, r = 0}
  data.scrollValue = {h = 0, v = 0}
  data.blinkTime = 0
  data.blinkDelay = .4
  data.blink = false
  data.blinkChar = "_"
  data.wrap = true
  data.lines = {}
  data.totalLines = 0
  data.currentLine = 1
  data.maxLineWidth = 0
  data.tabChar = "  "
  data.scrollLeft = 0
  data.scrollRight = 0
  data.scrollFirst = 0
  data.scrollLast = 0
  data.multiline = true
  data.keys = {
    BackspaceKey = 8,
    ReturnKey = 10, -- This is technically 13 in Unity but 10 in ASCII?
    EscapeKey = 27,
    UpKey = 273,
    DownKey = 274,
    RightKey = 275,
    LeftKey = 276,
    ArrowKey = 63,
    TabKey = 9
  }
  data.pattern = pattern
  data.patterns = {
    hex = '%x',
    number = '%d',
    file = '[_%-%w]',
    keys = '%a'
  }

  -- Set up the draw arguments
  data.drawArguments = {
    "",
    0,
    0,
    data.drawMode,
    data.font,
    data.colorOffset,
    data.spacing
  }

  data.cursorDrawArguments = {
    data.blinkChar,
    0,
    0,
    DrawMode.Sprite,
    data.font,
    data.colorOffset,
    data.spacing
  }

  -- Create input callbacks. These can be overridden to add special functionality to each input field
  data.captureInput = function()
    return InputString()
  end

  data.onBackspace = function(data)
    self:InputAreaDeleteChar(data)
  end

  data.onTab = function(data)
    self:InputAreaInsertChar(data, data.tabChar)
  end

  data.onUpArrow = function(data)
    self:InputAreaMoveCursorInDirection(data, 0, - 1)
  end

  data.onRightArrow = function(data)
    self:InputAreaMoveCursorInDirection(data, 1, 0)
  end

  data.onDownArrow = function(data)
    self:InputAreaMoveCursorInDirection(data, 0, 1)
  end

  data.onLeftArrow = function(data)
    self:InputAreaMoveCursorInDirection(data, - 1, 0)
  end

  data.onReturn = function(data)
    self:InputAreaInsertNewLine(data)

    self:InputAreaMoveCursorTo(data, 0, data.cursor.r + 1)
  end

  data.onInsertChar = function(data, char)
    self:InputAreaInsertChar(data, char)
  end

  -- }

  if(text ~= nil) then
    self:ChangeInputArea(data, text)
  end

  --data.rect = {x = data.x, y = data.y, w = (data.width * self.spriteSize.x), h = (data.height * self.spriteSize.y)}

  self:SetUIFlags(data.tiles.c, data.tiles.r, data.tiles.w, data.tiles.h, data.flagID)

  -- Make sure that the correct scroll values are calculated
  self:InputAreaMoveCursorTo(data, 0, 0)

  return data

end


function EditorUI:UpdateInputArea(data)

  if(data == nil) then
    return
  end

  -- Do the first test to see if we are in the right area to detect a collision
  if(self.collisionManager.hovered == data.flagID) then

    -- print("Inside Text", data.name)
    -- Ready to test finer collision if needed
    if(self.collisionManager:MouseInRect(data.rect) == true or data.inFocus == true) then

      -- Set focus
      self:SetFocus(data)

      self.cursorID = 3

      if(self.collisionManager.active == data.flagID and data.editing == false) then

        print("Click to edit")
        self:InputAreaMoveCursorToMousePos(data)

        -- Enter edit mode
        self:EditInputArea(data, true)

      end

    else

      -- If the mouse is not in the rect, clear the focus
      self:ClearFocus(data)

    end

  else
    -- If the mouse isn't over the component clear the focus
    self:ClearFocus(data)

  end


  if(data.editing == true) then

    local lastInput = data.captureInput()

    if(lastInput ~= "") then

      self:InputAreaOnInput(data, lastInput)

    end

    -- if we are in edit mode, we need to update the cursor blink time
    data.blinkTime = data.blinkTime + self.timeDelta

    if(data.blinkTime > data.blinkDelay) then
      data.blinkTime = 0
      data.blink = not data.blink

      --print("Blink")
    end

    -- TODO need to add in logic to support dragging, selection, etc.

    -- While in edit mode, check to see if the mouse is pressed
    if(MouseButton(0, InputState.Released)) then

      -- Check to see if the mouse is outside of the text area
      if(self.collisionManager.hovered ~= data.flagID) then

        -- Exit edit mode
        self:EditInputArea(data, false)

        -- If the mouse is still inside of the input area
      else

        -- Update the mouse cursor
        self:InputAreaMoveCursorToMousePos(data)

      end

    end



  end

end


function EditorUI:InputAreaOnInput(data, value)

  for i = 1, #value do

    local char = value:sub(i, i)
    local ascii = string.byte(char)

    --print("input", "'"..char.."'", ascii)

    if(ascii == data.keys.BackspaceKey) then

      if(data.onBackspace ~= nil) then
        data.onBackspace(data)
      end

      -- self:InputAreaDeleteChar(data)

    elseif(ascii == data.keys.TabKey) then

      if(data.onTab ~= nil) then
        data.onTab(data)
      end

    elseif(ascii == data.keys.ArrowKey) then

      -- Unity passes in ASCII 63 for arrow keys so we need to test the actual key down to figure out what it really is
      if(Key(data.keys.UpKey)) then

        if(data.onUpArrow ~= nil) then
          data.onUpArrow(data)
        end

      elseif(Key(data.keys.DownKey)) then

        if(data.onDownArrow ~= nil) then
          data.onDownArrow(data)
        end

      elseif(Key(data.keys.RightKey)) then

        if(data.onRightArrow ~= nil) then
          data.onRightArrow(data)
        end

      elseif(Key(data.keys.LeftKey)) then

        if(data.onLeftArrow ~= nil) then
          data.onLeftArrow(data)
        end

      else
        -- If we can't capture this special key, send it to the insert char method
        --self:InputAreaInsertChar(data, char)
      end

    elseif(ascii == data.keys.ReturnKey) then

      if(data.onReturn ~= nil) then
        data.onReturn(data)
      end

      -- self:InputAreaInsertNewLine(data)
      --
      -- self:InputAreaMoveCursorTo(data, 0, data.cursor.r + 1)

    else
      if(data.onInsertChar ~= nil) then
        data.onInsertChar(data, char)
      end

    end

  end

  self:InputAreaInvalidateText(data)

end

function EditorUI:InputAreaInsertNewLine(data, r, value)

  -- if no r is present, get the current cursor's r position
  r = r or data.cursor.r

  -- get the current cursor position
  c = data.cursor.c

  -- get the current line
  local line = data.lines[r]

  if(c > 0 or c < #line) then
    data.lines[r] = line:sub(0, c)
  else
    data.lines[r] = ""
    c = c + 1
  end

  -- set the value to what is passed in or the text after the cursor on the current line
  value = value or line:sub(c + 1, #line)

  -- Move to the next line
  r = r + 1

  -- Add the new value to the lines table
  table.insert(data.lines, r, value)

  -- Update the max line width value
  data.maxLineWidth = math.max(#value, data.maxLineWidth)

  -- Update the total lines
  data.totalLines = #data.lines

  --print("New Line At", r, "'"..value.."'", data.totalLines)

  -- Invalidate the component
  self:Invalidate(data)

  -- Invalidate the text since it has changed
  self:InputAreaInvalidateText(data)

end

function EditorUI:InputAreaInsertChar(data, value)

  -- Get the current position
  local line, c, r = self:InputAreaCurrentLine(data)

  -- If there is no line data, don't edit
  if(line == nil) then
    return
  end

  local pre = line == "" and "" or line:sub(0, c)
  local post = line:sub(c + 1, #line)

  -- Add the new value to the current line
  data.lines[r] = pre .. value .. post

  -- Make sure we update the max line width
  data.maxLineWidth = math.max(#data.lines[r], data.maxLineWidth)

  -- Move cursor to the right
  self:InputAreaMoveCursorInDirection(data, 1, 0)

  --print("Max Widt", data.maxLineWidth, data.scrollFirst, data.scrollLast)

  -- force the input area to redraw itself
  self:Invalidate(data)

  -- Invalidate the text since it has changed
  self:InputAreaInvalidateText(data)

end

function EditorUI:InputAreaDeleteChar(data)

  -- Get the current position
  local line, c, r = self:InputAreaCurrentLine(data)

  -- Check to see if we are at the beginning of the line
  if(c < 1) then
    --print("Beginning of line")

    -- make sure we are not on the first line
    if(r > 1)then

      -- remove the current line
      table.remove(data.lines, r)
      r = r - 1
      local prevLine = data.lines[r]

      data.lines[r] = prevLine .. line

      self:InputAreaMoveCursorTo(data, #prevLine, r)

      data.totalLines = #data.lines

    end

  else
    data.lines[r] = line:sub(0, c - 1) ..line:sub(c + 1)
    -- Move cursor to the left
    self:InputAreaMoveCursorInDirection(data, - 1, 0)
  end

  -- force the input area to redraw itself
  self:Invalidate(data)

end

function EditorUI:InputAreaCurrentLine(data)

  local line = data.lines[data.cursor.r]

  return line, data.cursor.c, data.cursor.r

end

-- This helper method allows you to move the cursor in a specific direction from it's current location
function EditorUI:InputAreaMoveCursorInDirection(data, dX, dY)

  -- TODO doesn't look like the cursor do to the end of the line

  local line, c, r = self:InputAreaCurrentLine(data)

  c = c + dX
  r = r + dY

  -- If the cursor is moving left from the first character, ignore the movement
  if(r <= 1 and c < 0) then
    return
  elseif(r >= data.totalLines and c > #data.lines[data.totalLines]) then
    return
  end

  -- We need to figure out the width of the current line or set it to 0 if no line is selected
  local lineWidth = line ~= nil and #line or 0

  -- Look to see if the cursor is off the left side of the screen
  if(c < 0) then

    -- Set the c value to the end of the line. Will be clamped to the current line after
    c = data.maxLineWidth + 1

    -- Move the cursor up a line
    r = r - 1

    -- Test to see if the cursor is past the width of the current line
  elseif(c > lineWidth) then

    c = 0

    r = r + 1

  end

  -- Update the scroll position

  self:InputAreaMoveCursorTo(data, c, r)



end

-- This method allows you to move the cursor to a specific position and will update scrolling as well
function EditorUI:InputAreaMoveCursorTo(data, c, r)

  -- Since you can only select a valid row, we make sure its within range first

  -- Find the correct row within the bounds
  r = Clamp(r, 1, data.totalLines)

  -- Get the current row which we need to figure out what column to put the cursor in
  local line = data.lines[r]

  --print("Cursor Line", tostring(line))
  -- We need to figure out the width of the current line or set it to 0 if no line is selected
  local lineWidth = line ~= nil and #line or 0

  -- Find the correct column within the bounds
  c = Clamp(c, 0, lineWidth)


  -- Update the cursor position
  data.cursor.c = c
  data.cursor.r = r

  self:CalculateCursorScrollPosition(data)

  -- Invalidate the component so it redraws
  self:Invalidate(data)

end

function EditorUI:CalculateCursorScrollPosition(data)

  local c = data.cursor.c
  local r = data.cursor.r

  if(c < data.scrollLeft) then

    data.scrollLeft = c
    data.scrollRight = data.scrollLeft + data.width

  elseif(c > data.scrollRight) then

    data.scrollRight = c + 1
    data.scrollLeft = data.scrollRight - data.width + 1

  end

  -- Check to see if we need to scroll up or down
  if(r < data.scrollFirst and data.scrollFirst > 0) then

    -- Scroll up but not past the first line
    data.scrollFirst = r
    data.scrollLast = data.scrollFirst + data.height - 1

  elseif(r > data.scrollLast and data.scrollLast < data.totalLines) then
    -- Scroll down but not past the last line
    data.scrollLast = r + 1
    data.scrollFirst = data.scrollLast - data.height + 1

  end

  -- Update the scroll position based on the cursor
  local v = math.round((data.scrollFirst - 1) / (data.totalLines - data.height), 2)

  if(v < 0) then
    v = 0
  elseif(v > 1) then
    v = 1
  end

  data.scrollValue.v = v

  local h = math.round(data.scrollLeft / (data.maxLineWidth + 1 - data.width), 2) -- scrollLeft starts at 0 so we need to add 1 to the total

  if(h < 0) then
    h = 0
  elseif(h > 1) then
    h = 1
  end

  data.scrollValue.h = h

  self:InputAreaScrollTo(data, h, v)

end

function EditorUI:InputAreaMoveCursorToMousePos(data)

  local mC = (self.collisionManager.mousePos.c - data.tiles.c) + data.scrollLeft
  local mR = (self.collisionManager.mousePos.r - data.tiles.r) + data.scrollFirst

  -- If the mouse is below the last line, just force the cursor to go to the last column
  if(mR > data.totalLines) then
    mC = data.maxLineWidth
  end
  -- Calculate the mouse position and move the cursor there
  self:InputAreaMoveCursorTo(data, mC, mR )

end

function EditorUI:GetTextAtCursor(data)

  local realCol = data.cursor.c
  local realRow = data.cursor.r

  local line = data.lines[realRow]

  return line--:sub(realCol - 1, 1)

end

function EditorUI:EditInputArea(data, value)


  --TODO need to make sure all input fields are tied to the same focus logic so you can stop editing them at the same time

  -- Need to make sure we are not currently editing another field
  if(value == true) then

    -- Look to see if a field is being edited
    if(self.editingField ~= nil) then

      -- Exit field's edit mode
      self:EditInputArea(self.editingField, false)

    end

    -- Set new field to edit mode
    self.editingField = data

  else
    self.editingField = nil
  end

  -- change the edit mode to the new value
  data.editing = value

  -- Force the text field to redraw itself
  self:Invalidate(data)

  -- If editing mode is false, shut it down
  if(data.editing == false) then

    -- turn off blink
    data.blink = false

    --
    -- -- If there is new data, show the data
    -- if(data.editingText ~= "" and data.editingText ~= data.text) then
    --   self:ChangeInputField(data, data.editingText)
    -- end

  else
    -- Reset the cursor values
    data.blinkTime = 0
    data.blink = true

    -- Update the cursor position to where the mouse just clicked
    self:InputAreaMoveCursorToMousePos(data)

  end

  -- TODO this is hacky, just doing it for testing so clean it up to only draw when needed
  self:DrawInputArea(data)

end

function EditorUI:DrawInputArea(data)

  -- Only draw input if the field is invalid
  if(data.invalid == true) then

    -- Get the correct x and y position based on the draw mode
    local x = (data.drawMode == DrawMode.Tile) and data.tiles.c or data.rect.x
    local y = (data.drawMode == DrawMode.Tile) and data.tiles.r or data.rect.y

    local line = ""
    if(data.scrollFirst == nil) then
      data.scrollFirst = 1
    end

    if(data.scrollLast == nil) then
      data.scrollLast = #data.lines
    end

    for i = data.scrollFirst, data.scrollLast do

      -- Get the current line
      line = i <= data.totalLines and data.lines[i] or ""

      -- TODO need to do color highlighting here

      -- TODO when working with input fields I added +1 to scroll right so it rendered correctly
      -- Select on only the characters we can display
      line = line:sub(data.scrollLeft, data.scrollRight)

      -- TODO need to defer this render

      -- Draw the text to the tilemap and pad it so it fills up the display
      -- DrawText(string.lpad(line, data.width, " "), x, y, data.drawMode, data.font, data.colorOffset, data.spacing)

      -- local drawArguments = {
      data.drawArguments[1] = string.lpad(line, data.width, " ")
      data.drawArguments[2] = x
      data.drawArguments[3] = y
      -- data.drawArguments[4] = data.drawMode
      --   data.font,
      data.drawArguments[6] = data.enabled == true and data.colorOffset or data.disabledColorOffset
      --   data.spacing
      -- }

      -- TODO need to just use the tile draw for the cursor
      self:NewDraw("DrawText", data.drawArguments)

      -- Increase the y for the next line
      y = y + ((data.drawMode == DrawMode.Tile) and 1 or 8)

    end
    --

    self:ResetValidation(data)

  end

  -- Display cursor only on blink
  if(data.blink == true) then

    -- Make sure that the cursor is within the scrolled area
    if(data.cursor.c >= data.scrollLeft and data.cursor.c <= data.scrollRight and data.cursor.r >= data.scrollFirst and data.cursor.r <= data.scrollLast) then

      -- Calculate the correct x and y position of the cursor
      -- local tmpX =
      -- local tmpY =

      -- Draw the cursor
      --DrawText(data.blinkChar, tmpX, tmpY, DrawMode.Sprite, data.font, data.colorOffset, data.spacing)
      -- local drawArguments = {
      --   data.blinkChar,
      data.cursorDrawArguments[2] = data.rect.x + ((data.cursor.c - data.scrollLeft) * self.spriteSize.x)
      data.cursorDrawArguments[3] = data.rect.y + ((data.cursor.r - data.scrollFirst) * self.spriteSize.y)
      --   DrawMode.Sprite,
      --   data.font,
      --   data.colorOffset,
      --   data.spacing
      -- }

      self:NewDraw("DrawText", data.cursorDrawArguments)

    end

  end

end

function EditorUI:ChangeInputArea(data, text, trigger)


  if(text == nil) then
    return
  end

  -- Reset counters
  data.lines = {}
  data.maxLineWidth = 0
  data.totalLines = 0

  -- test to see if the text is empty
  if(text == "") then

    -- If the text is empty, create a empty line for it by hand in the table
    table.insert(data.lines, "")

  else

    -- Loop through each line in the text
    for line in text:gmatch("([^\n]*)\n?") do

      -- Strip out any tabs and replace them with the tab char
      line = line:gsub("\t", data.tabChar)

      -- Update the max line width value
      data.maxLineWidth = math.max(#line, data.maxLineWidth)

      -- Add the new line to the table
      table.insert(data.lines, line)

    end

  end

  -- Cache the total line numbers
  data.totalLines = #data.lines

  -- Since we are clearing the input field, reset the text validation
  self:InputAreaResetTextValidation(data)

  self:InputAreaScrollTo(data, 0, 0)
  self:InputAreaMoveCursorTo(data, 0, 0)

  self:Invalidate(data)

  if(trigger ~= false and data.onAction ~= nil) then
    -- TODO need a method that can calculate the text into a clean string?
    data.onAction(text)
  end

end

function EditorUI:InputAreaInvalidateText(data)
  data.invalidText = true
end

function EditorUI:InputAreaResetTextValidation(data)
  data.invalidText = false
end

function EditorUI:InputAreaScrollTo(data, hVal, vVal)

  -- hVal = hVal or data.scrollValue.h
  -- vVal = vVal or data.scrollValue.v

  if(data.hVal ~= hVal) then
    data.hVal = hVal

    local newTotal = data.maxLineWidth - data.width

    data.scrollLeft = math.floor(newTotal * hVal) + 1

    -- Need to remove 1 for the left offset since lua is 1 based
    data.scrollRight = data.scrollLeft + data.width - 1

    -- Invalidate the display since we've made a change to the horizontal scroll
    self:Invalidate(data)

  end

  if(data.vVal ~= vVal) then

    data.vVal = vVal

    local newTotal = data.totalLines - data.height

    data.scrollFirst = math.floor(newTotal * vVal) + 1
    data.scrollLast = data.scrollFirst + data.height - 1

    self:Invalidate(data)
  end

  data.scrollValue.v = vVal
  data.scrollValue.h = hVal

end
