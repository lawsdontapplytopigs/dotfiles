
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
-- local menu = require("brickware.layout.menu")
-- local menu = require("brickware.layout.custom_fixed")
local menu = require("brickware.layout.menu")
local cpaint = require("candypaint")
local make_top_widget = require("piglets.trufflequest.trufflebar.top_widget.make_top_widget")
local make_middle_widget = require("piglets.trufflequest.trufflebar.middle_widget.make_middle_widget")
local make_bottom_widget = require("piglets.trufflequest.trufflebar.bottom_widget.make_bottom_widget")

local function setup_middle_widget (args)

    local tasks_width = args.tasks_width
    local tasks_res = args.tasks_resources
    -- this is just a table containing tables (which can be turned into widgets),
    -- but they first need a layout.
    local tasks = make_middle_widget({
        task_width = tasks_width,
        tasks_resources = tasks_res,
    })

    local middle_widget = {
        id = "middle_widget_nested",
        layout = menu.vertical,
        table.unpack(tasks),
    }

    return middle_widget

end

local function make_trufflebar( args )

    local Theight = args.height or awful.screen.focused().geometry.height
    local Twidth = args.width or 30
    local Tbg = args.bg or "#00FF00"
    local tasks_resources = args.tasks_resources

    local height_top_widget = 360
    local height_middle_widget = 600
    local height_bottom_widget = 120

    -- setup top widget
    local top_widget = make_top_widget()

    -- setup middle widget
    local middle_widget = setup_middle_widget({
        tasks_width = Twidth,
        tasks_resources = tasks_resources,
    })


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
            -- layout = wibox.layout.fixed.vertical,
            widget = wibox.container.background,
            point = { x = 0, y = height_top_widget},
            forced_height = height_middle_widget,
            forced_width = Twidth,
                middle_widget,
        },
        {
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
    local mid_wid_inner = trufflebar:get_children_by_id("middle_widget_nested")[1]
    local tsks = trufflebar:get_children_by_id("TASK")

    for k, task in ipairs(tsks) do
        task:buttons(gears.table.join(
            awful.button({ }, 1, function() naughty.notify({text = "widget " .. tostring(k)}) end)
        ))
    end

    local function select_next_row()
        local i = mid_wid_inner:get_selected_row() + 1
        mid_wid_inner:select_row(i)
    end

    local function select_prev_row()
        local i = mid_wid_inner:get_selected_row() - 1
        mid_wid_inner:select_row(i)
    end

    -- local direction = false
    -- gears.timer.start_new(1, function()
        -- if mid_wid_inner:get_selected_row() == 1 then
            -- naughty.notify({text = tostring("changed to false")})
            -- direction = false
        -- elseif #mid_wid_inner:get_children() == mid_wid_inner:get_selected_row() then
            -- direction = true
            -- naughty.notify({text = tostring("just changed direction to true")})
        -- end
        -- if direction == false then
            -- select_next_row()
        -- else
            -- select_prev_row()
        -- end
        -- return true
    -- end)

    -- these most likeky work, it's just that the 
    -- layout I'm using isn't set up to handle mouse events yet
    local close_buttons = trufflebar:get_children_by_id("close_bg")
    local postpone_buttons = trufflebar:get_children_by_id("postpone_bg")
    local done_buttons = trufflebar:get_children_by_id("done_bg")

    for _, bttn in pairs(close_buttons) do 
        bttn:connect_signal("mouse::enter", function() -- I'm really not sure, but this might just give me a stack overflow if I change the signal to `"mouse::move"`
            bttn.backup_bg = bttn.bg
            -- bttn.bg = cpaint.lighten(bttn.bg, 40)
            bttn.bg = "#ff4455"
            naughty.notify({text = tostring("mouse broke")})
        end)
        bttn:connect_signal("mouse::leave", function()
            if bttn.backup_bg then
                bttn.bg = backup_bg
            end
            naughty.notify({text = tostring("mouse broke")})
        end)
    end

    -- for _, bttn in pairs(postpone_buttons) do
        -- bttn:connect_signal("mouse::enter", function()
            -- bttn.backup_bg = bttn.bg
            -- bttn.bg = cpaint.lighten(bttn.bg, 40)
        -- end)
        -- bttn:connect_signal("mouse::leave", function()
            -- if bttn.backup_bg then
                -- bttn.bg = backup_bg
            -- end
        -- end)
    -- end
-- 
    -- for _, bttn in pairs(done_buttons) do
        -- bttn:connect_signal("mouse::enter", function()
            -- bttn.backup_bg = bttn.bg
            -- bttn.bg = cpaint.lighten(bttn.bg, 40)
        -- end)
        -- bttn:connect_signal("mouse::leave", function()
            -- if bttn.backup_bg then
                -- bttn.bg = backup_bg
            -- end
        -- end)
    -- end

    return trufflebar
end

return make_trufflebar
