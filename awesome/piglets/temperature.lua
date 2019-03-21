
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local utils = require("utils")
local timer = require("gears.timer")

local temperature = {}


local temperature_icon = beautiful.temperature_icon or nil
local icon_size = beautiful.icon_size or dpi(20)

temperature.temperature_widget = wibox.widget({
    {
        forced_width = icon_size,
        forced_height = icon_size,
        widget = wibox.widget.imagebox(temperature_icon),
    },
    utils.pad_width(20),
    {
        id = 'temperature_bar',
        max_value = 100,
        bar_shape           = beautiful.top_infobar_shape or gears.shape.rounded_bar,
        color               = beautiful.temperature_bar_top_color,
        border_color        = beautiful.bottom_infobar_border_color or nil,
        border_width        = beautiful.bottom_infobar_border_width or nil,
        margins = {
            -- just so I only have to edit the size once at the top of the file
            top = icon_size / 5.5,
            bottom = icon_size / 5.5,
        },
        forced_height       = beautiful.infobar_height or dpi(10),
        forced_width        = beautiful.infobar_width or dpi(30), 
        background_color    = beautiful.temperature_bar_bottom_color,
        shape               = beautiful.bottom_infobar_shape or gears.shape.rectangle,
        widget              = wibox.widget.progressbar,
    },
    layout = wibox.layout.fixed.horizontal,
})

-------------------
-- NOTE !
-------------------
-- the numbers we get from this script absolute. They're the actual centigrades
-- the cpu is under the stress of. But the bar is relative and its maximum value
-- is 100. Which means that the bar can get full, and in that case, things would
-- be pretty bad ;)

local get_temperature = [[bash -c "cat /sys/class/thermal/thermal_zone*/temp | awk ' { sum += $1; num += 1 } END { print sum/num } ' | sed 's/\(^..\).*/\1/'"]]

local t = timer ({ 
    timeout = 5,
    call_now = true,
    autostart = true,
    callback = function()
        awful.spawn.easy_async(get_temperature, function(out)
            -- we actually have set up this whole circus to set the value
            temperature.temperature_widget.get_children_by_id(
                temperature.temperature_widget, 'temperature_bar')[1]
                    .value = math.floor(tonumber(out))
        end)
    end
            
})

return temperature

