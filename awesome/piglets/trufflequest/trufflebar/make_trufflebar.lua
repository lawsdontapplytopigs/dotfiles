
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local menu_layout = require("piglets.trufflequest.trufflebar.menu_project")
local make_top_widget = require("piglets.trufflequest.trufflebar.make_top_widget")
local make_middle_widget = require("piglets.trufflequest.trufflebar.make_middle_widget")
local make_bottom_widget = require("piglets.trufflequest.trufflebar.make_bottom_widget")

-- naughty.notify({text = tostring(type(menu))})

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
        id = "middle_widget_nested",
        layout = wibox.layout.fixed.vertical, 
        -- layout = wibox.layout.fixed.horizontal,
        -- layout = menu_layout.vertical,
        spacing = 1,
        spacing_widget = wibox.widget({
            widget = wibox.widget.separator,
            orientation = "horizontal",
            thickness = 1,
            -- span_ratio = 0.7,
            color = "#ffffff33",
        })
    }

    -- button_signal("button::press")
    -- button_signal("button::release")



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

    -- naughty.notify({text = tostring(type(middle_widget))})
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
            layout = menu_layout.vertical,
            -- layout = menu_layout.vertical,
            -- layout = menu_layout.horizontal,
            -- layout = wibox.layout.fixed.vertical,
            point = { x = 0, y = height_top_widget},
            forced_height = height_middle_widget,
            forced_width = Twidth,
            step_function = wibox.container.scroll.step_functions
                            .linear_back_and_forth,
            speed = 100,
            fps = 60,
            bg = "#ff8888ff",
            fg = "#ffffff",
            -- expand = true,
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

    -- local mid_wid_outer = trufflebar:get_children_by_id("middle_widget")[1]
    -- local mid_wid_inner = trufflebar:get_children_by_id("middle_widget_nested")[1]

    -- gears.timer.start_new(1, function()
        -- naughty.notify({text = tostring(mid_wid_outer.my_width)})
        -- return true
    -- end)

    -- made_mid_wid:reset()
    -- made_middle_widget:pause()
    -- naughty.notify({text = tostring(type(made_middle_widget:get_children()))})
    -- for k, v in pairs(made_mid_wid:get_all_children()) do
        -- naughty.notify({text = tostring(k) .. '     ' .. tostring(v), timeout = 0})
    -- end

    return trufflebar
end

return make_trufflebar
