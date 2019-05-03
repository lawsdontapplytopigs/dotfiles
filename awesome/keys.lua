local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local utils = require("utils")
local piglets = require("piglets")
local audio_widget_module = require("piglets.audio")
local porkerpanel = require("piglets.porkerpanel")
local trufflequest = require("piglets.trufflequest.trufflequest")

local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")                          ---------------- might take this out. have to see if it does anything

local keys = {}

local shift = "Shift"
local control = "Control"
local superkey = "Mod4"
local alt = "Mod1"


-- for k, v in pairs(piglets.custom_prompt) do
    -- naughty.notify({text = tostring(k)})
-- end

-- put global variables in a file
-- for k, _ in pairs(_G) do
    -- file = io.open("/home/ciugamenn/awesome_globals.txt", "a")
    -- file:write(tostring(k)..'\n')
    -- file:close()
-- end



-------------------
-- glossary
-------------------

-- client: basically, the windows of programs
-- tags: workspaces or "desktops"


keys.desktopbuttons = gears.table.join(
    awful.button({ }, 1, function (c)

        if c then
            client.focus = c
            c:raise()
        end
        local function double_tap() 
            naughty.notify({text = tostring("ses")})
        end

        utils.single_double_tap(function() end, double_tap)
    end),
    awful.button({ }, 3, function () mymainmenu:toggle() end)
)

keys.globalkeys = gears.table.join(

    ---------------
    -- Screens
    ---------------

    -- superkey + 'Control' + 'k' focus the prev screen
    awful.key({ superkey }, "e", function () awful.screen.focus_relative(-1) end,
              { description = "focus the previous screen", group = "screen"}),

    -- superkey + 'Control' + 'j' focus the next screen
    awful.key({ superkey }, "r", function () awful.screen.focus_relative( 1) end,
              { description = "focus the next screen", group = "screen"}),


    ---------------
    -- Tags
    ---------------

    -- superkey + q
    -- view previous tag
    awful.key({ superkey }, "q", awful.tag.viewprev,
            {description = "view previous", group = "tag"}),

    -- superkey + w
    -- view next tag
    awful.key({ superkey }, "w",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),

    -- superkey + 'Escape' 
    -- go back to the previous tag you visited
    -- awful.key({ superkey }, "Escape", awful.tag.history.restore,
    --          {description = "go back", group = "tag"}),


    ---------------
    -- Program-related
    ---------------
    
    -- superkey + 'Shift' + 'r' to restart awesomeWM
    -- PRO TIP: 'Shift_L' doesn't work ;)
    awful.key({ superkey, shift }, "t", awesome.restart,
              { description = "reload awesome", group = "awesome"}),

    -- superkey + 'Shift' + 'Escape' to quit awesome
    awful.key({ superkey, shift }, "Escape", awesome.quit,
              { description = "quit awesome", group = "awesome"}),

    -- superkey + o
    -- show main menu
    awful.key({ superkey }, "c", function () mymainmenu:show() end,
              { description = "show main menu", group = "awesome"}),

    -- STANDARD PROGRAM
    
    -- alt + 'grave' to start a terminal
    awful.key({ alt }, "grave", function () awful.spawn('st') end,
              { description = "open a terminal", group = "awesome"}),


    -- superkey + 'grave' to start a terminal
    awful.key({ superkey }, "grave", function () awful.spawn('st') end,
              { description = "open a terminal", group = "awesome"}),


    -- superkey + 'Shift' + 'h'
    --awful.key({ superkey, shift }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
    --          {description = "increase the number of master clients", group = "layout"}),

    -- superkey + 'Shift' + 'l'
    --awful.key({ superkey, shift }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
    --          {description = "decrease the number of master clients", group = "layout"}),

    -- superkey + 'Control' + 'h'
    --awful.key({ superkey, control }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
    --          {description = "increase the number of columns", group = "layout"}),

    -- superkey + 'Control' + 'l' 
    --awful.key({ superkey, control }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
    --          {description = "decrease the number of columns", group = "layout"}),

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


    awful.key({ alt }, "r", piglets.piggyprompt.launch,
        { description = "Run programs", group = "awesome"}),

    -- superkey + x
    -- run-lua-code prompt
    awful.key({ alt }, "l",
        function ()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        {description = "lua execute prompt", group = "awesome"}),

    -- Menubar
    -- this is broken currently (30, march, 2019)
    -- awful.key({ superkey }, "x", 
        -- function() 
            -- menubar.show() 
            -- naughty.notify({text = tostring(capi.selection())})
        -- end,
    -- {description = "show the clipboard contents", group = "awesome"}),


    ---------------
    -- Clients
    ---------------

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
        { description = "focus previous client", group = "client"}),

    ------ LAYOUT MANIPULATION

    ------ use superkey + arrow keys to focus clients

    -- superkey + Up
    -- focus client by direction: up
    awful.key({ superkey }, "Up",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus up", group = "client"}),

    -- superkey + Right
    -- focus client by direction: right
    awful.key({ superkey }, "Right",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus right", group = "client"}),

    -- superkey + Down
    -- focus client by direction: down
    awful.key({ superkey }, "Down",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus down", group = "client" }),

    -- superkey + Left
    -- focus client by direction: left
    awful.key({ superkey }, "Left",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus left", group = "client"}),

    ------ Swapping places between clients with superkey + shift + arrow keys
    
    -- superkey + shift + up
    -- swap places with the client above
    awful.key({ superkey, shift }, "Up", 
        function () 
            awful.client.swap.bydirection("up")
        end,
        { description = "swap with the client above", group = "client"}),

    -- superkey + shift + right
    -- swap places with the client on the right
    awful.key({ superkey, shift }, 'Right',
        function ()
            awful.client.swap.bydirection("right")
        end,
        { description = "swap with the client on the right", group = "client"}),

    -- superkey + shift + down
    -- swap places with the client below
    awful.key({ superkey, shift }, "Down", 
        function () 
           awful.client.swap.bydirection("down")
        end,
        { description = "swap with the client below", group = "client"}),

    -- superkey + shift + left
    -- swap with the client on the left
    awful.key({ superkey, shift }, "Left",
        function ()
            awful.client.swap.bydirection("left")
        end,
        { description = "swap with the client on the left", group = "client" }),

    ------ resizing clients with superkey + control + arrows

    -- superkey + control + right to increase window width
    awful.key({ superkey, control }, "Right",
        function () 
                awful.tag.incmwfact( 0.03)
        end,
        { description = "increase master width factor", group = "client"}),

    -- superkey + control + left to decrease window width
    awful.key({ superkey, control }, "Left",
        function () 
            awful.tag.incmwfact(-0.03) 
        end,
        { description = "decrease master width factor", group = "client"}),
    


    ------ use superkey + vim navigation keys to focus clients

    -- superkey + Up
    -- focus client by direction: up
    awful.key({ superkey }, "k",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus up", group = "client"}),

    -- superkey + Right
    -- focus client by direction: right
    awful.key({ superkey }, "l",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus right", group = "client"}),

    -- superkey + Down
    -- focus client by direction: down
    awful.key({ superkey }, "j",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus down", group = "client" }),

    -- superkey + Left
    -- focus client by direction: left
    awful.key({ superkey }, "h",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus left", group = "client"}),


    ------ Swapping places between clients with superkey + [yuio]

    -- superkey + i
    -- swap places with the client above
    awful.key({ superkey }, "i",
        function () 
            awful.client.swap.bydirection("up")
        end,
        { description = "swap with the client above", group = "client"}),

    -- superkey + o
    -- swap places with the client on the right
    awful.key({ superkey }, 'o',
        function ()
            awful.client.swap.bydirection("right")
        end,
        { description = "swap with the client on the right", group = "client"}),

    -- superkey + u
    -- swap places with the client below
    awful.key({ superkey }, "u",
        function () 
           awful.client.swap.bydirection("down")
        end,
        { description = "swap with the client below", group = "client"}),

    -- superkey + y
    -- swap with the client on the left
    awful.key({ superkey }, "y",
        function ()
            awful.client.swap.bydirection("left")
        end,
        { description = "swap with the client on the left", group = "client" }),
    

    ------ resizing clients with superkey + [n.]keys

    -- superkey + . to increase window width
    awful.key({ superkey }, "period",
        function () 
            awful.tag.incmwfact( 0.03)
        end,
        { description = "increase master width factor", group = "client"}),

    -- superkey + n to decrease window width
    awful.key({ superkey }, "n",
        function () 
            awful.tag.incmwfact(-0.03) 
        end,
        { description = "decrease master width factor", group = "client"}),



    ------ super + shift + [er] to browse back and forth through layouts for clients

    -- superkey + shift + e select previous layout for clients
    awful.key({ superkey, shift }, "e", function () awful.layout.inc(-1)                end,
              { description = "select previous", group = "client"}),

    -- superkey + shift + r select next layout for clients
    awful.key({ superkey, shift }, "r", function () awful.layout.inc( 1)                end,
              { description = "select next", group = "client"}),


    -- superkey + f 
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

    -- superkey + s
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

    -- superkey + d
    -- toggle maximized
    awful.key({ superkey }, "d",
        function (c)
            local c = client.focus
            if c then
                c.maximized = not c.maximized
                c:raise()
            end
        end ,
        { description = "(un)maximize", group = "client"}),

    -- superkey + a
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
        { description = "close", group = "client" }),


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
        { description = "jump to urgent client", group = "client"}),



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

    -- superkey + shift + h
    -- show help
    awful.key({ superkey, shift }, "h",      hotkeys_popup.show_help,
              { description="show help", group="awesome"}),

    awful.key({ alt }, "d", 
        function()
            awful.spawn("rofi -show")
        end,
        { description="show rofi", group="rofi"})

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

-- naughty.notify({text = tostring(type(trufflequest))})
keys.globalkeys = gears.table.join(keys.globalkeys,

    awful.key({ superkey }, 'F10', 
        function ()
            if not trufflequest.trufflebar.visible then
                trufflequest.trufflebar.visible = true
                trufflequest.trufflebar.ontop = true
            else
                trufflequest.trufflebar.visible = false
            end
        end,
        { description = "show exit panel", group = "sidebar"})

)

-- naughty.notify({text = tostring(type(porkerpanel.porkerpanel))})
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

------------------------------------------------------------------------------- MOUSE BINDINGS
-- Mouse buttons on the client (whole window, not just titlebar)
keys.clientbuttons = gears.table.join(
    awful.button({ }, 1, 
        function (c)
            naughty.destroy_all_notifications()
            piglets.sidebar.sidebar.visible = false
            piglets.sidebar.sidebar.ontop = false
            -- mymainmenu:hide()

            client.focus = c
            c:raise()
        end),
    awful.button({ superkey }, 1, awful.mouse.client.move),
    awful.button({ superkey }, 3, awful.mouse.client.resize)
    -- awful.button({ }, 3, function () mymainmenu:toggle() end)
)

------------------------------------------------------------------------------- MOUSE BINDINGS END


-- Set keys
root.keys(keys.globalkeys)
-- the buttons are just for the titlebars apparently
root.buttons(keys.desktopbuttons)

return keys
