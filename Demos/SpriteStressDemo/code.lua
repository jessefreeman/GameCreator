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

-- The Stress Test Demo highlights the sprite rendering limitation of Pixel Vision 8. By default,
-- the DisplayChip can only handle displaying 64 sprites at the same time. We'll create a loop the
-- attempts to render more sprite than the system can handle. The outcome is that additional draw
-- calls are ignored and the engine maintains its optimal performance.

-- These are some fields we'll use for performing the stress test.
local delay = 0
local delayTime = 2
local totalSprites = 200;
local x = 0
local y = 0
local width = 0
local height = 0
local totalColors = 0
local lastFPS = 0
local newFPS = 0

function Init()
	-- It's best to define these outside of the for loop since we only need to set the value once.
	local displaySize = Display()
	width = displaySize.x
	height = displaySize.y
	totalColors = TotalColors()
end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame before
-- the Draw() method. It accepts one argument, timeDelta, which is the difference in milliseconds since
-- the last frame. We are going to use this timeDelta value to keep track of the time before changing
-- the background color.
function Update(timeDelta)

	-- We start by adding the time delta to the delay.
	delay = delay + timeDelta

	-- Next, we will need to test if the delay value is greater than the delayTime field we set up at the
	-- beginning of our class.
	if(delay > delayTime) then

		-- After the appropriate delay, we can change the background color a random value. We'll cap this
		-- between 0 and 63.
		BackgroundColor(math.random(0, totalColors))

		-- We need to reset the delay so we can start tracking it again on the next frame.
		delay = 0

	end

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and
-- is where all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

	-- Clearing the display on each frame is important. Since we are not using the ScreenBufferChip,
	-- we can directly clear the DisplayChip by calling the Clear() method.
	Clear()

	-- This loop will create a random x and y value based on the display's dimension then attempt to
	-- draw a sprite. Since we are drawing more sprites to the display than it can handle, it will
	-- not display any additional sprites over the max sprite count. This loop does add overhead so
	-- FPS will be lower than a real world game where you can manage the draw calls better.
	for i = 0, totalSprites, 1 do
		x = math.random(0, width)
		y = math.random(0, height)
		DrawSprite( i + 12, x, y)
	end

	-- Let's draw the FPS chars first since they will always be displayed. Any additional sprites over
	-- the max sprite count will simply be ignore.
	DrawText("SPRITES " .. ReadTotalSprites() .. " FPS " .. ReadFPS(), 4, 4, DrawMode.UI, "large-font")

end
