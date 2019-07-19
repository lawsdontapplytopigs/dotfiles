
local beautiful = require("beautiful")
local resources = {}

local file_name = "exitpanel"

resources.power_normal = beautiful.theme_path .. file_name .. "/poweroff/power_normal.svg"
resources.power_hover = beautiful.theme_path .. file_name .. "/poweroff/power_hover.svg"
resources.power_pressed = beautiful.theme_path .. file_name .. "/poweroff/power_pressed.svg"

resources.lock_normal = beautiful.theme_path .. file_name .. "/lock/lock_normal.svg"
resources.lock_hover = beautiful.theme_path .. file_name .. "/lock/lock_hover.svg"
resources.lock_pressed = beautiful.theme_path .. file_name .. "/lock/lock_pressed.svg"

resources.suspend_normal = beautiful.theme_path .. file_name .. "/suspend/suspend_normal.svg"
resources.suspend_hover = beautiful.theme_path .. file_name .. "/suspend/suspend_hover.svg"
resources.suspend_pressed = beautiful.theme_path .. file_name .. "/suspend/suspend_pressed.svg"

resources.reboot_normal = beautiful.theme_path .. file_name .. "/reboot/reboot_normal.svg"
resources.reboot_hover = beautiful.theme_path .. file_name .. "/reboot/reboot_hover.svg"
resources.reboot_pressed = beautiful.theme_path .. file_name .. "/reboot/reboot_pressed.svg"

return resources

