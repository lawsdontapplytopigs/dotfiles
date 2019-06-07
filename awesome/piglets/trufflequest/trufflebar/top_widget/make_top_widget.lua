local wibox = require("wibox")

local function make_top_widget ()

    local ring_1 = {
        id = "ring_1",
        widget = wibox.container.arcchart,
        colors = { "#cceeff" },
        bg = "#28677c",
        max_value = 99,
        min_value = 0,
        value = 30,
        rounded_edge = true,
        thickness = 30,
        start_angle = math.pi + math.pi / 2,
    }

    local ring_2 = {
        id = "ring_2",
        widget = wibox.container.arcchart,
        colors = { "#40cfd8" },
        bg = "#004f63",
        max_value = 99,
        min_value = 0,
        value = 30,
        rounded_edge = true,
        thickness = 30,
        start_angle = math.pi + math.pi / 2,
        ring_1,
    }

    local ring_3 = {
        id = "ring_3",
        widget = wibox.container.arcchart,
        colors = { "#40aff8" },
        bg = "#204058",
        max_value = 99,
        min_value = 0,
        value = 30,
        rounded_edge = true,
        thickness = 30,
        start_angle = math.pi + math.pi / 2,
        ring_2,
    }

    local setup_widget = {
        widget = wibox.container.margin,
        margins = 50,
        {
            widget = wibox.container.mirror, 
            reflection = { horizontal = true, vertical = false },
            ring_3,
        }
    }

    return setup_widget
end

return make_top_widget
