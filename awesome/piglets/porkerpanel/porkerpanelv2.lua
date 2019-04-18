
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local utils = require("utils")

-- Potentially useful colors
-- shape_border_color = '#48444e44',
-- shape_border_color = '#88848e44',


local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

local panel_background = wibox({
    x = 0,
    y = 0,
    width = screen_width,
    height = screen_height,
    visible = false,
    ontop = false,
    type = 'dock',
    bg = '#201e22d0',
})

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
    cr:translate((width - (img_width * scale)) / 2 + width / 2, (height - (img_height * scale)) / 2)
    cr:rectangle(0, 0, img_width * scale, img_height * scale)
    cr:clip()
    cr:scale(scale, scale)
    cr:set_source_surface(surf)
    cr:paint()
end

local right_hand_side = wibox.widget({
    widget = wibox.container.background,
    -- bgimage = '/home/ciugamenn/EHGgqUq.jpg',
    bgimage = bg_image_function,
    -- bg = '#eee00088',
    shape_border_width = 4,
    shape_border_color = '#18141e00',
    {
        widget = wibox.container.background,
        bg = '#00000055',
        {
            layout = wibox.layout.flex.vertical,
            {
                widget = wibox.container.background,
                -- bg = '#eee00080',
                {
                    widget = wibox.container.place,
                    {
                        widget = wibox.widget.textbox,
                        text = 'Goodbye, Billie',
                        fg = beautiful.fg,
                        font = 'TTCommons Bold Italic, 80',
                    },
                },
            },
            {
                widget = wibox.container.margin,
                -- margins = 60,
                left = 100,
                right = 100,
                bottom = 60,
                {
                    widget = wibox.container.background,
                    shape = utils.rrect(8),
                    shape_border_width = 1,
                    bg = '#201e22c0',
                    
                    {
                        widget = wibox.widget.textbox,
                    },
                },
            },
        },
    },
})

local left_hand_side = wibox.widget({
    widget = wibox.container.background,
    bg = '#201e2200',
    
})

panel_background:setup({
    layout = wibox.layout.flex.horizontal,
    left_hand_side,
    right_hand_side,
})

local function show_panel()
    panel_background.visible = not panel_background.visible
    panel_background.ontop = not panel_background.ontop
end

return show_panel
