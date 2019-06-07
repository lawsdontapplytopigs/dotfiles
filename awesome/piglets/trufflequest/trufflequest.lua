
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

local tasks_resources = require("piglets.trufflequest.tasks")
local make_trufflebar = require("piglets.trufflequest.trufflebar.make_trufflebar")
-- local make_trufflepanel = require("piglets.trufflequest.trufflepanel")

local module = {}

local tbar_resources = {
    x = awful.screen.focused().geometry.width - 400,
    y = 0,
    width = 400,
    height = awful.screen.focused().geometry.height,
    bg = beautiful.bg,
    visible = false,
    tasks_resources = tasks_resources,
}
-- local tpanel_resources = {}

local trufflebar = make_trufflebar(tbar_resources)

-- naughty.notify({text = tostring(module.trufflebar)})
-- module.trufflepanel = make_trufflepanel(tpanel_resources)

-- lord, forgive me. This is going to be ugly, but I need some functionality to
-- exist in the same scope, so I can have certain things interact. I hope I'm
-- going to be able to do this some better way in the future.

-- trufflebar:get_children_by_id("

module.trufflebar = trufflebar

return module
