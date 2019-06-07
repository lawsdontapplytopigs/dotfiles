
local gtable = require("gears.table")
local base = require("wibox.widget.base")
local unpack = table.unpack or unpack -- lua 5.1 compatibility
local gtimer = require("gears.timer")
local naughty = require("naughty")

local free = {}

function free:layout (context, width, height)
    local temp = {}
    local pos = 0
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
        table.insert(temp, { wid, x, y, w, h })
    end

    -- I thought storing these simply as indices, instead of having a hash table
    -- would be more efficient. But the indices mean:
    -- [1] = wid
    -- [2] = x
    -- [3] = y
    -- [4] = w
    -- [5] = h
    local offset = self._private.offset
    local sel = self._private.selected
    if is_v then
        if temp[sel][3] < math.abs(offset) then
            local scroll_dif = math.abs(offset) - math.abs(temp[sel][3])
            for _, data in pairs(temp) do
                data[3] = data[3] + scroll_dif
            end
            self._private.offset = offset + scroll_dif

        elseif temp[sel][3] + temp[sel][5] > math.abs(offset) + height then
            local scroll_dif = (temp[sel][3] + temp[sel][5]) - (math.abs(offset) + height)
            for _, data in pairs(temp) do
                data[3] = data[3] - scroll_dif
            end
            self._private.offset = offset - scroll_dif
        end

    elseif is_h then
        if temp[sel][2] < math.abs(offset) then
            local scroll_dif = math.abs(offset) - math.abs(temp[sel][1])
            for _, data in pairs(temp) do
                data[2] = data[2] + scroll_dif
            end
            self._private.offset = offfset + scroll_dif

        elseif temp[sel][2] + temp[sel][4] > math.abs(offset) + width then
            local scroll_dif = (temp[sel][2] + temp[sel][4]) - (math.abs(offset) + width)
            for _, data in pairs(temp) do
                data[2] = data[2] - scroll_dif
            end
            self._private.offset = offset - scroll_dif
        end
    end

    local result = {}
    for _, data in pairs(temp) do
        table.insert(result, base.place_widget_at(unpack(data)))
    end

    return result
end

function free:reset()
    self._private.widgets = {}
    self:emit_signal("widget::layout_changed")
    self:emit_signal("widget::redraw_needed")
end

function free:add(...)
    local args = { ... }
    for k, wid in pairs(args) do
        base.check_widget(wid)
        table.insert(self._private.widgets, wid)
    end
    self:emit_signal("widget::layout_changed")
end

function free:set_children(children)
    self:reset()
    if #children > 0 then
        self:add(unpack(children))
    end
end

function free:set_dir (dir)
    if dir ~= "v" and dir ~= "h" then
        return
    end
    self._private.dir = dir
    self:emit_signal("widget::layout_changed")
end

return free
