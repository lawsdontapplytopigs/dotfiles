
local naughty = require("naughty")
local make_task = require("piglets.trufflequest.trufflebar.make_task")

local function make_middle_widget ( args )

    local tasks_resources = args.tasks_resources

    local tasks = {}

    for _, task_data in pairs(tasks_resources) do
        local task = make_task( task_data )

        task:connect_signal("button::release", function()
            naughty.notify({text = tostring("yes, it worked")})
        end)

        table.insert(tasks, #tasks + 1, task)
    end

    return tasks

end

return make_middle_widget

