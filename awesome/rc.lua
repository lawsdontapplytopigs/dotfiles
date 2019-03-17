
-- Estetickks related
-------------------------------------------------------------------------------


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
-- Math functions
local gears = require("gears")
-- Everything to do with controlling awesome
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

cleanup = [[bash -c "ps aux | egrep '[0-9] pactl subscribe' | awk '{ print $2 }' | xargs kill"]]

awful.spawn(cleanup)

-- Load Debian menu entries -- might have to take this out, not on debian anymore
-- local click_menu = require("freedesktop").menu

-- local desktop = require("piglets").desktop
local piglets = require("piglets")

-- for k, v in pairs(desktop) do
    -- naughty.notify({text = tostring(k)})
-- end

-- Key bindings
local keys = require("keys")

-- utility functions
local utils = require("utils")

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

-- VARIABLE DEFINITIONS
------------------------------------------------------------------------------- 

------------------- TERMINAL AND EDITOR
-- This is used later as the default terminal and editor to run.
terminal = "st"
editor = "vim"
editor_cmd = terminal .. " -e " .. editor




-- autostart programs
for _, v in pairs(startup_programs) do
    awful.spawn.once(v)
end



-- desktop.add_icons()



-- Themes define colours, icons, font and wallpapers.

screen.connect_signal('refresh', function(c) return c end)

naughty.notify({ title = 'number of screens',
                 text = tostring(screen:count()),
                 timeout = 12 })




------------------- WINDOW MANAGER LAYOUT TYPE
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    -- awful.layout.suit.max,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
------------------------------------------------------------------------------- END VARIABLE DEFINITIONS



------------------------------------------------------------------------------- HELPER FUNCTIONS
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
------------------------------------------------------------------------------- END HELPER FUNCTIONS




------------------------------------------------------------------------------- MENU
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

-- if has_fdo then
    -- mymainmenu = freedesktop.menu.build({
        -- before = { menu_awesome },
        -- after =  { menu_terminal }
    -- })
mymainmenu = awful.menu({
    items = {
              menu_awesome,
              menu_terminal,
            }
})

------------------- Widgets
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

------------------- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
------------------------------------------------------------------------------- END MENU

------------------- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

------------------------------------------------------------------------------- WIBAR
------------------- Create a textclock widget
mytextclock = wibox.widget.textclock()

------------------- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

---------------------- Wallpaper
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, false)
        -- awful.spawn.with_shell('/home/ciugamenn/.fegbg')
    end
end

------------------- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    local names = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
    local l = awful.layout.suit  -- Just to save some typing: use an alias.
    local layouts = { l.floating, l.floating, l.floating, l.floating, 
                      l.floating, l.floating, l.tile, l.tile, l.tile,}

    awful.tag(names, s, layouts)


    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    --------------- Create a taglist widget
    -- s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    --------------- Create a tasklist widget
    -- s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)
    -- s.taglist = piglets.bubbles.taglist
    -- for k, v in pairs(piglets.bubbles.taglist) do
        -- naughty.notify({text = tostring(k)})
    -- end

    --------------- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    --------------- Add widgets to the wibox
    s.mywibox:setup {
        { -- Left widgets
            mylauncher,
            s.mypromptbox,
            layout = wibox.layout.fixed.horizontal,
        },
        utils.pad_width(1), -- Middle widget -- Just leave it blank
        
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
        layout = wibox.layout.align.horizontal,
    }
end)
------------------------------------------------------------------------------- WIBAR END


------------------------------------------------------------------------------- RULES
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
        properties = { border_width = beautiful.border_width,
                       border_color = beautiful.border_normal,
                       focus = awful.client.focus.filter,
                       raise = true,
                       keys = keys.globalkeys,
                       buttons = keys.clientkeys,
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
            awful.titlebar.widget.minimizebutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton(c),
            utils.pad_width(3),
            layout = wibox.layout.fixed.horizontal,
        },
        layout = wibox.layout.align.horizontal
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






naughty.notify({ title = "hey now",
                 text = tostring('ok this is epic'),
                 timeout = 10,
                 height = 140,
                 width = 160,
                 font = 'sans 14' })

------------------- this has to do with coloring the borders of windows when focused
-- these color client borders when focusing and unfocusing
-- client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)    
-- client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
------------------------------------------------------------------------------- SIGNALS END
