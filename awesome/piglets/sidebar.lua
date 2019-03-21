local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local utils = require("utils")

local cpu_widget = require("piglets.cpu").cpu_widget
local audio_widget = require("piglets.audio").audio_widget
local notification_audio_bar_bg = require("piglets.audio").notification_audio_bar_bg
local ram_widget = require("piglets.ram").ram_widget
local weather_widget = require("piglets.weather").weather_widget


local bar = {}

local music_widget = require("piglets.music").music_widget

-- Sometimes fonts have to be configured with weird names, different than the
-- names we usually use to refer to them. That's why, after I find a name that
-- works, I will document it here.
-- font = 'SFNSDisplay Bold 20', -- System San Francisco Font
-- font = 'BrandonGrotesqueRegular 20', -- Brandon Grotesque
-- font = 'HelveticaNeueLTCom,HelveticaNeueLTCom65Md 20',


    -- font = 'HelveticaNeueLTCom,HelveticaNeueLTCom45Lt UltraLight 60',
    -- font = 'HelveticaNeueLTCom,HelveticaNeueLTCom25UltLt Bold 20',
local clock = wibox.widget({
    align = 'center',
    -- valign = 'center',
    font = 'TTCommons DemiBold 70',
    widget = wibox.widget.textclock('%H %M'),
    })

local date = wibox.widget({
    align = 'center',
    -- valign = 'center',
    -- font = 'Gilroy-Medium 20',
    -- font = 'Mont,Mont Medium 20',
    font = 'TTCommons 26',
    -- widget = wibox.widget.textbox('Wednesday, September, 29') -- for testing
    widget = wibox.widget.textclock('%A, %B, %d')
    })

local datetime = wibox.widget({
    {
        widget = clock,
    },
    {
        widget = date,
    },
    -- expand = 'none',
    layout = wibox.layout.fixed.vertical,

})

datetime:connect_signal('button::release', function() naughty.notify({text = "wtf stop pressing!"}) end)

-- make the sidebar
bar.sidebar = wibox({ 
    x = 0, 
    y = 0,  
    ontop = false, 
    visible = false,
    type = "dock",
    height = awful.screen.focused().geometry.height,
    width = beautiful.sidebar_width or dpi(450),
    bg = beautiful.sidebar_bg or '#000000',
    fg = beautiful.sidebar_fg or '#FFFFFF',
    border_width = beautiful.border_width or 0,
    border_color = beautiful.border_color or '#ffffff',
    })


-- Show sidebar when mouse touches edge
local sidebar_displayer = wibox({ 
    x = 0,
    y = 0, 
    height = bar.sidebar.height,
    ontop = true,
    width = 1,
    visible = true, 
    opacity = 0,
})

sidebar_displayer:connect_signal( "mouse::enter", 
    function()
        bar.sidebar.visible = true
        bar.sidebar.ontop = true
        notification_audio_bar_bg.visible = false
    end
)

bar.sidebar:connect_signal( "mouse::leave", 
    function()
        bar.sidebar.visible = false
        bar.sidebar.ontop = false
    end
)

bar.sidebar:setup ({
    { -- Time & date widget
        utils.pad_height(20),
        datetime,
        layout = wibox.layout.fixed.vertical,
    },
    utils.pad_height(3),

    { -- Weather widget
        {
            weather_widget,
            utils.pad_width(20),
            layout = wibox.layout.fixed.horizontal,
        },
        halign = 'center',
        widget = wibox.container.place,
    },

    utils.pad_height(3),
    -- {
        -- utils.pad_width(100),
    music_widget,
        -- utils.pad_width(100),
        -- layout = wibox.layout.fixed.horizontal,
    -- },

    utils.pad_height(20),
    { -- Infobars
        {
            utils.pad_width(30),
            audio_widget,
            utils.pad_width(45),
            layout = wibox.layout.align.horizontal,
        },
        utils.pad_height(1),
        {
            -- utils.pad_width(15),
            utils.pad_width(30),
            cpu_widget,
            utils.pad_width(45),
            layout = wibox.layout.align.horizontal,
        },
        utils.pad_height(1),
        {
            utils.pad_width(30),
            ram_widget,
            utils.pad_width(45),
            layout = wibox.layout.align.horizontal,
        },
        layout = wibox.layout.fixed.vertical,
    },

    -- { -- down
        -- text = "foo",
        -- widget = wibox.widget.textbox
    -- },
    layout = wibox.layout.fixed.vertical,
})

return bar
