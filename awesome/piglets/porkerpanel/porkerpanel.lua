
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local utils = require("utils")
local gears = require("gears")
local naughty = require("naughty")
local keygrabber = require("awful.keygrabber")

local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

local home = os.getenv("HOME")

local surf = gears.surface("/home/ciugamenn/EHGgqUq.jpg")
local img_width, img_height = gears.surface.get_size(surf)
-- local scale = searchbox_width / img_width
local bg_wid = awful.screen.focused().geometry.width / 2
local bg_height = awful.screen.focused().geometry.height
local scale = bg_height / img_height

-- if img_height * scale > bg_height then
    -- scale = bg_height / img_height
-- end

local function bg_image_function(_, cr, width, height)
    cr:translate((width - (img_width * scale)) / 2 , (height - (img_height * scale)) / 2)
    cr:rectangle(0, 0, img_width * scale, img_height * scale)
    cr:clip()
    cr:scale(scale, scale)
    cr:set_source_surface(surf)
    cr:paint()
end

local button_resources = {
    [1] = {
        image = home .. "/.config/awesome/themes/NebulaBlaze/exitpanel/poweroff/power_240_gradient.svg", 
        button_color = "#e92f52",
        border_color = "#ab003988",

        inactive_image = home .. "/.config/awesome/themes/NebulaBlaze/exitpanel/poweroff/power_240_white.svg",
        inactive_button_color = "#201e2a20",
        inactive_border_color = "#1a182400",

        pressed_image = home .. "/.config/awesome/themes/NebulaBlaze/exitpanel/poweroff/power_240_bright.svg",

        button_text = "Power off",
        border_width = 1,
        command = function()
            -- awful.spawn( [[ bash -c "shutdown now"]] )
            awful.spawn( [[bash -c "st"]] )
            keygrabber.stop(grabber)
        end,
        
    },
    
    [2] = {
        image = home .. "/.config/awesome/themes/NebulaBlaze/exitpanel/lock/key_240_gradient.svg",
        button_color = '#ffd143',
        border_color = '#b48800dd',

        inactive_image = home .. "/.config/awesome/themes/NebulaBlaze/exitpanel/lock/key_240_white.svg",
        inactive_button_color = "#201e2a20",
        inactive_border_color = "#1a182400",
        
        pressed_image = home .. "/.config/awesome/themes/NebulaBlaze/exitpanel/lock/key_240_bright.svg",

        border_width = 1,
        button_text = 'Lock',
        command = function()
            -- awful.spawn([[bash -c "dm-tool lock"]])
            awful.spawn([[bash -c "st"]])
            keygrabber.stop(grabber)
        end,
    },

    [3] = {
        image = home .. "/.config/awesome/themes/NebulaBlaze/exitpanel/suspend/pause_240_gradient.svg",
        button_color = '#551383',
        border_color = '#3f1a69dd',

        inactive_image = home .. '/.config/awesome/themes/NebulaBlaze/exitpanel/suspend/pause_240_white.svg',
        inactive_button_color = "#201e2a20",
        inactive_border_color = "#1a182400",

        pressed_image = home .. "/.config/awesome/themes/NebulaBlaze/exitpanel/suspend/pause_240_bright.svg",

        border_width = 1,
        button_text = 'Suspend',
        command = function()
            -- awful.spawn([[bash -c "dm-tool lock; systemctl suspend"]])
            awful.spawn("st")
            keygrabber.stop(grabber)
        end,
    },

    [4] = {
        image = home .. "/.config/awesome/themes/NebulaBlaze/exitpanel/reboot/reboot_240.svg",
        button_color = '#12bd80',
        border_color = '#005c30dd',

        inactive_image = home .. '/.config/awesome/themes/NebulaBlaze/exitpanel/reboot/reboot_240_white.svg',
        inactive_button_color = "#201e2a20",
        inactive_border_color = "#1a182400",

        pressed_image = home .. "/.config/awesome/themes/NebulaBlaze/exitpanel/reboot/reboot_240_bright.svg",

        border_width = 1,
        button_text = 'Reboot',
        command = function()
            -- awful.spawn([[bash -c 'reboot']])
            awful.spawn([[bash -c "st"]])
            keygrabber.stop(grabber)
        end,
    },
}


local function make_buttons ( args )

    local buttons_array = { layout = wibox.layout.flex.horizontal, _private = {} }

    for name, args in pairs(args) do

        -- buttons_array._selectable = buttons_array._selectable + 1

        local image = args.image
        local button_color = args.button_color or '#00ff00' -- if you see this ugly ass green, it means you fucked up
        local border_color = args.border_color or '#00ff00'

        local inactive_image = args.inactive_image or image
        local inactive_button_color = args.inactive_button_color or button_color or '#00ff00'
        local inactive_border_color = args.inactive_border_color or border_color or "#00ff00"

        local pressed_image = args.pressed_image or image

        local button_text = args.button_text
        local border_width = args.border_width or 0
        local command = args.command or ''

        local ret = {
            id = "button_core",
            widget = wibox.container.margin,
            left = 60,
            right = 60,
            _command = command,
            {
                widget = wibox.container.background,
                shape = gears.shape.rectangle,
                {
                    widget = wibox.container.place,
                    {
                        layout = wibox.layout.fixed.vertical,
                        spacing = 15,
                        {
                            id = 'button_bg',
                            bg = button_color,

                            shape_border_color = border_color,
                            shape_border_width = border_width,

                            _original_color = button_color,
                            _original_border_color = border_color,

                            _inactive_button_color = inactive_button_color,
                            _inactive_border_color = inactive_border_color,

                            shape = gears.shape.circle,
                            widget = wibox.container.background,
                            {
                                widget = wibox.container.margin,
                                margins = 22,
                                {
                                    widget = wibox.container.place,
                                    {
                                            id = "button_img",
                                            widget = wibox.widget.imagebox,
                                            image = image,
                                            _original_image = image,
                                            _inactive_image = inactive_image,
                                            _pressed_image = pressed_image,
                                            forced_width = 34,
                                            forced_height = 34,
                                    },
                                },
                            },
                        },
                        {
                            widget = wibox.container.place,
                            {
                                widget = wibox.container.background,
                                fg = beautiful.fg,
                                {
                                    widget = wibox.widget.textbox,
                                    font = 'TTCommons Medium 24',
                                    text = button_text,
                                },
                            },
                        },
                    },
                },
            },
        }
        table.insert(buttons_array, ret)
    end

    local buttons_widget = wibox.widget(buttons_array)

    local button_bgs = buttons_widget:get_children_by_id("button_bg")
    local button_imgs = buttons_widget:get_children_by_id("button_img")
    local button_cores = buttons_widget:get_children_by_id("button_core")

    -- mouse enter
    for i=1, #button_bgs do
        local bbg = button_bgs[i]
        local bimg = button_imgs[i]

        bbg:connect_signal("mouse::enter", function()
            bbg.bg = bbg._original_color
            bbg.shape_border_color = bbg._original_border_color
            bimg.image = bimg._original_image
        end)
    end

    -- mouse leave
    for i=1, #button_bgs do
        local bbg = button_bgs[i]
        local bimg = button_imgs[i]

        bbg:connect_signal("mouse::leave", function()
            bbg.bg = bbg._inactive_button_color
            bbg.shape_border_color = bbg._inactive_border_color
            bimg.image = bimg._inactive_image
        end)
    end

    -- mosue press
    for i=1, #button_bgs do
        local bbg = button_bgs[i]
        local bimg = button_imgs[i]

        bbg:connect_signal("button::press", function()
            bbg.bg = bbg._original_border_color
            bbg.shape_border_color = bbg._original_color
            bimg.image = bimg._pressed_image
        end)
    end

    -- mouse release
    for i=1, #button_bgs do
        local bbg = button_bgs[i]
        local bimg = button_imgs[i]
        local cmd = button_cores[i]._command
        bbg:connect_signal("button::release", function()
            
            bbg.bg = bbg._original_color
            bbg.shape_border_color = bbg._original_border_color
            bimg.image = bimg._original_image
            
            cmd()
        end)
    end

    return buttons_widget
end

local panel_background = wibox({
    x = 0,
    y = 0,
    width = screen_width,
    height = screen_height,
    visible = false,
    ontop = false,
    type = 'dock',
})

local clock = wibox.widget.textclock( "%H:%M" )
clock.font = "TTCommons DemiBold 26"
local wibar_height = 40

local fake_bar = wibox({
    x = 0,
    y = 120,
    width = screen_width,
    height = 100,
    bg = '#00000000',
    fg = beautiful.fg,
    type = 'dock',
    visible = false,
    ontop = false,
    input_passthrough = true,
})

local middle_clock = fake_bar:setup({
    widget = wibox.container.place,
    {
        layout = wibox.layout.fixed.horizontal,
        clock,
    },
})

local button_x = awful.screen.focused().geometry.width - 60
local button_y = 34
local button_height = 18
local button_width = 18

panel_background:setup({
    widget = wibox.container.background,
    bgimage = bg_image_function,
    {
        widget = wibox.container.background,
        bg = '#000000c4',
        {
            layout = wibox.layout.manual,
            {
                id = "close_panel_button",
                point = { x = button_x, y = button_y },
                forced_height = button_height,
                forced_width = button_width,
                widget = wibox.widget.imagebox,
                -- image = '/home/ciugamenn/bubble.svg',
                image = '/home/ciugamenn/.config/awesome/themes/NebulaBlaze/titlebar2/close/close_2.svg',
            },
            {
                point = { x = 0, y = 140 },
                forced_height = awful.screen.focused().geometry.height / 2, -- - button_y - button_height,
                forced_width = awful.screen.focused().geometry.width,
                widget = wibox.container.background,
                -- bg = '#00ffff88',
                bg = '#00000000',
                {
                    widget = wibox.container.place,
                    {
                        widget = wibox.widget.textbox,
                        -- bg = '#201e2a00',
                        fg = beautiful.fg,
                        -- this is nasty, but it clips the font at the end if
                        -- the font is italic and I let it scale automatically
                        forced_width = 548, 
                        font = 'TTCommons Bold Italic 80',
                        text = "Goodbye, Billy",
                    },
                },
            },
            -- Second widget: a row of buttons
            {   -- background for debugging
                point = { x = 0, y = awful.screen.focused().geometry.height / 2 },
                forced_height = awful.screen.focused().geometry.height / 2,
                forced_width = awful.screen.focused().geometry.width,
                widget = wibox.container.background,
                -- bg = '#ff000088',
                bg = '#00000000',
                {   -- `wibox.container.place` widget so it'll put the 
                    -- background containing the row of widgets in the middle
                    widget = wibox.container.place,
                    valign = 'top',
                    {
                        layout = wibox.layout.fixed.vertical,
                        {
                            widget = wibox.container.background,
                            bg = '#88008888',
                            forced_height = 100,
                        },
                        {
                            widget = wibox.container.background,
                            forced_width = 1000,
                            -- bg = '#00880088',
                            bg = '#00000000',
                            {
                                layout = wibox.layout.flex.horizontal,
                                make_buttons(button_resources),
                            },
                        },
                    },
                },
            },
        },
    },
})

-- local function select_button()
    -- for k, ------------------------------------------------------------------------------------------ LEFT OFF

local close_panel_button = panel_background:get_children_by_id("close_panel_button")[1]

close_panel_button:connect_signal("mouse::enter", function()
    close_panel_button.image = "/home/ciugamenn/.config/awesome/themes/NebulaBlaze/titlebar2/close/close_3.svg"
end)

close_panel_button:connect_signal("mouse::leave", function()
    close_panel_button.image = "/home/ciugamenn/.config/awesome/themes/NebulaBlaze/titlebar2/close/close_2.svg"
end)

close_panel_button:connect_signal("button::release", function()
    panel_background.visible = false
    fake_bar.visible = false
end)

local function run ( widget )
    
    local grabber
    local is_button_selected = false

    grabber = keygrabber.run(
    function(modifiers, key, event)
        -- Convert index array to hash table
        local mod = {}
        for _, v in ipairs(modifiers) do
            mod[v] = true
        end

        if event == "press" then
            if not is_button_selected then
                is_button_selected = true
            end
        end

        if key == 'q' or key == "Escape" then
            keygrabber.stop(grabber)
        end
        naughty.notify({text = tostring(key)})

    end)
end

local function show_panel()
    if panel_background.visible then 
        panel_background.visible = false
        fake_bar.visible = false
    else
        run()
        panel_background.visible = true
        panel_background.ontop = true
        fake_bar.visible = true
        fake_bar.ontop = true
    end
end

return show_panel
