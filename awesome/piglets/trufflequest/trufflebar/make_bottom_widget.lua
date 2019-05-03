
local gears = require("gears")
local wibox = require("wibox")

local function make_bottom_widget( )

    local bottom_widget = {
        layout = wibox.layout.flex.vertical,
        {
            widget = wibox.container.margin,
            margins = 10,
            {
                widget = wibox.container.background,
                -- bg = "#121212",
                fg = "#f1f1d0",
                {
                    widget = wibox.container.place,
                    {
                        widget = wibox.widget.textbox,
                        text = "",
                    },
                },
            },
        },
        {
            layout = wibox.layout.flex.horizontal,
            {
                widget = wibox.container.margin,
                top = 0,
                right = 26,
                bottom = 22,
                left = 34,
                {
                    id = "open_panel_button",
                    widget = wibox.container.background,
                    shape = gears.shape.rounded_bar,
                    bg = "#30bfef",
                    fg = "#ffffff",
                    {
                        widget = wibox.container.place,
                        {
                            widget = wibox.widget.textbox,
                            text = "Open Panel",
                            font = "TTCommons Demibold 14",
                        },
                    },
                },
            },
            {
                widget = wibox.container.margin,
                top = 0,
                right = 34,
                bottom = 22,
                left = 26,
                {
                    id = "close_bar_button",
                    widget = wibox.container.background,
                    shape = gears.shape.rounded_bar,
                    bg = "#fe3f52",
                    fg = "#ffffff",
                    {
                        widget = wibox.container.place,
                        {
                            widget = wibox.widget.textbox,
                            text = "Exit",
                            font = "TTCommons Demibold 14",
                        },
                    },
                },
            },
        },
    }
    return bottom_widget
end

return make_bottom_widget
