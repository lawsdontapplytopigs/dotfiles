
-- global core api used:
    -- client

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local utils = require("utils")
local cpaint = require("candypaint")
local titlebars = {}

function titlebars.normal_tbar( args )

    local c = args.client
    local buttons = args.buttons
    local left = {
        -- awful.titlebar.widget.iconwidget(c),
        utils.pad_width(14),
        {
            font = beautiful.font,
            widget = awful.titlebar.widget.titlewidget(c),
        },
        buttons = buttons,
        layout  = wibox.layout.fixed.horizontal,
    }

    local middle = {
        buttons = buttons,
        layout  = wibox.layout.flex.horizontal,
    }

    local right = {
        -- awful.titlebar.widget.floatingbutton (c),
        -- awful.titlebar.widget.stickybutton   (c),
        -- awful.titlebar.widget.ontopbutton    (c),
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.container.place,
            {
                widget = wibox.container.margin,
                top = 13,
                bottom = 13,
                left = 6,
                right = 6,
                {
                    layout = wibox.layout.fixed.horizontal,
                    awful.titlebar.widget.minimizebutton(c),
                },
            },
        },
        {
            widget = wibox.container.place,
            {
                widget = wibox.container.margin,
                top = 13,
                bottom = 13,
                left = 6,
                right = 6,
                {
                    layout = wibox.layout.fixed.horizontal,
                    awful.titlebar.widget.maximizedbutton(c),
                },
            },
        },
        {
            widget = wibox.container.place,
            {
                widget = wibox.container.margin,
                top = 13,
                bottom = 13,
                left = 6,
                right = 10,
                {
                    layout = wibox.layout.fixed.horizontal,
                    awful.titlebar.widget.closebutton(c),
                },
            },
        },
    }

    local titlebar = {
        layout = wibox.layout.fixed.vertical,
        {
            widget = wibox.widget.separator,
            color  = '#ddccff40',
            forced_height = 1,
        },
        {
            widget = wibox.widget.separator,
            -- color  = '#c8b0ff60',
            color  = '#ddaaff30',
            -- color = cpaint.lighten(beautiful.titlebar_bg_normal, 50),
            forced_height = 1,
        },
        {
            widget = wibox.container.margin,
            bottom = 1,
            {
                layout = wibox.layout.align.horizontal,
                left,
                middle,
                right,
            },
        }, 
    }
    return titlebar
end

return titlebars

-- Code that shows how to add multiple titlebars.
-- also shows some stuff about cairo, whici I might look at later
-- client.connect_signal("request::titlebars", function(c)
    -- local my_widget = wibox.widget.base.make_widget()
    -- function my_widget:draw(_, cr, width, height)
        -- cr:set_operator(cairo.Operator.SOURCE)
        -- cr:set_source(gears.color.create_linear_pattern{
            -- from = { 0, 0 },
            -- to = { width, 0 },
            -- stops = {
                -- { 0, "#f000" },
                -- { 1, "#0f0f" },
            -- },
        -- })
        -- cr:paint()
    -- end
    -- awful.titlebar(c, { position = "bottom" }):set_widget(my_widget)
-- end)
