
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local menu = require("brickware.layout.menu")
local make_task = require("piglets.trufflequest.trufflebar.middle_widget.make_task")
local tasks_resources = require("piglets.trufflequest.tasks")

local function make_middle_widget ()

    local tasks_resources = tasks_resources
    local tasks = {}

    for k, task_data in pairs(tasks_resources) do
        local task = make_task( task_data )
        table.insert(tasks, #tasks + 1, task)
    end

    local middle_widget = {
        id = "middle_widget_nested",
        layout = menu.vertical,
        table.unpack(tasks),
    }

    return middle_widget

end

return make_middle_widget

