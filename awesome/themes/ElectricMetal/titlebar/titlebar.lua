
local beautiful = require("beautiful") 
local file_name = "titlebar"

local resources = {}

resources.close_normal = beautiful.theme_path .. file_name .. "/close/close_normal.svg"
resources.close_focused = beautiful.theme_path .. file_name .. "/close/close_focused.svg"
resources.close_hover = beautiful.theme_path .. file_name .. "/close/close_hover.svg"

resources.maximize_normal = beautiful.theme_path .. file_name .. "/maximize/maximize_normal.svg"
resources.maximize_focused = beautiful.theme_path .. file_name .. "/maximize/maximize_focused.svg"
resources.maximize_hover = beautiful.theme_path .. file_name .. "/maximize/maximize_hover.svg"

resources.minimize_normal = beautiful.theme_path .. file_name .. "/minimize/minimize_normal.svg"
resources.minimize_focused = beautiful.theme_path .. file_name .. "/minimize/minimize_focused.svg"
resources.minimize_hover = beautiful.theme_path .. file_name .. "/minimize/minimize_hover.svg"

return resources
