
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local menubar = require("menubar")
local capi = { screen = screen }
local utils = require("utils")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi

-- Widgets and applets used in the hogbar
local show_porkerpanel = require("piglets.porkerpanel.porkerpanel")
local make_right_widget = require("piglets.hogbar.right_widget")
local make_left_widget = require("piglets.hogbar.left_widget")
-- Terminal and editor
-- This is used later as the default terminal and editor to run.
local home = os.getenv("HOME")
local terminal = "st"
local editor = "vim"
local editor_cmd = terminal .. ' -e ' .. editor

-- local font = 'Roboto Bold 14'
local font = "TTCommons DemiBold 18"

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

------------------- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
------------------------------------------------------------------------------- END MENU

------------------- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

------------------------------------------------------------------------------- WIBAR
------------------- Create a textclock widget
local mytextclock = wibox.widget.textclock( "%H:%M" )
mytextclock.font = font

local function make_hogbar( args )

    -- the screen
    local s = args.screen
    local hogbar_height = args.height
    local left_widget = args.left_widget or nil
    local middle_widget = args.middle_widget or nil
    local right_widget = args.right_widget or nil
    
    --------------- Create the wibox
    local hogbar = awful.wibar({ 
        position = "top", 
        screen = args.s, 
        -- width = s.width
        height = hogbar_height,
        type = 'dock',
        bg = '#00000000',
        fg = beautiful.fg,
    })

    -- TODO: get the natural width of the middle widget and scale according to that.
    --------------- Add widgets to the wibox
    hogbar:setup ({ 
        -- widget = wibox.container.margin,
        -- top = dpi(13),
        -- bottom = (13),
        -- left = dpi(20),
        -- right = dpi(20),
        layout = wibox.layout.manual,
        -- widget = wibox.container.background,
        -- {
            { -- Left widget space setup
                point = { x = 0, y = 0 },
                forced_width = awful.screen.focused().geometry.width/2 - 60,
                forced_height = hogbar_height,
                widget = wibox.container.background,
                bg = "#33ff8800",
                {
                    layout = wibox.layout.fixed.horizontal,
                    left_widget,
                    -- widget = wibox.widget.textbox,
                    -- text = "",
                },
            },
            { -- Middle widget space setup
                point = { x = awful.screen.focused().geometry.width/2 - 60, y = 0 },
                forced_width = 120,
                forced_height = hogbar_height,
                widget = wibox.container.background,
                bg = "#ff008800",
                {
                    top = 10,
                    widget = wibox.container.margin,
                    {
                        widget = wibox.container.place,
                        {
                            layout = wibox.layout.fixed.horizontal,
                            middle_widget,
                        },
                    },
                },
            },
            { -- Right widget space setup
                point = { x = awful.screen.focused().geometry.width/2 + 60, y = 0 },
                forced_width = awful.screen.focused().geometry.width/2 - 60,
                forced_height = hogbar_height,
                widget = wibox.container.background,
                bg = "#00880000",
                {
                    widget = wibox.container.margin,
                    right = 10,
                    {
                        widget = wibox.container.place,
                        halign = "right",
                        {
                            layout = wibox.layout.fixed.horizontal,
                            right_widget,
                        }
                    },
                },
            },
    })

    return hogbar

end

-- Wallpaper
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, false)
    end
end

------------------- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

    local screen_width = awful.screen.focused().geometry.width
    -- local timebox_width = 3 -- ???? If only you could get its natural width
    local wibar_height = 42
    local font_height = beautiful.get_font_height(beautiful.font)

------------------- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Taglist

    -- Each screen has its own tag table.
    local names = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
    local l = awful.layout.suit  -- Just to save some typing: use an alias.
    local layouts = { l.floating, l.floating, l.floating, l.floating, 
                      l.floating, l.floating, l.tile, l.tile, l.tile,}

    awful.tag(names, s, layouts)

    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    local layoutbox = wibox.widget({
        s.mylayoutbox,
        layout = wibox.layout.fixed.horizontal,
        
    })

    make_hogbar({
        screen = s, 
        height = 43, 
        left_widget = make_left_widget(s),
        middle_widget = mytextclock,
        right_widget = make_right_widget(s),
    })
        
end)


-- CODE TO REVIEW LATER
-- local tasklist_buttons = gears.table.join(
                     -- awful.button({ }, 1, function (c)
                                              -- if c == client.focus then
                                                  -- c.minimized = true
                                              -- else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  -- c.minimized = false
                                                  -- if not c:isvisible() and c.first_tag then
                                                      -- c.first_tag:view_only()
                                                  -- end
                                                  -- -- This will also un-minimize
                                                  -- -- the client, if needed
                                                  -- client.focus = c
                                                  -- c:raise()
                                              -- end
                                          -- end),
                     -- awful.button({ }, 3, client_menu_toggle_fn()),
                     -- awful.button({ }, 4, function ()
                                              -- awful.client.focus.byidx(1)
                                          -- end),
                     -- awful.button({ }, 5, function ()
                                              -- awful.client.focus.byidx(-1)
                                          -- end))

    -- Create a taglist widget
    -- local taglist = awful.widget.taglist({
        -- screen = s, 
        -- filter = awful.widget.taglist.filter.all, 
        -- buttons = taglist_buttons,
        -- layout = wibox.layout.fixed.horizontal,
        -- widget_template = {
            -- {
                -- {
                    -- id = 'index_role',
                    -- widget = wibox.widget.textbox,
                -- },
                -- margins = 3,
                -- widget = wibox.container.margin,
            -- },
            -- widget = wibox.container.background,
            -- bg = '#201e2a',
            -- shape = gears.shape.circle,
            -- create_callback = function(self, c3, index, objects)
                -- self:get_children_by_id('index_role')[1].markup = '<b> ' .. index .. ' </b>'
                -- self:connect_signal('mouse::enter', function()
                    -- self.bg = '#aa0000'
                -- end)
                -- self:connect_signal('mouse::leave', function()
                    -- self.bg = '#201e2a'
                -- end)
                -- 
            -- end,
        -- }
    -- })

-- helper functions (even though it's just one for now)
-- local function client_menu_toggle_fn()
    -- local instance = nil
-- 
    -- return function ()
        -- if instance and instance.wibox.visible then
            -- instance:hide()
            -- instance = nil
        -- else
            -- instance = awful.menu.clients({ theme = { width = 250 } })
        -- end
    -- end
-- end

-- Menu (The right-click one)
-- Create a launcher widget and a main menu
-- local myawesomemenu = {
   -- { "hotkeys", function() return false, hotkeys_popup.show_help end},
   -- { "manual", terminal .. " -e man awesome" },
   -- { "edit config", editor_cmd .. " " .. awesome.conffile },
   -- { "restart", awesome.restart },
   -- { "quit", function() awesome.quit() end}
-- }
-- 
-- local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
-- local menu_terminal = { "open terminal", terminal }

-- if has_fdo then
    -- mymainmenu = freedesktop.menu.build({
        -- before = { menu_awesome },
        -- after =  { menu_terminal }
    -- })

-- local mymainmenu = awful.menu({
    -- items = {
              -- menu_awesome,
              -- menu_terminal,
            -- }
-- })

-- Menu (The right-click one)
-- Create a launcher widget and a main menu
-- local myawesomemenu = {
   -- { "hotkeys", function() return false, hotkeys_popup.show_help end},
   -- { "manual", terminal .. " -e man awesome" },
   -- { "edit config", editor_cmd .. " " .. awesome.conffile },
   -- { "restart", awesome.restart },
   -- { "quit", function() awesome.quit() end}
-- }
-- 
-- local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
-- local menu_terminal = { "open terminal", terminal }

-- if has_fdo then
    -- mymainmenu = freedesktop.menu.build({
        -- before = { menu_awesome },
        -- after =  { menu_terminal }
    -- })

-- local mymainmenu = awful.menu({
    -- items = {
              -- menu_awesome,
              -- menu_terminal,
            -- }
-- })

-- Menu (The right-click one)
-- Create a launcher widget and a main menu
-- local myawesomemenu = {
   -- { "hotkeys", function() return false, hotkeys_popup.show_help end},
   -- { "manual", terminal .. " -e man awesome" },
   -- { "edit config", editor_cmd .. " " .. awesome.conffile },
   -- { "restart", awesome.restart },
   -- { "quit", function() awesome.quit() end}
-- }
-- 
-- local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
-- local menu_terminal = { "open terminal", terminal }

-- if has_fdo then
    -- mymainmenu = freedesktop.menu.build({
        -- before = { menu_awesome },
        -- after =  { menu_terminal }
    -- })

-- local mymainmenu = awful.menu({
    -- items = {
              -- menu_awesome,
              -- menu_terminal,
            -- }
-- })

-- local mymenu = radical.context({ })
-- mymenu:add_item ({text = "ses1", button1 = function(_menu,item,mods) print("Hello world") end})
-- mymenu:add_item ({text = "Submenu", sub_menu = function()
    -- local smenu = radical.context({})
    -- smenu:add_item({text = "submenu string1"})
    -- smenu:add_item({text = "not submenu haha"})
    -- return smenu
-- end})
-- mytextclock:set_menu(mymenu, "button::pressed", 3)

------------------- Launcher
-- NOTE AF: IDK WHY THIS IS CALLED A LAUNCHER, WHEN IT'S ACTUALLY THE IMAGE
-- THAT YOU CAN CLICK ON THAT SHOWS YOU THE MENU (THE ONE THAT SHOWS WHEN YOU RIGHT CLICK)
-- `AWFUL.WIDGET.PROMPT` IS ACTUALLY THE LAUNCHER (SIMILAR TO DMENU)
-- local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     -- menu = mymainmenu })
