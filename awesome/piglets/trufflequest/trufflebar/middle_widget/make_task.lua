
local wibox = require("wibox")
local gears = require("gears")
local utils = require("utils")
local cpaint = require("candypaint")
local naughty = require("naughty")

local function make_task( args )

    local task_width = 400
    local task_height = 90

    local description = args.description
    local task_starts = args.task_starts
    local task_ends = args.task_ends
    local task_bg = args.bg or "#e8e6f0"
    local task_fg = args.fg or "#000000"
    local time_fg = args.time_fg or task_fg

    local task = {
        widget = wibox.container.background,
        bg = "#12101e",
        forced_width = task_width,
        forced_height = task_height,
        {
            widget = wibox.container.margin,
            left = 17,
            right = 17,
            top = 6,
            bottom = 6,
            {
                id = "TASK",
                widget = wibox.container.background,
                shape = utils.rrect(4),
                bg = cpaint.darken(task_bg, 80),
                {
                    widget = wibox.container.margin,
                    bottom = 3,
                    {
                        widget = wibox.container.background,
                        shape = utils.rrect(4),
                        bg = task_bg,
                        {
                            layout = wibox.layout.align.horizontal,
                            { -- the textboxes
                                widget = wibox.container.margin,
                                top = 16,
                                bottom = 8,
                                left = 16,
                                {
                                    layout = wibox.layout.flex.vertical,
                                    {
                                        widget = wibox.container.background,
                                        fg = time_fg,
                                        {
                                            widget = wibox.widget.textbox,
                                            font = "TTCommons Medium 14",
                                            text = task_starts .. " - " .. task_ends,
                                        },
                                    },
                                    {
                                        widget = wibox.container.background,
                                        fg = task_fg,
                                        {
                                            widget = wibox.widget.textbox,
                                            font = "TTCommons 13",
                                            text = description,
                                        },
                                    },
                                },
                            },
                            { -- an empty textbox just so the layout will stretch it out
                                widget = wibox.widget.textbox,
                                text = '',
                            },
                            {
                                widget = wibox.container.margin,
                                right = 8,
                                {
                                    widget = wibox.container.background,
                                    bg = "#ee446600",
                                    forced_width = 120,
                                    {
                                        layout = wibox.layout.flex.horizontal,
                                        {
                                            id = "close_bg",
                                            widget = wibox.container.background,
                                            {
                                                widget = wibox.container.place,
                                                {
                                                    widget = wibox.container.margin,
                                                    left = 11,
                                                    right = 11,
                                                    {
                                                        widget = wibox.widget.imagebox,
                                                        -- forced_width = 24,
                                                        -- forced_height = 24,
                                                        -- resize = true,
                                                        image = os.getenv("HOME") .. "/.config/awesome/themes/NebulaBlaze/trufflequest/close.svg",
                                                    },
                                                },
                                            },
                                        },
                                        {
                                            id = "postpone_bg",
                                            widget = wibox.container.background,
                                            {
                                                widget = wibox.container.place,
                                                {
                                                    widget = wibox.container.margin,
                                                    left = 11,
                                                    right = 11,
                                                    {
                                                        widget = wibox.widget.imagebox,
                                                        image = os.getenv("HOME") .. "/.config/awesome/themes/NebulaBlaze/trufflequest/clock.svg",
                                                    },
                                                },
                                            },
                                        },
                                        {
                                            id = "done_bg",
                                            widget = wibox.container.background,
                                            -- shape = utils.prrect(4, false, true, true, false),
                                            -- bg = cpaint.lighten(task_bg, 40),
                                            {
                                                widget = wibox.container.place,
                                                {
                                                    widget = wibox.container.margin,
                                                    left = 11,
                                                    right = 11,
                                                    {
                                                        widget = wibox.widget.imagebox,
                                                        image = os.getenv("HOME") .. "/.config/awesome/themes/NebulaBlaze/trufflequest/check_mark.svg",
                                                    },
                                                },
                                            },
                                        },
                                    },
                                },
                            },
                        },
                    },
                },
            },
        },
    }
    return task
end

return make_task
