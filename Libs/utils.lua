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

table.clone = function(src)
  return {table.unpack(src)}
end

string.lpad = function(str, len, char)
  if char == nil then char = ' ' end
  return str .. string.rep(char, len - #str)
end

string.rpad = function(str, len, char)
  if char == nil then char = ' ' end
  return string.rep(char, len - #str) .. str
end

string.trunc = function(str, len, char)

  if char == nil then char = '...' end
  if(#str > len) then
    str = string.sub(str, 1, len - #char) .. char
  end

  return str
end

string.split = function(string, delimiter)
  if delimiter == nil then
    delimiter = "%s"
  end
  local t = {} ; i = 1
for str in string.gmatch(string, "([^"..delimiter.."]+)") do
  t[i] = str
  i = i + 1
end
return t
end

function math.round(num, numDecimalPlaces)
local mult = 10^(numDecimalPlaces or 0)
return math.floor(num * mult + 0.5) / mult
end

function math.index(x, y, width)
return x + y * width
end

function math.pos(index, width)
return index % width, math.floor(index / width)
end

function table.find(f, l) -- find element v of l satisfying f(v)
for _, v in ipairs(l) do
  if f(v) then
    return v
  end
end
return nil
end
