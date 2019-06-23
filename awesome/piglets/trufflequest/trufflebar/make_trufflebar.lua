
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local cpaint = require("candypaint")
local keygrabber = require("awful.keygrabber")
local make_keys_work_function = require("piglets.trufflequest.trufflebar.keys")

local make_top_widget = require("piglets.trufflequest.trufflebar.top_widget.make_top_widget")
local make_middle_widget = require("piglets.trufflequest.trufflebar.middle_widget.make_middle_widget")
local make_bottom_widget = require("piglets.trufflequest.trufflebar.bottom_widget.make_bottom_widget")

local function make_trufflebar( args )

    local Theight = args.height or awful.screen.focused().geometry.height
    local Twidth = args.width or 30
    local Tbg = args.bg or "#00FF00"
    local tasks_resources = args.tasks_resources

    -- TODO: it doesn't seem like such a great idea to have these hardcoded
    local height_top_widget = 360 
    local height_bottom_widget = 120
    local height_middle_widget = awful.screen.focused().geometry.height - height_top_widget - height_bottom_widget

    local top_widget = make_top_widget()
    local middle_widget = make_middle_widget()
    local bottom_widget = make_bottom_widget()

    local trufflebar = wibox({
        screen = args.screen or 1,
        x = awful.screen.focused().geometry.width - Twidth,
        y = 0,
        width = Twidth,
        height = Theight,
        bg = Tbg,
        visible = args.visible,
        ontop = true,
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
        { -- The separator at the left hand side of the whole bar
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

    local mid_wid_inner = trufflebar:get_children_by_id("middle_widget_nested")[1]
    local tsks = trufflebar:get_children_by_id("TASK")

    for k, task in ipairs(tsks) do
        task:buttons(gears.table.join(
            awful.button({ }, 1, function() naughty.notify({text = "widget " .. tostring(k)}) end)
        ))
    end

    -- I hate this shit, and it'd probabbly be better if it were done through the
    -- signal mechanism of awesome. It's just that I don't know it well enough at
    -- the moment and I don't have time to work on it.
    function trufflebar.select_next_row()
        local i = mid_wid_inner:get_selected_row() + 1
        mid_wid_inner:select_row(i)
    end

    function trufflebar.select_prev_row()
        local i = mid_wid_inner:get_selected_row() - 1
        mid_wid_inner:select_row(i)
    end

    local tbar_keygrabber = make_keys_work_function({
        trufflebar = trufflebar
    })

    -- FOR DEBUGGING
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

    -- local close_buttons = trufflebar:get_children_by_id("close_bg")
    -- local postpone_buttons = trufflebar:get_children_by_id("postpone_bg")
    -- local done_buttons = trufflebar:get_children_by_id("done_bg")

    return trufflebar
end

return make_trufflebar
