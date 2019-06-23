
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local utils = require("utils")
local gears = require("gears")

local home = os.getenv("HOME")

local system_widgets_resources = {
    {
        name = "bluetooth",
        normal_image = home .. "/.config/awesome/themes/NebulaBlaze/hogbar/bluetooth/bluetooth_240_white.svg",
        -- margins = {
            top = 13,
            bottom = 13,
        -- },
    },
    {
        name = "networking",
        normal_image = home .. "/.config/awesome/themes/NebulaBlaze/hogbar/networking/wifi_240_white.svg",
        -- margins = {
            top = 13,
            bottom = 13,
        -- },
    },
    {
        name = "notifications",
        normal_image = home .. "/.config/awesome/themes/NebulaBlaze/hogbar/notifications/bell_240_white.svg",
        hover_image = home .. "/.config/awesome/themes/NebulaBlaze/hogbar/notifications/bell_240_bright.svg",
        -- margins = {
            top = 13,
            bottom = 13,
        -- },
    },
    {
        name = "power",
        normal_image = home .. "/.config/awesome/themes/NebulaBlaze/hogbar/power/power_240_white.svg",
        hover_image = home .. "/.config/awesome/themes/NebulaBlaze/hogbar/power/power_240_bright.svg",
        -- margins = {
            top = 13,
            bottom = 13,
        -- },
        command = function()
        end,
        -- TODO: add command
    },
}

local function setup_system_buttons( args )

    local resources = args.resources
    local s = args.screen

    local all_buttons = { }

    for _, tab in pairs(resources) do
    
        local normal_image = tab.normal_image
        local hover_image = tab.hover_image or normal_image

        local system_widget = wibox.widget({
            screen = s,
            widget = wibox.container.background,
            bg = "#ff800000",
            {
                widget = wibox.container.place,
                {
                    widget = wibox.container.margin,
                    top = tab.top,
                    right = tab.right,
                    bottom = tab.bottom,
                    left = tab.left,
                    {
                        id = "button_img",
                        widget = wibox.widget.imagebox,
                        image = tab.normal_image,
                    },
                },
            }
        })

        local button_image = system_widget:get_children_by_id("button_img")[1]

        system_widget:connect_signal("mouse::enter", function()
            button_image.image = hover_image
        end)

        system_widget:connect_signal("mouse::leave", function()
            button_image.image = normal_image
        end)

        system_widget:connect_signal("button::press", function()
            button_image.image = normal_image
        end)

        system_widget:connect_signal("button::release", function()
            button_image.image = hover_image
            tab.command()
        end)

        table.insert(all_buttons, #all_buttons + 1, system_widget)
    end

    return all_buttons
end

local function make_system_buttons(s)

    local mylayoutbox = wibox.widget({
        widget = wibox.container.margin,
        top = 12,
        bottom = 12,
        {
            layout = wibox.layout.fixed.horizontal,
            awful.widget.layoutbox(s),
        },
    })
    mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    local final_system_buttons = ({
        [1] = mylayoutbox,
        spacing = 30,
        widget = wibox.container.background, 
        layout = wibox.layout.fixed.horizontal,
    })

    for _, v in pairs( setup_system_buttons({ screen = s, resources = system_widgets_resources }) ) do
        table.insert(final_system_buttons, #final_system_buttons + 1, v)
    end
    
    return wibox.widget(final_system_buttons)
end

local function make_right_widget(s)

    local setup_widget = wibox.widget({
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.container.margin,
            right = 15,
            {
                widget = wibox.container.background,
                bg = '#00ff0000',
                {
                    widget = wibox.widget.systray,
                    -- systray_icon_spacing = 200,
                    -- wibox.widget.systray(),
                },
            },
        },
        make_system_buttons(s),
    })

    return setup_widget
end

return make_right_widget
