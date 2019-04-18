
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local menubar = require("menubar")
local capi = { screen = screen }
local utils = require("utils")

-- Terminal and editor
-- This is used later as the default terminal and editor to run.
local terminal = "st"
local editor = "vim"
local editor_cmd = terminal .. ' -e ' .. editor

-- local font = 'Roboto Bold 14'
local font = 'TTCommons DemiBold 16'

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

-- helper functions (even though it's just one for now)
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

-- Menu (The right-click one)
-- Create a launcher widget and a main menu
local myawesomemenu = {
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

-- local mymainmenu = awful.menu({
    -- items = {
              -- menu_awesome,
              -- menu_terminal,
            -- }
-- })

------------------- Launcher
-- NOTE AF: IDK WHY THIS IS CALLED A LAUNCHER, WHEN IT'S ACTUALLY THE IMAGE
-- THAT YOU CAN CLICK ON THAT SHOWS YOU THE MENU (THE ONE THAT SHOWS WHEN YOU RIGHT CLICK)
-- `AWFUL.WIDGET.PROMPT` IS ACTUALLY THE LAUNCHER (SIMILAR TO DMENU)
-- local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     -- menu = mymainmenu })

------------------- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
------------------------------------------------------------------------------- END MENU

------------------- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

------------------------------------------------------------------------------- WIBAR
------------------- Create a textclock widget
local mytextclock = wibox.widget.textclock( "%H:%M" )
mytextclock.font = font

-- local mymenu = radical.context({ })
-- mymenu:add_item ({text = "ses1", button1 = function(_menu,item,mods) print("Hello world") end})
-- mymenu:add_item ({text = "saes8", icon = '/home/ciugamenn/search.svg', bg = '#ffffff', fg='#000000'})
-- mymenu:add_item ({text = "Submenu", sub_menu = function()
    -- local smenu = radical.context({})
    -- smenu:add_item({text = "submenu string1"})
    -- smenu:add_item({text = "not submenu haha"})
    -- return smenu
-- end})

-- mytextclock:set_menu(mymenu, "button::pressed", 3)

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
    local wibar_height = 40
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

    -- Create a taglist widget
    local taglist = awful.widget.taglist({
        screen = s, 
        filter = awful.widget.taglist.filter.all, 
        buttons = taglist_buttons,
        layout = wibox.layout.fixed.horizontal,
        widget_template = {
            {
                {
                    id = 'index_role',
                    widget = wibox.widget.textbox,
                },
                margins = 3,
                widget = wibox.container.margin,
            },
            widget = wibox.container.background,
            bg = '#201e2a',
            shape = gears.shape.circle,
            -- why tf is this in the background widget's properties???
            create_callback = function(self, c3, index, objects)
                self:get_children_by_id('index_role')[1].markup = '<b> ' .. index .. ' </b>'
                self:connect_signal('mouse::enter', function()
                    self.bg = '#aa0000'
                end)
                self:connect_signal('mouse::leave', function()
                    self.bg = '#201e2a'
                end)
                
            end,
        }
    })

    -- lord forgive me, this is a nasty hack to put the clock right in the middle,
    -- it's probably going to bite me in the ass later, but for now it just works 8)
    local fake_bar = wibox({
        x = 0,
        y = 0,
        width = screen_width,
        height = wibar_height,
        bg = '#00000000',
        fg = beautiful.fg,
        type = 'dock',
        visible = true,
        -- ontop = true,
        input_passthrough = true,
    })

    local middle_clock = fake_bar:setup({
        widget = wibox.container.place,
        {
            widget = mytextclock,
        },
    })

    --------------- Create the wibox
    s.mywibox = awful.wibar({ 
        position = "top", 
        screen = s, 
        width = screen_width,
        height = wibar_height,
        type = 'dock',
        bg = '#00000000',
        fg = beautiful.fg,
        -- ontop = true,
    })

    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    local layoutbox = wibox.widget({
        widget = wibox.container.margin,
        margins = 4,
        {
            s.mylayoutbox,
            layout = wibox.layout.fixed.horizontal,
        },
        
    })

    -- Tasklist
    tasklist = awful.widget.tasklist ({
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
        style    = {
            shape = gears.shape.circle,
            bg_normal = '#00000000',
            bg_focus = '#00000000',
        },
        layout   = {
            layout  = wibox.layout.fixed.horizontal,
        },
        widget_template = {
            {
                {
                    {
                        {
                            widget = awful.widget.clienticon,
                            id = 'clienticon',
                        },
                        margins = 6,
                        widget  = wibox.container.margin,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                -- left  = 10,
                -- right = 10,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            bg = '#00000000',
            widget = wibox.container.background,
            create_callback = function(self, c, index, objects)
                self:get_children_by_id('clienticon')[1].client = c
            end,
        },
    })

    --------------- Add widgets to the wibox
    s.mywibox:setup ({
        {
            taglist,
            tasklist,
            layout = wibox.layout.fixed.horizontal,
        },
        utils.pad_width(1),

        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            layoutbox,
        },
        layout = wibox.layout.align.horizontal,
    })
        
end)
