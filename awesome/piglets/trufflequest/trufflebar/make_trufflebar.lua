
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local menu = require("piglets.trufflequest.trufflebar.menu")
local make_top_widget = require("piglets.trufflequest.trufflebar.make_top_widget")
local make_middle_widget = require("piglets.trufflequest.trufflebar.make_middle_widget")
local make_bottom_widget = require("piglets.trufflequest.trufflebar.make_bottom_widget")

naughty.notify({text = tostring(type(menu))})

local function make_trufflebar( args )

    local Theight = args.height or awful.screen.focused().geometry.height
    local Twidth = args.width or 30
    local Tbg = args.bg or "#00FF00"

    local height_top_widget = 360
    local height_middle_widget = 600
    local height_bottom_widget = 120

    -- setup top widget
    local top_widget = make_top_widget()

    -- setup middle widget
    local middle_widget = { 
        layout = wibox.layout.fixed.vertical, 
        spacing = 1,
        spacing_widget = wibox.widget({
            widget = wibox.widget.separator,
            orientation = "horizontal",
            thickness = 1,
            -- span_ratio = 0.7,
            color = "#ffffff33",
        })
    }

    local tasks = make_middle_widget({
        task_width = Twidth,
        tasks_resources = args.tasks,
    })

    for k, v in ipairs(tasks) do 
        table.insert(middle_widget, #middle_widget + 1, v) 
    end

    -- setup bottom widget
    local bottom_widget = make_bottom_widget()

    local trufflebar = wibox({
        screen = args.screen or 1,
        x = awful.screen.focused().geometry.width - Twidth,
        y = 0,
        width = Twidth,
        height = Theight,
        bg = Tbg,
        visible = args.visible,
    })

    trufflebar:setup({
        layout = wibox.layout.manual,
        {
            widget = wibox.container.background,
            point = { x = 0, y = 0 },
            forced_height = height_top_widget,
            forced_width = Twidth,
            bg = "#ff008000",
            fg = "#ffffff",
            {
                layout = wibox.layout.fixed.vertical,
                    top_widget,
            },
        },
        {
            id = "middle_widget",
            -- widget = wibox.container.scroll.vertical,
            widget = menu.vertical,
            point = { x = 0, y = height_top_widget},
            forced_height = height_middle_widget,
            forced_width = Twidth,
            max_size = height_middle_widget,
            step_function = wibox.container.scroll.step_functions
                            .linear_back_and_forth,
            speed = 100,
            fps = 60,
            bg = "#ff888800",
            fg = "#ffffff",
                middle_widget,
        },
        {
            -- id = "bottom_widget"
            widget = wibox.container.background,
            point = { x = 0, y = height_top_widget + height_middle_widget },
            forced_height = height_bottom_widget,
            forced_width = Twidth,
            bg = "#00ff8000",
            fg = "#ffffff",
                bottom_widget,
        },

        -- From here on to the end I put the widgets that act as separators.
        -- I did it because I want them drawn last, so they'll be above any other widget
        {
            widget = wibox.container.place,
            point = { x = 0, y = height_top_widget - 4 },
            forced_height = 4,
            {
                widget = wibox.widget.separator,
                orientation = "horizontal",
                color = "#00000031",
                thickness = 4,
                span_ratio = 1,
            },
        },
        {
            widget = wibox.container.place,
            point = { x = 0, y = height_top_widget + height_middle_widget },
            forced_height = 4,
            {
                widget = wibox.widget.separator,
                orientation = "horizontal",
                color = "#00000031",
                thickness = 4,
                span_ratio = 1,
            },
        },
        {
            widget = wibox.container.place,
            point = { x = -Twidth / 2, y = 0 },
            forced_height = awful.screen.focused().geometry.height,
            {
                widget = wibox.widget.separator,
                orientation = "vertical",
                thickness = 4,
                color = "#ffffff23",
            },
        },
    })

    -- local made_middle_widget = trufflebar:get_children_by_id("middle_widget")[1]
    -- made_middle_widget:pause()

    return trufflebar
end

return make_trufflebar
