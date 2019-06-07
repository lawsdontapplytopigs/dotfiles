
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local make_task = require("piglets.trufflequest.trufflebar.middle_widget.make_task")

local function make_middle_widget ( args )

    local tasks_resources = args.tasks_resources
    local tasks = {}

    for k, task_data in pairs(tasks_resources) do
        local task = make_task( task_data )
        table.insert(tasks, #tasks + 1, task)
    end

    return tasks

end

return make_middle_widget

