
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local utils = require("utils")
local gears = require("gears")

local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

-- Potentially helpful colors
-- '#201e22'

local surf = gears.surface("/home/ciugamenn/EHGgqUq.jpg")
local img_width, img_height = gears.surface.get_size(surf)
-- local scale = searchbox_width / img_width
local bg_wid = awful.screen.focused().geometry.width / 2
local bg_height = awful.screen.focused().geometry.height
local scale = bg_height / img_height

-- if img_height * scale > bg_height then
    -- scale = bg_height / img_height
-- end

local function bg_image_function(_, cr, width, height)
    cr:translate((width - (img_width * scale)) / 2 , (height - (img_height * scale)) / 2)
    cr:rectangle(0, 0, img_width * scale, img_height * scale)
    cr:clip()
    cr:scale(scale, scale)
    cr:set_source_surface(surf)
    cr:paint()
end

local power_off = wibox.widget({
    widget = wibox.container.margin,
    left = 60,
    right = 60,
    {
        widget = wibox.container.background,
        -- bg = '#18162288',
        -- bg = '#36343888',
        -- bg = '#6688de88',
        shape = gears.shape.rectangle,
        shape_border_color = '#161a1e88',
        {
            widget = wibox.container.place,
            {
                layout = wibox.layout.fixed.vertical,
                spacing = 15,
                {
                    widget = wibox.widget.background,
                    -- bg = '#22800099',
                    shape_border_color = '#ab003988',
                    shape_border_width = 4,
                    bg = '#e92f52',
                    shape = gears.shape.circle,
                    {
                        widget = wibox.container.margin,
                        margins = 28,
                        {
                            widget = wibox.container.place,
                            {
                                    widget = wibox.widget.imagebox,
                                    image = "/home/ciugamenn/.config/awesome/themes/NebulaBlaze/exitpanel/poweroff/power240gradientred.svg",
                                    forced_width = 42,
                                    forced_height = 42,
                            },
                        },
                    },
                },
                {
                    widget = wibox.container.place,
                    {
                        widget = wibox.container.background,
                        fg = beautiful.fg,
                        {
                            widget = wibox.widget.textbox,
                            font = 'TTCommons Medium 24',
                            text = 'Power off',
                        },
                    },
                },
            },
        },
    },
})

local lock = wibox.widget({
    widget = wibox.container.margin,
    left = 60,
    right = 60,
    {
        widget = wibox.container.background,
        -- bg = '#18162288',
        -- bg = '#36343888',
        -- bg = '#6688de88',
        shape = gears.shape.rectangle,
        shape_border_color = '#161a1e88',
        {
            widget = wibox.container.place,
            {
                layout = wibox.layout.fixed.vertical,
                spacing = 15,
                {
                    widget = wibox.widget.background,
                    -- bg = '#22800099',
                    -- shape_border_color = '#fff16044',
                    shape_border_color = '#b48800dd',
                    shape_border_width = 2,
                    bg = '#ffd143',
                    shape = gears.shape.circle,
                    {
                        widget = wibox.container.margin,
                        margins = 28,
                        {
                            widget = wibox.container.place,
                            {
                                    widget = wibox.widget.imagebox,
                                    image = "/home/ciugamenn/.config/awesome/themes/NebulaBlaze/exitpanel/lock/key240gradient.svg",
                                    forced_width = 42,
                                    forced_height = 42,
                            },
                        },
                    },
                },
                {
                    widget = wibox.container.place,
                    {
                        widget = wibox.container.background,
                        fg = beautiful.fg,
                        {
                            widget = wibox.widget.textbox,
                            font = 'TTCommons Medium 24',
                            text = 'Lock',
                        },
                    },
                },
            },
        },
    },
})


local suspend = wibox.widget({
    widget = wibox.container.margin,
    left = 60,
    right = 60,
    {
        widget = wibox.container.background,
        -- bg = '#18162288',
        -- bg = '#36343888',
        -- bg = '#6688de88',
        shape = gears.shape.rectangle,
        shape_border_color = '#161a1e88',
        {
            widget = wibox.container.place,
            {
                layout = wibox.layout.fixed.vertical,
                spacing = 15,
                {
                    widget = wibox.widget.background,
                    -- bg = '#22800099',
                    shape_border_color = '#3f1a69dd',
                    shape_border_width = 2,
                    bg = '#551383',
                    shape = gears.shape.circle,
                    {
                        widget = wibox.container.margin,
                        margins = 28,
                        {
                            widget = wibox.container.place,
                            {
                                    widget = wibox.widget.imagebox,
                                    image = "/home/ciugamenn/.config/awesome/themes/NebulaBlaze/exitpanel/suspend/pause_240_gradient.svg",
                                    forced_width = 42,
                                    forced_height = 42,
                            },
                        },
                    },
                },
                {
                    widget = wibox.container.place,
                    {
                        widget = wibox.container.background,
                        fg = beautiful.fg,
                        {
                            widget = wibox.widget.textbox,
                            font = 'TTCommons Medium 24',
                            text = 'Suspend',
                        },
                    },
                },
            },
        },
    },
})

local reboot = wibox.widget({
    widget = wibox.container.margin,
    left = 60,
    right = 60,
    {
        widget = wibox.container.background,
        -- bg = '#18162288',
        -- bg = '#36343888',
        -- bg = '#6688de88',
        shape = gears.shape.rectangle,
        shape_border_color = '#161a1e88',
        {
            widget = wibox.container.place,
            {
                layout = wibox.layout.fixed.vertical,
                spacing = 15,
                {
                    widget = wibox.widget.background,
                    -- bg = '#22800099',
                    shape_border_color = '#005c30dd',
                    -- shape_border_color = '#12bd80',
                    shape_border_width = 2,
                    bg = '#12bd80',
                    -- bg = '#005c30ff',
                    shape = gears.shape.circle,
                    {
                        widget = wibox.container.margin,
                        margins = 28,
                        {
                            widget = wibox.container.place,
                            {
                                    widget = wibox.widget.imagebox,
                                    image = "/home/ciugamenn/.config/awesome/themes/NebulaBlaze/exitpanel/reboot/reboot_240.svg",
                                    forced_width = 42,
                                    forced_height = 42,
                            },
                        },
                    },
                },
                {
                    widget = wibox.container.place,
                    {
                        widget = wibox.container.background,
                        fg = beautiful.fg,
                        {
                            widget = wibox.widget.textbox,
                            font = 'TTCommons Medium 24',
                            text = 'Reboot',
                        },
                    },
                },
            },
        },
    },
})

local panel_background = wibox({
    x = 0,
    y = 0,
    width = screen_width,
    height = screen_height,
    visible = false,
    ontop = false,
    type = 'dock',
    -- bg = '#201e22d0',
})

panel_background:setup({
    widget = wibox.widget.background,
    bgimage = bg_image_function,
    {
        widget = wibox.widget.background,
        bg = '#000000b4',
        {
            layout = wibox.layout.flex.vertical,
            {
                widget = wibox.container.margin,
                top = 200,
                {   -- background for debugging
                    widget = wibox.container.background,
                    -- bg = '#00ffff88',
                    bg = '#00000000',
                    {   -- a `place` container so it'll put the text in the middle for us
                        widget = wibox.container.place,
                        {   -- now let's actually make the textbox
                            widget = wibox.widget.textbox,
                            -- bg = '#201e2a00',
                            fg = beautiful.fg,
                            forced_width = 548,
                            font = 'TTCommons Bold Italic 80',
                            text = "Goodbye, Billy",
                        },
                    },
                },
            },
            -- Second widget: a row of buttons
            {
                widget = wibox.container.margin,
                bottom = 200,
                {   -- background for debugging
                    widget = wibox.container.background,
                    -- bg = '#ff000088',
                    bg = '#00000000',
                    {   -- `wibox.container.place` widget so it'll put the 
                        -- background containing the row of widgets in the middle
                        widget = wibox.container.place,
                        valign = 'top',
                        {
                            widget = wibox.container.background,
                            forced_width = 1000,
                            -- bg = '#00880088',
                            bg = '#00000000',
                            {
                                layout = wibox.layout.flex.horizontal,
                                -- THIS IS WHERE EACH BUTTON BEGINS
                                power_off,
                                lock,
                                suspend,
                                reboot,
                            },
                        },
                    },
                },
            },
        },
    },
})

local function show_panel()
    panel_background.visible = not panel_background.visible
    panel_background.ontop = not panel_background.ontop
end

return show_panel
