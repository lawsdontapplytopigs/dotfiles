
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local utils = require("utils")
local timer = require("gears.timer")

local cpu = {}

local cpu_icon = beautiful.cpu_icon or nil
local icon_size = beautiful.icon_size or dpi(20)

cpu.cpu_widget= wibox.widget({
    {
        forced_width = icon_size,
        forced_height = icon_size,
        widget = wibox.widget.imagebox(cpu_icon),
    },
    utils.pad_width(20),
    {
        id = 'cpu_bar',
        max_value = 100,
        bar_shape           = beautiful.top_infobar_shape or gears.shape.rounded_bar,
        color               = beautiful.cpu_bar_top_color,
        border_color        = beautiful.bottom_infobar_border_color or nil,
        border_width        = beautiful.bottom_infobar_border_width or nil,
        margins = {
            -- just so I only have to edit the size once at the top of the file
            top = icon_size / 5.5,
            bottom = icon_size / 5.5,
        },
        forced_height       = beautiful.infobar_height or dpi(10),
        forced_width        = beautiful.infobar_width or dpi(30), 
        background_color    = beautiful.cpu_bar_bottom_color,
        shape               = beautiful.bottom_infobar_shape or gears.shape.rectangle,
        widget              = wibox.widget.progressbar,
    },
    layout = wibox.layout.fixed.horizontal,
})

-- the reason we have to do 'bash -c' is because 
-- otherwise the dollar signs will expand in the awk
-- scripts and I don't know how to escape them
local get_avg_cpu = [[bash -c "top -bn 1 | egrep '^%Cpu' | awk -F ':' '{ print $2 }' | awk '{ sum +=$1; ncores += 1 } END { print sum/ncores }'"]]

local t = timer ({ 
    timeout = 5,
    call_now = true,
    autostart = true,
    callback = function()
        awful.spawn.easy_async(get_avg_cpu, function(out)
            -- we actually have set up this whole circus to set the value
            cpu.cpu_widget.get_children_by_id(cpu.cpu_widget, 'cpu_bar')[1].value = math.floor(tonumber(out))
        end)
    end
            
})

return cpu
