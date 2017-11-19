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

Utils = {}
Utils.__index = Utils

-- function Utils.CloneTable(src)
--   return {table.unpack(src)}
-- end

-- TODO need to remove this
function Utils.Pad(s, width, padder)
  padder = strrep(padder or " ", abs(width))
  if width < 0 then return strsub(padder .. s, width) end
  return strsub(s .. padder, 1, width)
end

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

-- index = x + y * width;


-- x = index % width;
-- y = index / width;

--
-- -- TODO need to clean these two methods up
-- function EditorUI:Wrap(str, limit)
--   local Lines, here, limit, found = {}, 1, limit or - 1, str:find("(%s+)()(%S+)()")
--
--   if found then
--     Lines[1] = string.sub(str, 1, found - 1) -- Put the first word of the string in the first index of the table.
--   else Lines[1] = str end
--
--   str:gsub("(%s+)()(%S+)()",
--     function(sp, st, word, fi) -- Function gets called once for every space found.
--       self:SplitWords(Lines, limit)
--
--       if fi - here > limit then
--         here = st
--         Lines[#Lines + 1] = word -- If at the end of a line, start a new table index...
--       else Lines[#Lines] = Lines[#Lines].." "..word end -- ... otherwise add to the current table index.
--   end)
--
--   self:SplitWords(Lines, limit)
--
--   return Lines
-- end
--
-- function EditorUI:SplitWords(Lines, limit)
--   while #Lines[#Lines] > limit do
--     Lines[#Lines + 1] = Lines[#Lines]:sub(limit + 1)
--     Lines[#Lines - 1] = Lines[#Lines - 1]:sub(1, limit)
--   end
-- end
