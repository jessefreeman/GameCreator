--[[
	Pixel Vision 8 - New Template Script
	Copyright (C) 2017, Pixel Vision 8 (http://pixelvision8.com)
	Created by Jesse Freeman (@jessefreeman)

	This script provides mappers for Pico8's core APIs. It's not a 1:1 mapping but
  will hopefully allow simple Pico 8 games to run in PV8 without throwing errors
  and make porting easier.

  Based on picolove API - https://github.com/gamax92/picolove/blob/master/api.lua

	Learn more about making Pixel Vision 8 games at https://www.gitbook.com/@pixelvision8
]]--

-- Look for a lua file with the sprite flags
LoadScript("sprite-flags")

-- save a reference to the native lua print function
_print = print

function print( str, x, y, col )

  if(x == nil) then
    _print(str)
  else
    col = col or 7
    DrawText(str, x, y, DrawMode.UI, "default", col, - 4)
  end

end

function camera(x, y)

  ScrollPosition(x, y)

end

function cls()
  Clear()
end

function spr(n, x, y, w, h, flip_x, flip_y)
  DrawSpriteBlock(n, x, y, w, h, flip_x, flip_y)
end

function sset(x, y, c)
  -- Has not been implemented
end

function sspr(sx, sy, sw, sh, dx, dy, dw, dh, flip_x, flip_y)
  -- Has not been implemented
end

function add(a, v)
  if a == nil then return end
  a[#a + 1] = v
end

function all(a)
  if a == nil or #a == 0 then
    return function() end
  end
  local i, li = 1
  return function()
    if (a[i] == li) then i = i + 1 end
    while(a[i] == nil and i <= #a) do i = i + 1 end
    li = a[i]
    return a[i]
  end
end

function foreach(a, f)
  for v in all(a) do
    f(v)
  end
end

function del(a, dv)
  if a == nil then return end
  for i = 1, #a do
    if a[i] == dv then
      table.remove(a, i)
      return
    end
  end
end

function btn(i, p)

  local btnID = nil

  if(i == 0) then
    btnID = Buttons.Left
  elseif(i == 1) then
    btnID = Buttons.Right
  elseif(i == 2) then
    btnID = Buttons.Up
  elseif(i == 3) then
    btnID = Buttons.Down
  elseif(i == 4) then
    btnID = Buttons.A
  elseif(i == 5) then
    btnID = Buttons.B
  end

  return Button(btnID, InputState.Down, p)

end

function btnp(i, p)

  local btnID = nil

  if(i == 0) then
    btnID = Buttons.Left
  elseif(i == 1) then
    btnID = Buttons.Right
  elseif(i == 2) then
    btnID = Buttons.Up
  elseif(i == 3) then
    btnID = Buttons.Down
  elseif(i == 4) then
    btnID = Buttons.A
  elseif(i == 5) then
    btnID = Buttons.B
  end

  return Button(btnID, InputState.Released, p)

end

function music(n, fade_len, channel_mask)
  -- Has not been implemented
end

function sfx(n, channel, offset)
  PlaySound(n, channel)
end

function map(cel_x, cel_y, sx, sy, cel_w, cel_h, layer)

  ScrollPosition(cel_x * 8, cel_y * 8)
  DrawTilemap(sx, sy, cel_w, cel_h)

end



abs = math.abs

function sgn(x)
  return x < 0 and - 1 or 1
end

function atan2(x, y)
  return (0.75 + math.atan2(x, y) / (math.pi * 2)) % 1.0
end

function band(x, y)
  return bit.band(x * 0x10000, y * 0x10000) / 0x10000
end

function bnot(x)
  return bit.bnot(x * 0x10000) / 0x10000
end

function bor(x, y)
  return bit.bor(x * 0x10000, y * 0x10000) / 0x10000
end

function bxor(x, y)
  return bit.bxor(x * 0x10000, y * 0x10000) / 0x10000
end

function cos(x)
  return math.cos((x or 0) * math.pi * 2)
end

flr = math.floor

function max(a, b)
  if a == nil or b == nil then
    warning('max a or b are nil returning 0')
    return 0
  end
  if a > b then return a end
  return b
end

function mid(x, y, z)
  return (x <= y)and((y <= z)and y or((x < z)and z or x))or((x <= z)and x or((y < z)and z or y))
end

function min(a, b)
  if a == nil or b == nil then
    warning('min a or b are nil returning 0')
    return 0
  end
  if a < b then return a end
  return b
end

function rnd(x)
  return math.random() * (x or 1)
end

function shl(x, y)
  return bit.lshift(x * 0x10000, y) / 0x10000
end

function shr(x, y)
  return bit.arshift(x * 0x10000, y) / 0x10000
end

function sin(x)
  return - math.sin((x or 0) * math.pi * 2)
end

sqrt = math.sqrt

function srand(seed)
  math.randomseed(flr(seed * 0x10000))
end

sub = string.sub
cocreate = coroutine.create
coresume = coroutine.resume
yield = coroutine.yield
costatus = coroutine.status
tonum = tonumber
tostr = tostring

function stat(n)

  if(n == 32) then
    return MousePosition().x
  elseif(n == 33) then
    return MousePosition().y
  elseif(n == 34) then
    local val = 0

    if(MouseButton(0)) then
      val +  = 1
    end

    if(MouseButton(1))then
      val +  = 2
    end

    return val
  else
    return 0
  end
end

-- These APIs just don't map over to PV8 and are set up it be ignored at run time.
function time()
  -- Has not been implemented
end

function flip()
  -- Has not been implemented
end

function circ(x, y, r, col)
  -- Has not been implemented
end

function circfill(x, y, r, col)
  -- Has not been implemented
end

function clip(x, y, w, h)
  -- Has not been implemented
end

function color(col)
  -- Has not been implemented
end

function cursor(x, y)
  -- Has not been implemented
end

function fget(n, f)

  -- If spriteFlags doesn't exist, return 0
  if(spriteFlags == nil) then
    return 0
  end

  local flag = spriteFlags[n]

  if(flag == nil) then
    return 0
  end

  if(f == nil) then
    return flag
  else
    local bits = BitArray(flag)

    flag = bits[f + 1]

    if(flag == nil) then
      return 0
    else
      if(flag == 0) then
        return true
      else
        return false
      end
    end

  end

end

function fillp(pat)
  -- Has not been implemented
end

function fset(n, f, v)
  -- Has not been implemented
end

function line(x0, y0, x1, y1, col)
  -- Has not been implemented
end

function pal(c0, c1, p)
  -- Has not been implemented
end

function palt(c, t)
  -- Has not been implemented
end

function pget(x, y)
  -- Has not been implemented
end

function pset(x, y, c)
  -- Has not been implemented
end

function rect(x0, y0, x1, y1, col)
  -- Has not been implemented
end

function rectfill(x0, y0, x1, y1, col)
  -- Has not been implemented
  DrawRect(x0, y0, x1 - x0, y1 - y0, col)
end

function sget(x, y)
  -- Has not been implemented
end

function mget(x, y)
  return Tile(x, y).spriteID
end

function mset(x, y, v)
  -- Has not been implemented
end

function cstore(dest_addr, source_addr, len, filename)
  -- Has not been implemented
end

function memcpy(dest_addr, source_addr, len)
  -- Has not been implemented
end

function memset(dest_addr, val, len)
  -- Has not been implemented
end

function peek(addr)
  -- Has not been implemented
end

function poke(addr, val)
  -- Has not been implemented
end

function reload(dest_addr, source_addr, len, filename)
  -- Has not been implemented
end

function cartdata(id)
  -- Has not been implemented
end

function dget(index)
  -- Has not been implemented
end

function dset(index, value)
  -- Has not been implemented
end
