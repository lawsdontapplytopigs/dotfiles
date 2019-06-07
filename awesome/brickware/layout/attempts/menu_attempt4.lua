
local fix = require("brickware.layout.custom_fixed")
local gtable = require("gears.table")
local base = require("wibox.widget.base")
local wierarchy = require("wibox.hierarchy")
local naughty = require("naughty")

local fixed = base.make_widget(nil, nil, {enable_properties = true})
fixed._private.prank = 80
gtable.crush(fixed, fix, true)
fixed._private.dir = 'h'
fixed._private.widgets = {}
fixed._private.space_for_scrolling = 2^1024
fixed._private.selected = 1
fixed._private.offset = -20

local menu = {}

function menu:select_row(ind)
    local ind = ind
    if ind < 1 then
        ind = 1
    elseif ind > #self._private.widget._private.widgets then
        ind = #self._private.widget._private.widgets
    end
    self._private.widget._private.selected = ind
    self:emit_signal("widget::layout_changed") -- FIXME: for some reason if any of these work, they give me a stack overflow
    self:emit_signal("widget::redraw_needed")
end

function menu:get_selected_row()
    return self._private.widget._private.selected
end

-- the `child` here is the widget that will be drawn. namely, the custom `fixed` layout above
local function make_hierarchy(context, child, width, height)
    local hier
    local function redraw_callback()
        child:emit_signal("widget::redraw_needed")
    end
    local function layout_callback()
        hier:update(context, child, width, height, nil)
        child:emit_signal("widget::redraw_needed")
    end
    hier = wierarchy.new(context, child, width, height, redraw_callback, layout_callback, nil)

    return hier
end

local function calculate_info (self, context, width, height)
    local result = {}
    assert(self._private.widget)

    local child_width, child_height = width, height

    local hier = make_hierarchy(context, self._private.widget, child_width, child_height)
    local x, y = 0, 0

    result.x = x
    result.y = y
    result.hierarchy = hier

    return result
end

function menu:draw(context, cr, width, height)
    local info = calculate_info(self, context, width, height)
    cr:save()
    cr:translate(info.x, info.y)
    info.hierarchy:draw(context, cr)
    cr:restore()
end

function menu:set_children(children)
    fixed:set_children(children)
end

function menu:get_children()
    return self._private.widget._private.widgets
end

local function get_layout (dir, wid1, ...)

    local mnu = base.make_widget(nil, nil, {enable_properties = true})

    gtable.crush(mnu, menu, true)
    mnu._private.dir = dir
    fixed:set_dir(dir)
    mnu._private.widget = fixed

    if wid1 then
        fixed:add(wid1, ...)
    end

    return mnu

end

function menu.horizontal(...)
    return get_layout('h', ...)
end

function menu.vertical(...)
    return get_layout("v", ...)
end

return menu

