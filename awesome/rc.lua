
-- Directory where themes are located
local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/"

-- Themes
local theme_collection = {
    "NebulaBlaze"
}

-- thanks for the idea, empress ;;;)
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
local titlebars = require("titlebars")

-- kill the previously running 'subscribed' scripts
-- otherwise they'll accumulate across awesome-wm restarts
local pactl_cleanup = [[bash -c "ps aux | grep '[0-9] pactl subscribe' | awk '{ print $2 }' | xargs kill"]]
awful.spawn(pactl_cleanup)

local mpc_cleanup = [[bash -c "ps aux | grep '[0-9] mpc idleloop player' | awk '{ print $2 }' | xargs kill"]]
awful.spawn(mpc_cleanup)

local piglets = require("piglets")

-- Key bindings
local keys = require("keys")
-- Keys
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

-- utility functions
local utils = require("utils") -- TODO: this name is garbage. 
-- there's a bunch of stuff in there that can be split into modules.

-------------------
-- Error handling
-------------------
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

-- autostart programs
for _, v in pairs(startup_programs) do
    awful.spawn.once(v)
end

screen.connect_signal('refresh', function(c) return c end)
-------------------
-- RULES
-------------------
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
        properties = { 
            -- border_color = "#161a13",
            border_width = 1,
            border_color = '#1a1820',
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
    { -- Add titlebars to normal clients and dialogs
        rule_any = { 
            type = { "normal", "dialog" } 
        }, 
        properties = { titlebars_enabled = true }
    },
    { -- Floating clients.
        rule_any = {
            instance = {
              "DTA",  -- Firefox addon DownThemAll.
              "copyq",  -- Includes session name in class.
            },
            class = {
                -- "Arandr",
                "Lxappearance",
                "Nm-connection-editor",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Wpa_gui",
                "pinentry",
                "veromix",
                "xtightvncviewer",
                "fst" -- (floating st)
            },
            name = {
              "Event Tester",  -- xev.
            },
            role = {
              "AlarmWindow",  -- Thunderbird's calendar.
              "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            },
        }, 
        properties = { floating = true, ontop = false }
    },
    { 
        rule_any = {
            type = { "dialog" },
            class = {
                "Steam",
                "discord",
            },
            role = {
                "GtkFileChooserDialog",
            }
        }, 
        properties = {},
        callback = function(c)
            awful.placement.centered(c, {honor_workarea = true})
        end,
    },
    {
        rule_any = {
            class = {
                "Nautilus",
                "Thunar",
            },
        },
        except_any = {
            type = { "dialog" } 
        },
        properties = { 
            floating = true, 
            width = awful.screen.focused().geometry.width * 0.4,
            height = awful.screen.focused().geometry.height * 0.7,
        }
    },
    {
        rule_any = {
            class = {
                "feh",
                "Sxiv",
            },
        },
        properties = {
            floating = true,
            -- width = awful.screen.focused().geometry.width * 0.7,
            -- height = awful.screen.focused().geometry.height * 0.7,
        },
        callback = function(c)
            awful.placement.centered(c, { honor_workarea = true })
        end,
    },
    { -- Set Firefox to always map on the tag named "2" on screen 1.
        rule = { class = "Firefox" },
        properties = { 
            -- screen = 1, 
            tag = "6" 
        } 
    },
}

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)

    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            -- `client`: part of the global scope
            client.focus = c
            awful.mouse.client.move(c)
            c:raise()
            utils.check_double_tap( function()
                c.maximized = not c.maximized
            end)
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

    top_titlebar:setup(
        titlebars.normal_tbar({
            client = c,
            buttons = buttons,
        }) 
    )
end)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup 
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
    end
end)

-- Rounded corners
if beautiful.border_radius ~= 0 then
    client.connect_signal("manage", function (c, startup)
        if not c.fullscreen then
            c.shape = utils.rrect(beautiful.border_radius)
        end
    end)
    -- Fullscreen clients should not have rounded corners
    local function no_rounded_corners(c)
        if c.fullscreen or c.maximized then
            c.shape = utils.rect()
        else
            c.shape = utils.rrect(beautiful.border_radius)
        end
    end
    client.connect_signal("property::fullscreen", no_rounded_corners)
    client.connect_signal("property::maximized", no_rounded_corners)
end

-- If the layout is not floating, every floating client that appears is centered
-- If the layout is floating, and there is no other client visible, center it
client.connect_signal("manage", function (c)
    if not awesome.startup then
        if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating then
            awful.placement.centered(c,{honor_workarea=true})
        elseif #mouse.screen.clients == 1 then
            awful.placement.centered(c,{honor_workarea=true})
        end
    end
end)

-- Hide titlebars if required by the theme
client.connect_signal("manage", function (c)
    if not beautiful.titlebars_enabled then
        awful.titlebar.hide(c)
    end
end)

local timebox = wibox({
    x = awful.screen.focused().geometry.width / 2 + 80,
    y = awful.screen.focused().geometry.height / 2 - 300,
    width = 360,
    height = 240,
    bg = "#00000000",
    visible = true,
    ontop = false,
    type = "dock",
})

timebox:setup({
    widget = wibox.container.background,
    shape = utils.rrect(10),
    bg = "#14101a",
    fg = "#e8e0ed",
    -- shape_border_width = 40,
    -- shape_border_color = "#201e2f",
    {
        widget = wibox.container.margin,
        margins = 20,
        {
            widget = wibox.container.place,
            {
                widget = wibox.widget.textclock,
                font = "TTCommons Bold 78",
                format = "%H:%M",
            },
        }
    }
})
-- the new keygrabber api is a bit weird, so I'll keep this here
-- as an example use case

-- local shapem = wibox({
--     x = 20,
--     y = 40,
--     width = 300,
--     height = 400,
--     visible = true,
--     bg = "#88ffdd",
-- })

-- local grab = awful.keygrabber({
--     keybindings = {
--         {{"Mod1"}, "F11", function() end}
--     },
--     stop_key = {{"Mod1"}, "F12"},
--     stop_event = "release",
--     keypressed_callback = function(_, modifiers, key)
--         if key == "k" then
--             shapem.visible = not shapem.visible
--         end
--     end,
--     export_keybindings = true,
-- })
