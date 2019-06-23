
local gtable = require("gears.table")
local base = require("wibox.widget.base")
local wierarchy = require("wibox.hierarchy")
local free = require("brickware.layout.free")
local naughty = require("naughty")
local gtimer = require("gears.timer")
local gears = require("gears")

-- just because I don't know how to do it any other way,
-- I'll do it like this
local fr = base.make_widget(nil, nil, {enable_properties = true})
gtable.crush(fr, free, true)
fr._private.widgets = {}
fr._private.dir = "v"
fr._private.offset = 0
fr._private.selected = 1

local menu = {}

-- TODO: rewrite this. 
-- There's a clearer way of expressing this. I just don't have time now.
function menu:select_row(ind)
    local fr = self._private.widget
    local ind = ind 
    if ind < 1 then
        ind = 1
    elseif ind > #fr._private.widgets then
        ind = #fr._private.widgets
    end
    fr._private.selected = ind
    self:emit_signal("widget::redraw_needed")
    naughty.notify({text = tostring(fr._private.selected)})
end

function menu:get_selected_row()
    return self._private.widget._private.selected
end

local function traverse_hierarchy_tree(sig, hierarchy, x, y, ...)
    local m = hierarchy:get_matrix_from_device()

    -- Is (x,y) inside of this hierarchy or any child (aka the draw extents)?
    -- If not, we can stop searching.
    local x1, y1 = m:transform_point(x, y)
    local x2, y2, w2, h2 = hierarchy:get_draw_extents()
    if x1 < x2 or x1 >= x2 + w2 then
        return
    end
    if y1 < y2 or y1 >= y2 + h2 then
        return
    end
    -- Is (x,y) inside of this widget?
    -- If yes, we have to emit the signal on the widget.
    local width, height = hierarchy:get_size()
    if x1 >= 0 and y1 >= 0 and x1 <= width and y1 <= height then
        hierarchy:get_widget():emit_signal(sig, x1, y1, ...)
    end
    -- Continue searching in all children.
    for _, child in ipairs(hierarchy:get_children()) do
        traverse_hierarchy_tree(sig, child, x, y, ...)
    end
end

-- Finally, make input events work
local function button_signal(wid, signal)
    wid:connect_signal(signal, function(_, x, y, ...)
        -- Translate to "local" coordinates
        x = x - wid.info.x
        y = y - wid.info.y
        -- Figure out which widgets were hit and emit the signal on them
        traverse_hierarchy_tree(signal, wid.hier, x, y, ...)
    end)
end

local function emit_difference(name, list, skip)
    local function intable(table, val)
        for _, v in pairs(table) do
            if v.widget == val.widget then
                return true
            end
        end
        return false
    end
    for _, v in pairs(list) do
        if not intable(skip, v) then
            v.widget:emit_signal(name, v)
        end
    end
end

local function make_hierarchy(context, child, width, height)
    -- also, this code is weird. I declare this `hier` here and then in the
    -- `layout_callback` function I do an update on itself ???
    local hier 
    local function redraw_callback()
        child:emit_signal("widget::redraw_needed")
    end
    local function layout_callback()
        -- apparently having the line below work with what I want to do creates a stack overflow
        -- and I don't know why
        -- child:emit_signal("widget::layout_changed") 
        hier:update(context, child, width, height)
    end
    hier = wierarchy.new(context, child, width, height, redraw_callback, layout_callback, nil)
    return hier
end

local function calculate_info(self, context, width, height)

    local fr = self._private.widget -- this is the child widget, the `free` layout
    local offset = fr._private.offset
    local info = {}
    local dir = self._private.dir

    if dir == "v" then
        info.x = 0
        info.y = offset
    elseif dir == "h" then
        info.x = offset
        info.y = 0
    end
    local hier = make_hierarchy(context, fr, width, height)

    return info, hier
end

function menu:draw(context, cr, width, height)
    local info, hier = calculate_info(self, context, width, height)
    self.hier = hier
    self.info = info

    -- self:emit_signal("mouse::move", context)
    -- naughty.notify({text = tostring(type(context.drawable))}) ----------------------------------------------- LEFT OFF
    self:emit_signal("variable::drawable", context.drawable)
    self:emit_signal("variable::hierarchy", hier)

    -- we're emitting this to the `free` layout so it'll re-layout itself
    local fr = self._private.widget
    fr:emit_signal("widget::layout_changed")

    -- then we'll use the new info after it's re-layouted itself here
    cr:save()
    cr:translate(info.x, info.y)
    hier:draw(context, cr)
    cr:restore()
end

function menu:set_children(children)
    local fr = self._private.widget
    fr:set_children(children)
end

function menu:get_children()
    return self._private.widget._private.widgets
end

local function get_layout(dir, wid1, ...)
    local ret = base.make_widget(nil, nil, {enable_properties = true})
    gtable.crush(ret, menu, true)
    ret._private.widgets = {}
    ret._private.dir = dir

    fr:set_dir(dir)
    ret._private.widget = fr
    if wid1 then
        fr:add(wid1, ...)
    end

    -- ret:connect_signal("mouse::enter", function(...)
        -- for k, v in pairs({...}) do
            -- naughty.notify({text = tostring(v)})
        -- end
    -- end)

    -- ret:connect_signal("variable::drawable", function(_, drawable)
    --     drawable.drawable:connect_signal("mouse::move", function(_, x, y)
    --         -- ret:emit_signal("mouse::move")
    --         traverse_hierarchy_tree("mouse::move", ret.hier, x, y)
    --         handle_motion(drawable, x, y)
    --     end)
    --     drawable.drawable:connect_signal("mouse::leave", function()
    --         -- ret:emit_signal("mouse::leave")
    --         -- traverse_hierarchy_tree("mouse::move", ret.hier, x, y)
    --         handle_leave(drawable)
    --     end)
    -- end)

    button_signal(ret, "button::press")
    button_signal(ret, "button::release")

    -- gears.timer.start_new(1, function()
            -- naughty.notify({text = tostring(type(fr._ctx))})
        -- return true
    -- end)

    return ret
end

function menu.horizontal(...)
    return get_layout("h", ...)
end

function menu.vertical(...)
    return get_layout("v", ...)
end

return menu

