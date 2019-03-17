
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local utils = require("utils")
local timer = require("gears.timer")

local ram = {}

local top_color = beautiful.ram_bar_top_color or '#22ee22'
local bottom_color = beautiful.ram_bar_bottom_color or '#22ee22'

local ram_icon = beautiful.ram_icon or nil
local icon_size = beautiful.icon_size or dpi(20)

ram.ram_widget= wibox.widget({
    {
        forced_width = icon_size,
        forced_height = icon_size,
        widget = wibox.widget.imagebox(ram_icon),
    },
    utils.pad_width(20),
    {
        id = 'ram_bar',
        max_value = 100,
        bar_shape           = beautiful.top_infobar_shape or gears.shape.rounded_bar,
        color               = top_color,
        margins = {
            -- just so I only have to edit the size once at the top of the file
            top = icon_size / 5.5,
            bottom = icon_size / 5.5,
        },
        forced_height       = beautiful.infobar_height or dpi(10),
        forced_width        = beautiful.infobar_width or dpi(30), 
        background_color    = bottom_color,
        shape               = beautiful.bottom_infobar_shape or gears.shape.rectangle,
        widget              = wibox.widget.progressbar,
    },
    layout = wibox.layout.fixed.horizontal,
})



local percent_ram_used_script = [[bash -c "free | awk '/Mem/ { print $3*100/$2 }'"]]

local t = timer ({ 
    timeout = 5,
    call_now = true,
    autostart = true,
    callback = function()
        awful.spawn.easy_async(percent_ram_used_script, function(out)
            -- we actually have set up this whole circus to set the value
            ram.ram_widget.get_children_by_id(ram.ram_widget, 'ram_bar')[1].value = math.floor(tonumber(out))
        end)
    end
            
})

-- awful.spawn.easy_async(percent_ram_used_script, function(out)
    -- naughty.notify({text = tostring(math.floor(out))})
-- end)

-- cpu.cpu_widget.get_children_by_id(cpu.cpu_widget, 'cpu_bar')[1].value = math.floor(tonumber(out))


return ram

