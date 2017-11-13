--[[
	Micro Platformer - Platforming Framework in 100 lines of code.
	Created by Matt Hughson (@matthughson | http://www.matthughson.com/)

	Update to PV8 v1.5 API by Jesse Freeman (@jessefreeman | http://pixelvision8.com)
]]--

--[[
	The goal of this cart is to demonstrate a very basic
	platforming engine in under 100 lines of *code*, while
	still maintaining an organized and documented game. 

	It isn't meant to be a demo of doing as much as possible, in
	as little code as possible. The 100 line limit is just 
	meant to encourage people to realize "You can make a game
	with very little coding!"

	This will hopefully give new users a simple and easy to 
	understand starting point for their own platforming games.

	Note: Collision routine is based on mario bros 2 and 
	mckids, where we use collision points rather than a box.
	this has some interesting bugs but if it was good enough for
	miyamoto, its good enough for me!
--]]

--player information
p1=
{
	--position, representing the top left of
	--of the player sprite.
	x=72,
	y=16,
	--velocity
	dx=0,
	dy=0,
	
	--is the player standing on
	--the ground. used to determine
	--if they can jump.
	isgrounded=false,
	
	--how fast the player is launched
	--into the air when jumping.
	jumpvel=3.0,
}

--globals
g=
{
	grav=0.1, -- gravity per frame
}

local flag = 0 -- stores the flag globally since it's used every frame

--called once at the start of the program.
function Init()
	BackgroundColor(0)
end

--called 60 times per second
function Update(deltaTime)

	--remember where we started
	local startx=p1.x
	
	--jump 
	--
	
	--if on the ground and the
	--user presses a,b,or,up...
	
	if (Button(Buttons.Up) or Button(Buttons.A) or Button(Buttons.B))
	 and p1.isgrounded then
	 --launch the player upwards
		p1.dy=-p1.jumpvel
	end
	
	--walk
	--
	
	p1.dx=0
	if Button(Buttons.Left) then --left
		p1.dx=-1
	end
	if Button(Buttons.Right) then --right
		p1.dx=1
	end
	
	--move the player left/right
	p1.x=p1.x+p1.dx
	
	--hit side walls
	--
	
	--check for walls in the
	--direction we are moving.
	local xoffset=0 --moving left check the left side of sprite.
	if p1.dx>0 then xoffset=7 end --moving right, check the right side.
	
	--look for a wall on either the left or right of the player
	--and at the players feet.
	--We divide by 8 to put the location in TileMap space (rather than
	--pixel space).
	flag=Flag((p1.x+xoffset)/8,(p1.y+7)/8)
	--We use flag 0 (solid black) to represent solid walls. This is controlled 
	--by tilemap-flags.png.
	if flag==0 then
		--they hit a wall so move them
		--back to their original pos.
		--it should really move them to
		--the edge of the wall but this
		--mostly works and is simpler.
		p1.x=startx
	end
	
	--accumulate gravity
	p1.dy=p1.dy+g.grav
	
	--apply gravity to the players position.
	p1.y=p1.y+p1.dy

	--hit floor
	--
	
	--assume they are floating 
	--until we determine otherwise
	p1.isgrounded=false
	
	--only check for floors when
	--moving downward
	if p1.dy>=0 then
		--check bottom center of the
		--player.
		flag=Flag((p1.x+4)/8,(p1.y+8)/8)
		--look for a solid tile
		if flag==0 then
			--place p1 on top of tile
			p1.y = math.floor((p1.y)/8)*8
			--halt velocity
			p1.dy = 0
			--allow jumping again
			p1.isgrounded=true
		end
	end
	
	--hit ceiling
	--
		
	--only check for ceilings when
	--moving up
	if p1.dy<=0 then
		--check top center of player
		flag=Flag((p1.x+4)/8,(p1.y)/8)
		--look for solid tile
		if flag==0 then
			--position p1 right below
			--ceiling
			p1.y = math.floor((p1.y+8)/8)*8
			--halt upward velocity
			p1.dy = 0
		end
	end
end

function Draw()
	--clear the screen so we start each frame
	--with a blank canvas to draw on.
 	RedrawDisplay()
	--draw the player, represented as sprite 1.
	DrawSprite(1,p1.x,p1.y)--draw player
end