
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local function make_task ( args )

    local task_width = 400
    local task_height = 80

    local group = args.group
    local description = args.description
    local task_starts = args.task_starts
    local task_ends = args.task_ends
    local task_bg = args.bg or "#0f0e1a"
    local task_fg = args.fg or "#ffffff"
    local time_fg = args.time_fg or task_fg

    local task = wibox.widget ({
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.container.background,
            bg = task_bg,
            {
                layout = wibox.layout.fixed.vertical,
                {
                    widget = wibox.container.background,
                    -- point = { x = 0, y = 4 },
                    forced_height = task_height / 2 + 1,
                    forced_width = task_width - task_height,
                    -- forced_width = 10,
                    -- bg = "#ffdf88",
                    -- bg = task_bg,
                    -- bg = "#00000000",
                    fg = time_fg,
                    {
                        widget = wibox.container.margin,
                        left = 16,
                        {
                            widget = wibox.widget.textbox,
                            valign = "bottom",
                            text = task_starts .. ' - ' .. task_ends,
                            font = "TTCommons Medium 15",
                        },
                    },
                },
                {
                    widget = wibox.container.background,
                    -- point = { x = 40, y = task_height / 2 - 1},
                    forced_height = task_height / 2,
                    forced_width = task_width - task_height,
                    -- bg = task_bg,
                    -- bg = "#00000000",
                    fg = task_fg,
                    -- bg = "#ff8822",
                    {
                        widget = wibox.container.margin,
                        left = 16,
                        {
                            widget = wibox.widget.textbox,
                            text = description,
                            font = "TTCommons 14",
                        },
                    },
                },
            },
        },
        { -- checkbox
            forced_height = task_height,
            forced_width = task_height,
            widget = wibox.container.background,
            -- bg = "#006dff88",
            -- bg = "#ffd000",
            bg = task_bg,
            fg = "#000000",
            {
                layout = wibox.layout.fixed.horizontal,
                { -- separator between the texts of the task and the checkbox
                    widget = wibox.container.background,
                    forced_width = 1,
                    forced_height = task_height,
                    {
                        widget = wibox.widget.separator,
                        orientation = "vertical",
                        -- color = "#ffffff50",
                        -- color = "#00000064",
                        color = string.sub(task_fg, 1, 7) .. "66",
                        thickness = 1,
                        span_ratio = 0.4,
                    },
                },
                {
                    widget = wibox.container.margin,
                    margins = 26,
                    {
                        border_width = 2,
                        -- border_color = "#ffffffff",
                        border_color = string.sub(task_fg, 1, 7) .. "ff",
                        check_color = string.sub(task_fg, 1, 7) .. "ff",
                        -- check_color = "#000000",
                        widget = wibox.widget.checkbox,
                        shape = gears.shape.circle,
                        checked = false,
                    },
                },
            },
        },
    })

    return task
end

return make_task
