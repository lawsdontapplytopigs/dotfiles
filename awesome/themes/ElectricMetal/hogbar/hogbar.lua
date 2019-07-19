

local beautiful = require("beautiful")
local file_name = "hogbar"
local resources = {}

resources.bluetooth_normal =  beautiful.theme_path .. file_name .. "/bluetooth/bluetooth_normal.svg"

resources.networking_normal = beautiful.theme_path .. file_name .. "/networking/wifi_normal.svg"

resources.bell_normal = beautiful.theme_path .. file_name .. "/notifications/bell_normal.svg"
resources.bell_hover = beautiful.theme_path .. file_name .. "/notifications/bell_hover.svg"

resources.power_normal = beautiful.theme_path .. file_name .. "/power/power_normal.svg"
resources.power_hover = beautiful.theme_path .. file_name .. "/power/power_hover.svg"

return resources
