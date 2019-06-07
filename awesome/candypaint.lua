#!/usr/bin/lua

local lib = {}

local function tohex(num)
    local n = string.format("%x", num) -- this is actually the right number.
    -- but we can't have a hex color code without two digits for each color
    if #n < 2 then
        n = '0' .. n
    end
    return n
end

local function todec(str)
    return tonumber(str, 16)
end

local function standardize(color)
    -- let's transform whatever we get into an 8-length hex value
    local color = string.sub(color, 2) -- let's remove the hash sign
    assert(#color == 3 or #color == 4 or #color == 6 or #color == 8,
        "invalid color. must be a hex value of length either 3, 4, 6 or 8")
    local col = ""
    if #color == 3 then
        for i=1, 3 do
            col = col .. string.rep(string.sub(color, i, i), 2)
        end
        col = col .. "ff"
    elseif #color == 4 then
        for i=1, 4 do
            col = col .. string.rep(string.sub(color, i, i), 2)
        end
    elseif #color == 6 then
        col = color .. "ff"
    elseif #color == 8 then
        col = color
    end

    return col
end

local function split(color)
    local split = {}
    for i=1, 8 do
        if i % 2 == 0 then
            table.insert(split, string.sub(color, i-1, i))
        end
    end
    return split
end

function lib.darken(color, val)

    local scolor = split(standardize(color))
    for i=1, 3 do
        local v = scolor[i]
        v = todec(v)
        v = v - val
        if v < 0 then v = 0 end
        scolor[i] = tohex(v)
    end

    return "#" .. table.concat(scolor)

end

function lib.lighten(color, val)
    local scolor = split(standardize(color))
    for i=1, 3 do
        local v = scolor[i]
        v = todec(v)
        v = v + val
        if v > 255 then v = 255 end
        scolor[i] = tohex(v)
    end
    return "#" .. table.concat(scolor)
end

return lib

