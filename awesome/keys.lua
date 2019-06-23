local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local utils = require("utils")
local piglets = require("piglets")
local audio_widget_module = require("piglets.audio")
local porkerpanel = require("piglets.porkerpanel")
local trufflequest = require("piglets.trufflequest.trufflequest")
local dpi = require("beautiful.xresources").apply_dpi

local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")                          ---------------- might take this out. have to see if it does anything

local keys = {}

local shift = "Shift"
local control = "Control"
local superkey = "Mod4"
local alt = "Mod1"

local floating_terminal = "st -c fst"

-- for k, v in pairs(piglets.custom_prompt) do
    -- naughty.notify({text = tostring(k)})
-- end

-- put global variables in a file
-- for k, _ in pairs(_G) do
    -- file = io.open(os.getenv("HOME").."/awesome_globals.txt", "a")
    -- file:write(tostring(k)..'\n')
    -- file:close()
-- end

keys.globalkeys = gears.table.join(

    ---------------
    -- Screens
    ---------------
    -- focus the prev screen
    awful.key({ superkey }, "e", function () awful.screen.focus_relative(-1) end,
              { description = "focus the previous screen", group = "screen"}),

    -- focus the next screen
    awful.key({ superkey }, "r", function () awful.screen.focus_relative( 1) end,
              { description = "focus the next screen", group = "screen"})
)

keys.globalkeys = gears.table.join( keys.globalkeys,

    ---------------
    -- Tags
    ---------------
    -- view previous tag
    awful.key({ superkey }, "q", awful.tag.viewprev,
            {description = "view previous", group = "tag"}),

    -- view next tag
    awful.key({ superkey }, "w",  awful.tag.viewnext,
              {description = "view next", group = "tag"})
)

keys.globalkeys = gears.table.join( keys.globalkeys,
    ---------------
    -- Program-related
    ---------------
    
    -- restart awesomeWM
    -- PRO TIP: 'Shift_L' doesn't work ;)
    awful.key({ superkey, shift }, "t", awesome.restart,
              { description = "reload awesome", group = "awesome"}),

    -- quit awesome
    awful.key({ superkey, shift }, "Escape", awesome.quit,
              { description = "quit awesome", group = "awesome"}),

    -- show main menu
    -- awful.key({ superkey }, "c", function () mymainmenu:show() end, -- this keybind is used to center clients
    --           { description = "show main menu", group = "awesome"}),

    -- alt + 'grave' to start a FLOATING terminal
    awful.key({ alt }, "grave", function () awful.spawn("st -c fst") end,
              { description = "open a floating terminal", group = "awesome"}),

    -- superkey + 'grave' to start a terminal
    awful.key({ superkey }, "grave", function () awful.spawn('st') end,
              { description = "open a terminal", group = "awesome"}),


    --awful.key({ superkey, shift }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
    --          {description = "increase the number of master clients", group = "layout"}),

    --awful.key({ superkey, shift }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
    --          {description = "decrease the number of master clients", group = "layout"}),

    awful.key({ superkey, control }, "h",
        function () awful.tag.incncol( 1, nil, false ) end,
        {
            description = "increase the number of columns", 
            group = "layout"
        }
    ),

    awful.key({ superkey, control }, "l",
        function () awful.tag.incncol(-1, nil, true) end,
        {
            description = "decrease the number of columns", 
            group = "layout"
        }
    ),

    awful.key({ alt }, "r", piglets.piggyprompt.launch,
        { description = "Run programs", group = "awesome"})

    -- superkey + r
    -- program-running prompt
    -- awful.key({ alt }, "r",
        -- function () 
            -- awful.screen.focused().mypromptbox:run() 
            -- piglets.sidebar.sidebar.promptbox:run()
            -- for k, v in pairs(piglets.sidebar.sidebar:get_children_by_id("launcher")[1]) do
                -- naughty.notify({text = tostring(k)})
            -- end
            -- piglets.sidebar.sidebar:get_children_by_id("launcher")[1]:run()
            -- if not piglets.sidebar.sidebar.visible then
                -- piglets.sidebar.sidebar.visible = true
                -- piglets.sidebar.sidebar.ontop = true
            -- end
            -- piglets.sidebar.promptbox:run()
        -- end,
    -- {description = "run prompt", group = "awesome"}),

    -- superkey + x
    -- run-lua-code prompt
    -- awful.key({ alt }, "l",
    --     function ()
    --         awful.prompt.run {
    --             prompt       = "Run Lua code: ",
    --             textbox      = awful.screen.focused().mypromptbox.widget,
    --             exe_callback = awful.util.eval,
    --             history_path = awful.util.get_cache_dir() .. "/history_eval"
    --         }
    --     end,
    --     {description = "lua execute prompt", group = "awesome"})

    -- Menubar
    -- this is broken currently (30, march, 2019)
    -- awful.key({ superkey }, "x", 
        -- function() 
            -- menubar.show() 
            -- naughty.notify({text = tostring(capi.selection())})
        -- end,
    -- {description = "show the clipboard contents", group = "awesome"}),
)

---------------
-- Clients
---------------
keys.globalkeys = gears.table.join( keys.globalkeys,
    ------ TABBING THROUGH CLIENTS 
    awful.key({ superkey, shift }, "q",
        function() 
            awful.client.focus.byidx(1)
        end,
        { description = "focus next client", group = "client"}),
    awful.key({ superkey, shift }, "w",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous client", group = "client"}),
    awful.key({ superkey }, "Tab",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next client", group = "client"}),
    awful.key({ superkey, shift }, "Tab",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous client", group = "client"})
)

-- Swapping/moving clients with arrow keys
keys.globalkeys = gears.table.join( keys.globalkeys,
    -- swap with client above
    awful.key({ superkey, shift }, "Up",
        function () 
            local c = client.focus
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating then
                c:relative_move(0, dpi(-30), 0, 0)
            else
                awful.client.swap.bydirection("up")
            end
        end,
        { description = "swap with the client above", group = "client"}),
    -- swap with client on the right
    awful.key({ superkey, shift }, 'Right',
        function ()
            local c = client.focus
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating then
                c:relative_move(dpi(30), 0, 0, 0)
            else
                awful.client.swap.bydirection("right")
            end
        end,
        { description = "swap with the client on the right", group = "client"}),
    -- swap places with the client below
    awful.key({ superkey, shift }, "Down",
        function () 
            local c = client.focus
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating then
                c:relative_move(0, dpi(30), 0, 0)
            else
                awful.client.swap.bydirection("down")
            end
        end,
        { description = "swap with the client below", group = "client"}),
    -- swap with the client on the left
    awful.key({ superkey, shift }, "Left",
        function ()
            local c = client.focus
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating then
                c:relative_move(dpi(-30), 0, 0, 0)
            else
                awful.client.swap.bydirection("left")
            end
        end,
        { description = "swap with the client on the left", group = "client" })
)

-- Focusing clients with arrow keys
keys.globalkeys = gears.table.join( keys.globalkeys,
    -- focus client by direction: up
    awful.key({ superkey }, "Up",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus up", group = "client"}),
    -- focus client by direction: right
    awful.key({ superkey }, "Right",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus right", group = "client"}),
    -- focus client by direction: down
    awful.key({ superkey }, "Down",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus down", group = "client" }),
    -- focus client by direction: left
    awful.key({ superkey }, "Left",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus left", group = "client"})
)

-- resizing clients with arrow keys
keys.globalkeys = gears.table.join(keys.globalkeys,
    awful.key({ superkey, control }, "Up", 
        function ()
            local c = client.focus
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating == true then
                c:relative_move( 0, 0, 0, dpi(-30) )
            else
                awful.client.incwfact(0.05, c)
            end
        end),
    awful.key({ superkey, control }, "Right",
        function () 
            local c = client.focus
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating == true then
                c:relative_move( 0, 0, dpi(30), 0 )
            else
                awful.client.incwfact(0.05, c)
            end
        end),
    awful.key({ superkey, control }, "Down", 
        function ()
            local c = client.focus
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating == true then
                c:relative_move(  0,  0,  0, dpi(30) )
            else
                awful.client.incwfact(-0.05, c)
            end
        end),
    awful.key({ superkey, control }, "Left",
        function ()
            local c = client.focus
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating == true then
                c:relative_move( 0, 0, dpi(-30), 0 )
            else
                awful.client.incwfact(-0.05, c)
            end
        end)
)

------ Swapping/moving between clients with superkey + [yuio]
keys.globalkeys = gears.table.join( keys.globalkeys,
    -- swap with client above
    awful.key({ superkey }, "i",
        function () 
            local c = client.focus
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating then
                c:relative_move(0, dpi(-30), 0, 0)
            else
                awful.client.swap.bydirection("up")
            end
        end,
        { description = "swap with the client above", group = "client"}),
    -- swap with client on the right
    awful.key({ superkey }, 'o',
        function ()
            local c = client.focus
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating then
                c:relative_move(dpi(30), 0, 0, 0)
            else
                awful.client.swap.bydirection("right")
            end
        end,
        { description = "swap with the client on the right", group = "client"}),
    -- swap places with the client below
    awful.key({ superkey }, "u",
        function () 
            local c = client.focus
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating then
                c:relative_move(0, dpi(30), 0, 0)
            else
                awful.client.swap.bydirection("down")
            end
        end,
        { description = "swap with the client below", group = "client"}),
    -- swap with the client on the left
    awful.key({ superkey }, "y",
        function ()
            local c = client.focus
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating then
                c:relative_move(dpi(-30), 0, 0, 0)
            else
                awful.client.swap.bydirection("left")
            end
        end,
        { description = "swap with the client on the left", group = "client" })
)

-- focus clients with vim keys
keys.globalkeys = gears.table.join( keys.globalkeys,
    -- focus client by direction: up
    awful.key({ superkey }, "k",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus up", group = "client"}),
    -- focus client by direction: right
    awful.key({ superkey }, "l",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus right", group = "client"}),
    -- focus client by direction: down
    awful.key({ superkey }, "j",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus down", group = "client" }),
    -- focus client by direction: left
    awful.key({ superkey }, "h",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus left", group = "client"})
)

------ resizing clients with superkey + [n.]keys
keys.globalkeys = gears.table.join( keys.globalkeys,

    awful.key({ superkey }, "comma", 
        function ()
            local c = client.focus
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating == true then
                c:relative_move( 0, 0, 0, dpi(-30) )
            else
                awful.client.incwfact(-0.05, c)
            end
        end),
    awful.key({ superkey }, "period",
        function () 
            local c = client.focus
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating == true then
                c:relative_move( 0, 0, dpi(30), 0 )
            else
                awful.client.incwfact(0.05, c)
            end
        end),
    awful.key({ superkey }, "m", 
        function ()
            local c = client.focus
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating == true then
                c:relative_move(  0,  0,  0, dpi(30) )
            else
                awful.client.incwfact(0.05, c)
            end
        end),

    -- superkey + n to decrease window width
    awful.key({ superkey }, "n",
        function ()
            local c = client.focus
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            if current_layout == "floating" or c.floating == true then
                c:relative_move( 0, 0, dpi(-30), 0 )
            else
                awful.client.incwfact(0.05, c)
            end
        end)
)


-- Switching through layouts
keys.globalkeys = gears.table.join( keys.globalkeys,
    ------ super + shift + [er] to browse back and forth through layouts for clients
    awful.key({ superkey, shift }, "e", function () awful.layout.inc(-1) end,
              { description = "select previous", group = "client"}),

    -- superkey + shift + r select next layout for clients
    awful.key({ superkey, shift }, "r", function () awful.layout.inc(1) end,
              { description = "select next", group = "client"})
)

keys.globalkeys = gears.table.join( keys.globalkeys,
    -- Center client
    awful.key({ superkey }, "c",  function ()
        local c = client.focus
        awful.placement.centered(c,{honor_workarea=true})
    end),

    -- Toggle titlebar (for focused client only)
    -- awful.key({ alt }, "t",
    --     function (c)
    --         -- Don't toggle if titlebars are used as borders
    --         if not beautiful.titlebars_imitate_borders then
    --             awful.titlebar.toggle(c)
    --         end
    --     end,
    --     {description = "toggle titlebar", group = "client"}),
    -- Toggle titlebar (for all visible clients in selected tag)
    awful.key({ alt, shiftkey }, "t",
        function (c)
            --local s = awful.screen.focused()
            local clients = awful.screen.focused().clients
            for _, c in pairs(clients) do
                -- Don't toggle if titlebars are used as borders
                if not beautiful.titlebars_imitate_borders then
                    awful.titlebar.toggle(c)
                end
            end
        end,
        {description = "toggle titlebar", group = "client"}),

    -- toggle fullscreen
    awful.key({ superkey }, "f",
        function (c)
            local c = client.focus
            if c then
                c.fullscreen = not c.fullscreen
                c:raise()
            end
        end,
        { description = "toggle fullscreen", group = "client"}),

    -- toggle maximized
    awful.key({ superkey }, "d",
        function (c)
            local c = client.focus
            if c then
                c.maximized = not c.maximized
                c:raise()
            end
        end ,
        { description = "toggle maximized", group = "client"}),

    -- minimize client
    awful.key({ superkey }, "s",
        function (c)
            local c = client.focus
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            if c then
                c.minimized = true
            end
        end,
        { description = "minimize", group = "client"}),

    -- restore minimized client
    awful.key({ superkey }, "a",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,
        { description = "restore minimized", group = "client"}),

    -- kill current client
    awful.key({ superkey }, "Escape",
        function ()
                local c = client.focus
                if c then
                    c:kill()
                end
        end,
        { description = "kill client", group = "client" }),

    -- toggle floating layout mode
    awful.key({ superkey }, "space",  
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client"}),

    -- move to master
    --awful.key({ superkey, control }, "Return", function (c) c:swap(awful.client.getmaster())   end,
    --          {description = "move to master", group = "client"}),

    -- move to screen
    --awful.key({ superkey }, "o",      function (c) c:move_to_screen()               end,
    --          {description = "move to screen", group = "client"}),

    -- toggle "keep on top"
    --awful.key({ superkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
    --         {description = "toggle keep on top", group = "client"}),

    ------ other client-related keybindings

    -- superkey + u
    -- jump to urgent client
    awful.key({ superkey }, "z", 
        awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client"})
)
    -- superkey + Tab
    -- go to the previously visited client
    -- awful.key({ superkey }, "Tab",
    --    function ()
    --        awful.client.focus.history.previous()
    --        if client.focus then
    --            client.focus:raise()
    --        end
    --    end,
    --    {description = "go back", group = "client"}),

    ---------------
    -- Misc
    ---------------
keys.globalkeys = gears.table.join(keys.globalkeys,

    -- superkey + shift + h
    -- show help
    awful.key({ superkey, shift }, "h",      hotkeys_popup.show_help,
              { description="show help", group="awesome"})
)

keys.globalkeys = gears.table.join(keys.globalkeys,

    ---------------
    -- Sidebar
    ---------------
    awful.key({ alt }, "s",
        function()
            piglets.sidebar.sidebar.visible = not piglets.sidebar.sidebar.visible
            piglets.sidebar.sidebar.ontop = not piglets.sidebar.sidebar.ontop
            audio_widget_module.notification_audio_bar_bg.visible = false
        end,
        { description = "toggle sidebar", group = "sidebar"}),

    awful.key({ superkey }, "F1", 
        function()
            awful.spawn('volumectl down')
        end,
        { description = "decrease volume by 5%", group = "sidebar"}),

    awful.key({ superkey }, "F2", 
        function()
            awful.spawn('volumectl up')
        end,
        { description = "increase volume by 5%", group = "sidebar"}),

    awful.key({ superkey }, "F3", 
        function()
            awful.spawn('volumectl toggle')
        end,
        { description = "toggle volume", group = "sidebar"}),

    awful.key({ superkey }, "F4", 
        function()
            awful.spawn('volumectl reset')
        end,
        { description = "reset volume to 50%", group = "sidebar"})
)

keys.globalkeys = gears.table.join(keys.globalkeys,
    ----------------
    -- Hogbar
    ----------------
    awful.key({ superkey }, 'F9', porkerpanel.show_panel,
        { description = "show exit panel", group = "sidebar"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    keys.globalkeys = gears.table.join(keys.globalkeys,
        -- View tag only.
        awful.key({ superkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ superkey, control }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ superkey, shift }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ superkey, control, shift }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

-- Mouse buttons on the desktop ( the actual background image )
keys.desktopbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c then
            client.focus = c
            c:raise()
        end
        utils.check_double_tap( function() end )
    end)
)

-- Mouse buttons on the client (whole window, not the titlebar)
keys.clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        naughty.destroy_all_notifications()
        piglets.sidebar.sidebar.visible = false

        client.focus = c
        c:raise()
    end),
    awful.button({ superkey }, 1, awful.mouse.client.move),
    awful.button({ superkey }, 3, awful.mouse.client.resize)
)

return keys
