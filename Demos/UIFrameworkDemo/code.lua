--[[
	Pixel Vision 8 - New Template Script
	Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
	Created by Jesse Freeman (@jessefreeman)

	This project was designed to display some basic instructions when you create
	a new tool.	Simply delete the following code and implement your own Init(),
	Update() and Draw() logic.

	Learn more about making Pixel Vision 8 games at https://www.gitbook.com/@pixelvision8
]]--

-- Load in the editor framework script to access tool components
LoadScript("sb-sprites")
LoadScript("editor-ui")

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.
function Init()

	BackgroundColor(22)

	-- Get a reference to the Editor UI
	editorUI = EditorUI:Init()

	titleData = editorUI:CreateText({x = 8, y = 32}, "UI Demo")

	-- We are going to render the message in a box as tiles.
	messageData = editorUI:CreateText({x = 8, y = 48, w = 248}, "This project shows off how to use the GameCreator's UI components.")

	toolTipData = editorUI:CreateText({x = 8, y = 224}, "Tool tip message goes here.", "system-font", 24, - 4)

	-- Configure hSlider
	hSliderData = editorUI:CreateSlider(1, {x = 8, y = 112, w = 112, h = 8}, "hsliderhandle", "This is a horizontal slider.", true)
	hSliderData.onAction = OnValueChange

	vSliderData = editorUI:CreateSlider(11, {x = 240, y = 104, w = 8, h = 72}, "vsliderhandle", "This is a vertical slider")
	vSliderData.onAction = OnValueChange

	-- Buttons
	backBtnData = editorUI:CreateButton(8, {x = 192, y = 184}, "stepperback", "This is the picker back button.")
	backBtnData.onAction = OnPickerBack

	nextBtnData = editorUI:CreateButton(10, {x = 232, y = 184}, "steppernext", "This is the picker next button.")
	nextBtnData.onAction = OnPickerNext

	-- Toggle Button
	muteBtnData = editorUI:CreateToggleButton(3, {x = 168, y = 104}, "mute", "This is a toggle button.")
	muteBtnData.hitRect = {x = 168 + 2, y = 104 + 4, w = 28, h = 15}
	muteBtnData.onAction = OnMute

	-- Create a toggle group for the pagination buttons
	paginationBtnData = editorUI:CreateToggleGroup(5)
	paginationBtnData.onAction = OnPage

	-- Create pagination buttons
	for i = 1, 4 do
		local offsetX = ((i - 1) * 8) + 40
		local rect = {x = offsetX, y = 168, w = 8, h = 16}
		editorUI:ToggleGroupButton(paginationBtnData, rect, "pagebutton" .. tostring(i), "This is page button " .. tostring(i))
	end

	editorUI:SelectToggleButton(paginationBtnData, 1, false)

	-- Input fields
	volumeInputData = editorUI:CreateInputField(2, {x = 136, y = 112, w = 24}, "0", "The volume is set to %02s. Click to edit it.", "number")
	volumeInputData.min = 0
	volumeInputData.max = 100
	volumeInputData.disabledColorOffset = 8
	volumeInputData.onAction = OnVolumeFieldUpdate
	volumeInputData.colorOffset = 32
	volumeInputData.disabledColorOffset = 34

	nameInputData = editorUI:CreateInputField(6, {x = 16, y = 192, w = 11 * 8}, "Untitled", "Enter in a file name to this string input field.", "file")
	nameInputData.colorOffset = 32

	pickerInputData = editorUI:CreateInputField(9, {x = 216, y = 192, w = 8}, "1", "You are on page %s of 9. Enter new page number.", "number")
	pickerInputData.min = 1
	pickerInputData.max = 9
	pickerInputData.onAction = UpdatePickerButtons
	pickerInputData.colorOffset = 32

	editorUI:ChangeInputField(pickerInputData, 1)

	inputAreaData = editorUI:CreateInputArea(4, {x = 16, y = 136, w = 208, h = 32}, "Lorem ipsum dolor sit amet\n, consectetur adipiscing elit. \nVivamus ultricies nunc ex, \nid commodo mauris iaculis nec.", "Text editor help")
	inputAreaData.colorOffset = 32

	-- Check boxes
	checkboxGroupData = editorUI:CreateToggleGroup(7, false)
	checkboxGroupData.onAction = OnCheckbox

	editorUI:ToggleGroupButton(checkboxGroupData, {x = 120, y = 184, w = 8, h = 8}, "checkbox", "This is checkbox 1.")
	editorUI:ToggleGroupButton(checkboxGroupData, {x = 160, y = 184, w = 8, h = 8}, "checkbox", "This is checkbox 2.")
	editorUI:ToggleGroupButton(checkboxGroupData, {x = 120, y = 192, w = 8, h = 8}, "checkbox", "This is checkbox 3.")
	editorUI:ToggleGroupButton(checkboxGroupData, {x = 160, y = 192, w = 8, h = 8}, "checkbox", "This is checkbox 4.")

end

function OnVolumeFieldUpdate(text)

	local value = tonumber(text / 100)

	editorUI:ChangeSlider(hSliderData, value, false)
	editorUI:ChangeSlider(vSliderData, value, false)

end

function OnValueChange(value)
	--print("New value", value)

	editorUI:ChangeInputField(volumeInputData, tostring(value * 100))

	if(hSliderData.value ~= value) then

		editorUI:ChangeSlider(hSliderData, value)

	end

	if(vSliderData.value ~= value) then

		editorUI:ChangeSlider(vSliderData, value)

	end

end

function OnPickerBack()
	local value = tonumber(pickerInputData.text)
	OnPageChange(value - 1)

end

function OnPickerNext()
	local value = tonumber(pickerInputData.text)
	OnPageChange(value + 1)
end

function OnPageChange(value)

	if(value < pickerInputData.min) then
		value = pickerInputData.min

	elseif(value > pickerInputData.max) then
		value = pickerInputData.max
	end

	local stringValue = tostring(value)

	if(pickerInputData.text ~= stringValue) then
		editorUI:ChangeInputField(pickerInputData, stringValue)
	end

	UpdatePickerButtons(stringValue)

end

function OnCheckbox(value)

	local selections = editorUI:ToggleGroupSelections(checkboxGroupData)
	local total = #selections

	local message = "There are now " .. total .. " selected checkboxes"

	if(total > 0) then
		message = message .. ": " .. table.concat(selections, ",")

	end
	-- pixelVisionOS:DisplayMessage(message ..".")

end


function UpdatePickerButtons(text)

	if(text == "") then
		text = "0"
	end
	-- convert the text value to a number
	local value = tonumber(text)

	-- update buttons
	editorUI:Enable(backBtnData, value > pickerInputData.min)
	editorUI:Enable(nextBtnData, value < pickerInputData.max)

end

function OnMute(value)
	-- Enable or disable the volume input field and sliders based on the mute value
	editorUI:Enable(volumeInputData, not value)
	editorUI:Enable(hSliderData, not value)
	editorUI:Enable(vSliderData, not value)
end

function OnPage(value)
	-- pixelVisionOS:DisplayMessage("Page " .. value .. " selected")
end
-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame
-- before the Draw() method. It accepts one argument, timeDelta, which is the difference in
-- milliseconds since the last frame.
function Update(timeDelta)

	-- This needs to be the first call to make sure all of the OS and editor UI is updated first
	editorUI:Update(timeDelta)

	-- TODO add your own update logic here

	-- Update Text
	editorUI:UpdateText(titleData)
	editorUI:UpdateText(messageData)
	editorUI:UpdateText(toolTipData)

	-- Update Slider
	editorUI:UpdateSlider(hSliderData)
	editorUI:UpdateSlider(vSliderData)

	-- Update buttons
	editorUI:UpdateButton(backBtnData)
	editorUI:UpdateButton(nextBtnData)
	editorUI:UpdateButton(muteBtnData)

	-- Update toggle groups
	editorUI:UpdateToggleGroup(paginationBtnData)
	editorUI:UpdateToggleGroup(checkboxGroupData)

	--
	editorUI:UpdateInputField(volumeInputData)
	editorUI:UpdateInputField(nameInputData)
	editorUI:UpdateInputField(pickerInputData)
	--

	editorUI:UpdateInputArea(inputAreaData)

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

	-- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a
	-- single call.
	RedrawDisplay()

	-- We have to manually display the tool tip
	local toolTip = ""

	if(editorUI.inFocusUI ~= nil and editorUI.inFocusUI.toolTip ~= nil) then

		toolTip = editorUI.inFocusUI.toolTip

	end

	editorUI:ChangeText(toolTipData, string.lpad(toolTip, 60, " "))

	-- The UI should be the last thing to draw after your own custom draw calls
	editorUI:Draw()

end
