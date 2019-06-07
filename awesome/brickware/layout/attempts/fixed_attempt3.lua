
local pairs = pairs
local base = require("wibox.widget.base")
local unpack = table.unpack or unpack
local gtable = require("gears.table")
local naughty = require("naughty")

-- This will be a widget very similar to the `fixed` layout widget of awesome
-- But it will be much more bare bones, and will only be used because I'll need
-- to use the `wibox.hierarchy` library and the `wibox.hierarchy.new` function
-- can only manage ONE widget (I think). So we'll give it one: a layout comprised of more 
-- widgets and this way we'll prank the hierarchy into doing what we want it to do ;)

local _fix = {} 

function _fix:layout(context, width, height)

    local result = {}
    local temp = {}
    -- we'll draw everything starting from 0,
    -- then we change the offset if we need to
    -- then we add that offset to all rows
    local pos = 20 + self._private.prank
    local sel = self._private.selected
    local is_v = self._private.dir == "v"
    local is_h = not is_v
    for k, wid in pairs(self._private.widgets) do
        local x, y, w, h
        if is_v then
            x, y = 0, pos
            w, h = base.fit_widget(self, context, wid, width, 2^1024)
            pos = pos + h
        elseif is_h then
            x, y = pos, 0
            w, h = base.fit_widget(self, context, wid, 2^1024, height)
            pos = pos + w
        end
        table.insert(temp, {wid, x, y, w, h})
    end

    local offset = self._private.offset
    naughty.notify({text = tostring(offset)})

    self._private.prank = self._private.prank + 20

    -- local offset = self._private.offset
    -- local swi = temp[sel] -- swi = "selected widget info"
    -- -- let's decide if the selected widget is out of visible bounds and if it is,
    -- -- we'll offset every row by the right amount
    -- if is_v then -------------------------------------------------------------- TODO: LEFTOFF
        -- if swi.y < math.abs(offset) then
            -- local v = math.abs(offset) - swi.y
            -- for _, data in pairs(temp) do
                -- data.y = data.y + v
            -- end
            -- self._private.offset = - (offset - v)
        -- elseif swi.y + swi.h > math.abs(offset) + height  then
            -- local v = swi.y + swi.h - math.abs(offset) + height
            -- for _, data in pairs(temp) do
                -- data.y = data.y - v
            -- end
            -- self._private.offset = - (offset + v)
        -- end
    -- elseif is_h then
        -- if swi.x < math.abs(offset) then
            -- local v = math.abs(offset) - swi.y
        -- elseif swi.x + swi.w > math.abs(offset) + width then
            -- for _, data in pairs(temp) do
                -- data.x = data.x - swi.x + swi.w - math.abs(offset) + width
            -- end
        -- end
    -- end

    for _, data in pairs(temp) do
        table.insert(result, base.place_widget_at(table.unpack(data)))
    end

    return result
end

function _fix:reset()
    self._private.widgets = {}
    self:emit_signal("widget::layout_changed")
    self:emit_signal("widget::reseted")
end

function _fix:add(...)
    local args = { ... }
    for _, wid in pairs(args) do
        base.check_widget(wid)
        table.insert(self._private.widgets, wid)
    end
    self:emit_signal("widget::layout_changed")
end

function _fix:set_children(children)
    self:reset()
    if #children > 0 then
        self:add(unpack(children))
    end
end

function _fix:get_children()
    return self._private.widgets
end

function _fix:set_dir(dir)
    self._private.dir = dir
    self:emit_signal("widget::layout_changed")
    self:emit_signal("widget::redraw_needed")
end

return _fix


