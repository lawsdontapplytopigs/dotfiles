
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local utils = require("utils")
local gears = require("gears")
local keygrabber = require("awful.keygrabber")
local dpi = beautiful.xresources.apply_dpi

local home = os.getenv("HOME")

-- setting up the background for the panel
-- local surf = gears.surface( home .. "/EHGgqUq.jpg")
local surf = gears.surface( beautiful.wallpaper )
local img_width, img_height = gears.surface.get_size(surf)
-- local scale = searchbox_width / img_width
local bg_wid = awful.screen.focused().geometry.width
local bg_height = awful.screen.focused().geometry.height
local scale = bg_wid / img_width

-- if img_height * scale > bg_height then
--     scale = bg_height / img_height
-- end

local function bg_image_function(_, cr, width, height)
    cr:translate((width - (img_width * scale)) / 2 , (height - (img_height * scale)) / 2)
    cr:rectangle(0, 0, img_width * scale, img_height * scale)
    cr:clip()
    cr:scale(scale, scale)
    cr:set_source_surface(surf)
    cr:paint()
end

local panel_background = wibox({
    x = 0,
    y = 0,
    width = awful.screen.focused().geometry.width,
    height = awful.screen.focused().geometry.height,
    visible = false,
    ontop = false,
    type = 'dock',
})

local hot_corner = wibox.widget({
    widget = wibox.container.background,
    point = {x = awful.screen.focused().geometry.width - 1, y = 0},
    forced_width = 1,
    forced_height = 1,
    bg = "#ff000000",
})
hot_corner:connect_signal("mouse::enter", function()
    panel_background.visible = false
    keygrabber.stop(grabber)
end)

-- the clock on the panel
local clock = {
    widget = wibox.container.background,
    point = { x = dpi(60), y = (60) },
    forced_width = awful.screen.focused().geometry.width,
    {
        layout = wibox.layout.fixed.horizontal,
        {
            widget = wibox.widget.textclock( "%H:%M" ),
            font = "TTCommons DemiBold 26",
            
        },
    },
}

-- The goodbye text 
local goodbye_text = wibox.widget({
    point = { x = dpi(0), y = dpi(140) },
    forced_height = awful.screen.focused().geometry.height / 2,
    forced_width = awful.screen.focused().geometry.width,
    widget = wibox.container.background,
    bg = '#00000000',
    {
        widget = wibox.container.place,
        {
            id = "goodbye_text_textbox",
            widget = wibox.widget.textbox,
            fg = beautiful.fg,
            -- this is nasty, and it should scale automatically, 
            -- but it clips the font at the end if the font is 
            -- italic and I let it scale automatically
            -- forced_width = 624, 
            font = 'TTCommons Bold 80',
            text = "Goodbye, Adrian",
        },
    },
})

-- closing button
local close_panel_button = wibox.widget({
    id = "close_button",
    point = { x = awful.screen.focused().geometry.width - dpi(60), y = dpi(34)},
    forced_height = 18,
    forced_width = 18,
    widget = wibox.widget.imagebox,
    image = beautiful.theme_path .. "titlebar" .. '/close/close_focus.svg',
})
-- mouse enter
close_panel_button:connect_signal("mouse::enter", function()
    close_panel_button.image = beautiful.theme_path .. "titlebar" .. '/close/close_hover.svg'
end)
-- mouse leave
close_panel_button:connect_signal("mouse::leave", function()
    close_panel_button.image = beautiful.theme_path .. "titlebar" .. "/close/close_focused.svg"
end)
-- mouse button release
close_panel_button:connect_signal("button::release", function()
    panel_background.visible = false
    keygrabber.stop(grabber)
end)

local button_resources = {
    [1] = {
        image = beautiful.exitpanel.power_normal,
        button_color = "#ffffff00",
        -- border_color = "#ab003988",

        inactive_image = beautiful.exitpanel.power_hover,
        inactive_button_color = "#201e2a20",
        inactive_border_color = "#1a182400",

        pressed_image = beautiful.exitpanel.power_pressed,

        button_text = "Power off",
        border_width = 0,
        command = function()
            -- awful.spawn( [[ bash -c "shutdown now"]] )
            awful.spawn( [[bash -c "st"]] )
        end,
    },
    
    [2] = {
        image = beautiful.exitpanel.lock_normal,
        button_color = '#ffffff00',
        -- border_color = '#b48800dd',

        inactive_image = beautiful.exitpanel.lock_hover,
        inactive_button_color = "#201e2a20",
        inactive_border_color = "#1a182400",
        
        pressed_image = beautiful.exitpanel.lock_pressed,

        border_width = 0,
        button_text = 'Lock',
        command = function()
            -- awful.spawn([[bash -c "dm-tool lock"]])
            awful.spawn([[bash -c "st"]])
        end,
    },

    [3] = {
        image = beautiful.exitpanel.suspend_normal,
        button_color = '#ffffff00',
        -- border_color = '#3f1a69dd',

        inactive_image = beautiful.exitpanel.suspend_hover,
        inactive_button_color = "#201e2a20",
        inactive_border_color = "#1a182400",

        pressed_image = beautiful.exitpanel.suspend_pressed,

        border_width = 0,
        button_text = 'Suspend',
        command = function()
            -- awful.spawn([[bash -c "dm-tool lock; systemctl suspend"]])
            awful.spawn("st")
        end,
    },

    [4] = {
        image = beautiful.exitpanel.reboot_normal,
        button_color = '#ffffff00',
        -- border_color = '#005c30dd',

        inactive_image = beautiful.exitpanel.reboot_hover,
        inactive_button_color = "#201e2a20",
        inactive_border_color = "#1a182400",

        pressed_image = beautiful.exitpanel.reboot_pressed,

        border_width = 0,
        button_text = 'Reboot',
        command = function()
            -- awful.spawn([[bash -c 'reboot']])
            awful.spawn([[bash -c "st"]])
        end,
    },
}

local function make_buttons ( args )

    local buttons_array = { layout = wibox.layout.flex.horizontal, }
    buttons_array._arcane = { selected = 0, selectable = 0, }

    for name, args in pairs(args) do

        buttons_array._arcane.selectable = buttons_array._arcane.selectable + 1

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
                        spacing = dpi(26),
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
                                margins = dpi(32),
                                {
                                    widget = wibox.container.place,
                                    {
                                            id = "button_img",
                                            widget = wibox.widget.imagebox,
                                            image = image,
                                            _original_image = image,
                                            _inactive_image = inactive_image,
                                            _pressed_image = pressed_image,
                                            forced_width = dpi(36),
                                            forced_height = dpi(36),
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

    return wibox.widget(buttons_array)
end

local buttons_widget = make_buttons(button_resources)

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
        if i ~= buttons_widget._arcane.selected then
            bbg.bg = bbg._inactive_button_color
            bbg.shape_border_color = bbg._inactive_border_color
            bimg.image = bimg._inactive_image
        end
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
        panel_background.visible = false
        keygrabber.stop(grabber)
    end)
end

-- Let's setup the buttons hierarchy
-- Buttons
local buttons_setup = wibox.widget({
    point = { x = 0, y = awful.screen.focused().geometry.height / 2 + dpi(80) },
    forced_height = awful.screen.focused().geometry.height / 2,
    forced_width = awful.screen.focused().geometry.width,
    widget = wibox.container.background,
    bg = '#00000000',
    {   -- `wibox.container.place` widget so it'll put the 
        -- background containing the row of widgets in the middle
        widget = wibox.container.place,
        valign = 'top',
        {
            widget = wibox.container.background,
            forced_width = dpi(1200), 
            bg = '#ff000000',
            -- bg = '#00000000',
            {
                layout = wibox.layout.flex.horizontal,
                buttons_widget,
            },
        },
    },
})

-- The vi-textbox
-- TODO: Make it scroll with the cursor when the text is too long
local vi_textwidget = wibox.widget({
    widget = wibox.container.background,
    bg = '#ff000000',
    point = { 
        y = awful.screen.focused().geometry.height - dpi(110), 
        x = awful.screen.focused().geometry.width - dpi(300),
    },
    forced_width = dpi(200),
    {
        layout = wibox.layout.fixed.horizontal,
        {
            id = "vi_textbox",
            widget = wibox.widget.textbox,
            font = "TTCommons 16",
        },
    },
})

panel_background:setup({
    widget = wibox.container.background,
    bgimage = bg_image_function,
    {
        widget = wibox.container.background,
        bg = '#000000a4',
        {
            layout = wibox.layout.manual,
            hot_corner,
            clock,
            close_panel_button,
            goodbye_text,
            buttons_setup,
            vi_textwidget,
        },
    },
})

local function run ( args ) 

    local panel             = args.panel -- the background panel
    local buttons           = args.buttons -- the buttons widget
    local button_bgs        = buttons:get_children_by_id("button_bg")
    local button_imgs       = buttons:get_children_by_id("button_img")
    local cores             = buttons:get_children_by_id("button_core")
    local arc               = buttons._arcane     -- private data
    local vi_textbox        = vi_textwidget:get_children_by_id("vi_textbox")[1]
    -- sometimes we want all keygrabbers to stop.
    local all_keygrabbers_should_stop = false

    local function select_button ( nr )

        -- make sure we stay in the range from 1 up to `arc.selectable`
        if type(nr) == 'number' then
            arc.selected = nr
        elseif nr == "+1" then
            arc.selected = arc.selected + 1
        elseif nr == "-1" then
            arc.selected = arc.selected - 1
        end

        if arc.selected > arc.selectable then
            arc.selected = arc.selectable
        elseif arc.selected < 1 then
            arc.selected = 1
        end

        -- set the bg, img, etc for the now unselected widgets
        for k, obbg in pairs(button_bgs) do
            obbg.bg = obbg._inactive_button_color
            obbg.shape_border_color = obbg._inactive_border_color
        end
        for _, obimg in pairs(button_imgs) do
            obimg.image = obimg._inactive_image
        end

        -- set the bg, img, etc for the newly selected widget
        local bbg = button_bgs[arc.selected]
        local bimg = button_imgs[arc.selected]
        bbg.bg = bbg._original_color
        bbg.shape_border_color = bbg._original_border_color
        bimg.image = bimg._original_image
    end

    local function press_button(num)
        if num then
            select_button( num )
        end
        keygrabber.stop(grabber)
        panel_background.visible = false
        cores[arc.selected]._command()
    end

    local function vi_command_parse(command)
        -- TODO: Ideally, we wouldn't just hardcode these buttons 
        -- and their respective numbers in, but instead, we'd just
        -- look for each button's name and select its number automatically
        if command == "reboot" 
        or command == "restart" then  
            press_button(1)
            all_keygrabbers_should_stop = true

        elseif command == "power off" 
        or command == "poweroff"
        or command == "shutdown" 
        or command == "shut down" then
            press_button(2)
            all_keygrabbers_should_stop = true

        elseif command == "lock" then
            press_button(3)
            all_keygrabbers_should_stop = true

        elseif command == "suspend" then
            press_button(4)
            all_keygrabbers_should_stop = true

        elseif
            command == "w" or command == "wq" then
            press_button()
            all_keygrabbers_should_stop = true

        -- if it's just a number
        elseif tonumber(command) then
            select_button(tonumber(command))

        elseif command == "q" then
            panel_background.visible = false
            keygrabber.stop(grabber)

        elseif command == "gn" then
            local goodbye_textbox = goodbye_text:get_children_by_id("goodbye_text_textbox")[1]
            goodbye_textbox._old_text = goodbye_textbox.text
            goodbye_textbox.text = "gn UwU"

            local uwu = gears.timer({ timeout = 3, autostart = true })
            
            uwu:connect_signal('timeout',
                function()
                    uwu:stop()
                    press_button(2)
                    goodbye_textbox.text = goodbye_textbox._old_text
                end
            )
        end
    end

    local function keygrabber_vim_config_callback(modifiers, key, event)
        if arc.selected == 0 then
            arc.selected = 1
        end

        -- Convert index array to hash table
        local mod = {}
        for _, v in ipairs(modifiers) do
            mod[v] = true
        end

        if event ~= "press" then
            return
        end

        -- exit cases
        if key == "q" or key == "Escape" then
            keygrabber.stop(grabber)
            panel.visible = false

        elseif key == "l" then
            select_button( "+1" )

        elseif key == "h" then
            select_button( "-1" )

        elseif key == "Return" then
            press_button()

        elseif key == ":" then
            keygrabber.stop(grabber)
            awful.prompt.run ({
                prompt = ":",
                font = "TTCommons Medium 16",
                textbox = vi_textbox,
                exe_callback = vi_command_parse,
                done_callback = function() 
                    -- since in this version of awesome we can't have nested keygrabbers
                    -- we'll just stitch the keygrabbers together so that when
                    -- one stops, the other one starts to give that illusion
                    if not all_keygrabbers_should_stop then
                        keygrabber.run(keygrabber_vim_config_callback)
                    end
                end,
            })

        elseif key == "/" then
            
            awful.prompt.run ({
                prompt = "/",
                font = "TTCommons Medium 16",
                textbox = vi_textbox,
                exe_callback = function( command )

                    -- TODO: just like in the ":" prompt, the hardcoded names
                    -- and numbers should go away
                    if command == "reboot"  
                    or command == "restart" then  
                        select_button( 1 )

                    elseif command == "power off"
                    or command == "poweroff"
                    or command == "shut down"
                    or command == "shutdown" then
                        select_button( 2 )

                    elseif command == "lock" then
                        select_button( 3 )

                    elseif command == "suspend" then
                        select_button( 4 )
                    end
                end,

                done_callback = function() 
                    -- same stitching as above
                    -- but here we'll always jump back to the "outer" keygrabber
                    keygrabber.run(keygrabber_vim_config_callback)
                end,
            })

        end
    end

    local grabber = keygrabber.run(keygrabber_vim_config_callback)
end

local function show_panel()
    if panel_background.visible then 
        panel_background.visible = false
    else
        run({
            panel = panel_background, 
            buttons = buttons_widget,
        })
        panel_background.visible = true
        panel_background.ontop = true
    end
end

return show_panel
