
-- Directory where themes are located
local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/"

-- Themes
local theme_collection = {
    "NebulaBlaze"
}

-- Change this number to use a different theme
local theme_name = theme_collection[1]

-- Theme handling library
local beautiful = require("beautiful")
beautiful.init( theme_dir .. theme_name .. '/' .. "theme.lua" )

-- Programs to start up automatically
local startup_programs = require("startup")
-- General library
local gears = require("gears")
-- General default built-in awesome widgets and functionality
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Notification library
local naughty = require("naughty")
local radical = require("radical")

-- kill the previously running 'subscribed' scripts
-- otherwise they'll accumulate across awesome-wm restarts
local pactl_cleanup = [[bash -c "ps aux | grep '[0-9] pactl subscribe' | awk '{ print $2 }' | xargs kill"]]
awful.spawn(pactl_cleanup)

local mpc_cleanup = [[bash -c "ps aux | grep '[0-9] mpc idleloop player' | awk '{ print $2 }' | xargs kill"]]
awful.spawn(mpc_cleanup)

local piglets = require("piglets")

-- Key bindings
local keys = require("keys")

-- utility functions
local utils = require("utils")

local cairo = require("lgi").cairo

------------------------------------------------------------------------------- ERROR HANDLING
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors,
                     font = beautful.font
                     })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)

        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ title = "OWIE",
                         text = tostring(err),
                         font = beautiful.font
                         })
        in_error = false
    end)
end
------------------------------------------------------------------------------- 
-- END ERROR HANDLING

-- local wb = wibox({
    -- x = 0,
    -- y = 30,
    -- height = awful.screen.focused().geometry.height- 30,
    -- width = 40,
    -- visible = true,
    -- bg = '#883300',
-- })

-- wb:struts({x = 0, y = 30, height = awful.screen.focused().geometry.height - 30, width = 40,})

-- autostart programs
for _, v in pairs(startup_programs) do
    awful.spawn.once(v)
end

screen.connect_signal('refresh', function(c) return c end)

------------------------------------------------------------------------------- RULES
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
        properties = { 
                       -- border_width = beautiful.border_width,
                       -- border_color = beautiful.border_normal,
                       border_width = 1,
                       -- border_color = "#161a13",
                       border_color = '#201e2a',
                       focus = awful.client.focus.filter,
                       raise = true,
                       keys = keys.globalkeys,
                       buttons = keys.clientbuttons,
                       maximized_vertical = false,
                       maximized_horisontal = false,
                       screen = awful.screen.preferred,
                       placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                       size_hints_honor = false
                     }
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }}

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
------------------------------------------------------------------------------- RULES END

------------------------------------------------------------------------------- SIGNALS
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c) -------------------------------- WHEN CONFIGURING MOUSE BUTTONS, I HAVE TO LOOK AT THIS

    -- Code that shows how to add multiple titlebars.
    -- also shows some stuff about cairo, whici I might look at later
    -- local my_widget = wibox.widget.base.make_widget()
    -- function my_widget:draw(_, cr, width, height)
        -- cr:set_operator(cairo.Operator.SOURCE)
        -- cr:set_source(gears.color.create_linear_pattern{
            -- from = { 0, 0 },
            -- to = { width, 0 },
            -- stops = {
                -- { 0, "#f000" },
                -- { 1, "#0f0f" },
            -- },
        -- })
        -- cr:paint()
    -- end
    -- awful.titlebar(c, { position = "bottom" }):set_widget(my_widget)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function() 
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    local top_titlebar = awful.titlebar(c, {
            size = beautiful.titlebar_height,
            font = beautiful.font,
            bg_normal = beautiful.titlebar_bg_normal,
            bg_urgent = beautiful.titlebar_bg_urgent,
            fg_normal = beautiful.titlebar_fg_normal,
            fg_urgent = beautiful.titlebar_fg_urgent,
        })

    top_titlebar : setup ({
        layout = wibox.layout.fixed.vertical,
        {
            widget = wibox.widget.separator,
            color  = '#ffffff10',
            forced_height = 1,
        },
        {
            widget = wibox.container.margin,
            bottom = 1,
            {
                { -- Left
                    -- awful.titlebar.widget.iconwidget(c),
                    utils.pad_width(14),
                    {
                        font = beautiful.font,
                        widget = awful.titlebar.widget.titlewidget(c),
                    },
                    buttons = buttons,
                    layout  = wibox.layout.fixed.horizontal
                },
                { -- Middle
                    -- { -- Title -- ( I don't like how the title looks on top, so I took it out )
                        -- align  = "center"
                        -- widget = awful.titlebar.widget.titlewidget(c)
                    -- },
                    buttons = buttons,
                    layout  = wibox.layout.flex.horizontal
                },
                { -- Right
                    -- awful.titlebar.widget.floatingbutton (c),
                    -- awful.titlebar.widget.stickybutton   (c),
                    -- awful.titlebar.widget.ontopbutton    (c),
                    {
                        widget = wibox.container.place,
                        {
                            widget = wibox.container.margin,
                            -- margins = 12,
                            top = 13,
                            bottom = 13,
                            left = 6,
                            right = 6,
                            {
                                layout = wibox.layout.fixed.horizontal,
                                awful.titlebar.widget.minimizebutton(c),
                            },
                        },
                    },
                    {
                        widget = wibox.container.place,
                        {
                            widget = wibox.container.margin,
                            -- margins = 12,
                            top = 13,
                            bottom = 13,
                            left = 6,
                            right = 6,
                            {
                                layout = wibox.layout.fixed.horizontal,
                                awful.titlebar.widget.maximizedbutton(c),
                            },
                        },
                    },
                    {
                        widget = wibox.container.place,
                        {
                            widget = wibox.container.margin,
                            -- margins = 12,
                            top = 13,
                            bottom = 13,
                            left = 6,
                            right = 10,
                            {
                                layout = wibox.layout.fixed.horizontal,
                                awful.titlebar.widget.closebutton(c),
                            },
                        },
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                layout = wibox.layout.align.horizontal
            },
        },
    })
end)

-- Rounded corners
if beautiful.border_radius ~= 0 then
    client.connect_signal("manage", function (c, startup)
        if not c.fullscreen then
            c.shape = utils.rrect(beautiful.border_radius)
        end
    end)

    -- Fullscreen clients should not have rounded corners
    client.connect_signal("property::fullscreen", function (c)
        if c.fullscreen then
            c.shape = utils.rect()
        else
            c.shape = utils.rrect(beautiful.border_radius)
        end
    end)
end

-- If the layout is not floating, every floating client that appears is centered
-- If the layout is floating, and there is no other client visible, center it
client.connect_signal("manage", function (c)
    if not awesome.startup then
        if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating then
            awful.placement.centered(c,{honor_workarea=true})
        else if #mouse.screen.clients == 1 then
                awful.placement.centered(c,{honor_workarea=true})
            end
        end
    end
end)

-- Hide titlebars if required by the theme
client.connect_signal("manage", function (c)
    if not beautiful.titlebars_enabled then
        awful.titlebar.hide(c)
    end
end)

------------------- Sloppy focus
-- Enable sloppy focus, so that focus follows mouse.
--client.connect_signal("mouse::enter", function(c)
--    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--        and awful.client.focus.filter(c) then
--        client.focus = c
--    end
--end)
------------------- Sloppy focus end



-- naughty.notify({ title = "hey now",
                 -- text = tostring('ok this is epic'),
                 -- timeout = 10,
                 -- height = 140,
                 -- width = 160,
                 -- font = 'sans 14' })

------------------- this has to do with coloring the borders of windows when focused
-- these color client borders when focusing and unfocusing
-- client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)    
-- client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
------------------------------------------------------------------------------- SIGNALS END

-- 
-- local keygrabber = awful.keygrabber
-- local panel = wibox({
    -- x = 80,
    -- y = 80,
    -- color = '#20102088',
    -- width = 200,
    -- height = 200,
    -- visible = true,
-- })
-- 
-- panel:setup({
    -- widget = wibox.container.background,
    -- bg = '#83830033',
    -- {
        -- id = 'vi_textbox',
        -- layout = wibox.layout.fixed.horizontal,
        -- wibox = wibox.widget.textbox,
        -- font = "TTCommons 18",
        -- text = ' ok then ',
    -- },
-- })
-- 
-- local tbox = wibox.widget.textbox("hey there")
-- 
-- local vi_textbox = panel:get_children_by_id("vi_textbox")[1]
-- naughty.notify({text = tostring(tbox.set_font)})
-- local grab = keygrabber.run(
-- function(modifiers, key, event)
    -- naughty.notify({text = tostring('hmm')})
    -- if key == "q" or key == "Escape" then
        -- keygrabber.stop(grab)
        -- panel.visible = false
        -- fake_bar.visible = false

    -- elseif key == "l" then
        -- select_button( "+1" )

    -- elseif key == "h" then
        -- select_button( "-1" )

    -- elseif key == "Return" then
        -- press_button()

    -- elseif key == ":" then
        -- awful.prompt:run ({
            -- -- font = "TTCommons Medium 14",
            -- textbox = vi_textbox,
            -- exe_callback = function( command )
                -- naughty.notify({text = tostring(command)})
            -- end
        -- })
    -- end
-- end)
