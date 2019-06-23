
local awful = require("awful")
local naughty = require("naughty")

-- trufflebar specific key handling
local function run_keygrabber( args )
    local trufflebar = args.trufflebar
    local mid_widget = trufflebar:get_children_by_id("middle_widget_nested")

    trufflebar_grabber = awful.keygrabber({
        -- you actually have to do this boilerplate just to 
        -- start it without adding an entry to the keys.lua file
        keybindings = {
            {{"Mod1"}, "F10", function() end}, 
        },
        stop_key = {{"Mod1"},"F10"},
        start_callback = function()
            trufflebar.visible = true
        end,
        stop_callback = function ()
            trufflebar.visible = false
        end,

        keypressed_callback = function(_, modifiers, key)
            -- let's build a hash map of the modifiers
            -- hint: the `modifiers` list has numerical indexes and strings as values
            local mods = {}
            for _, val in pairs(modifiers) do
                mods[val] = true
            end

            -- "Mod1" is actually "Alt"
            if key == "j" then
                trufflebar.select_next_row()
            elseif key == "k" then
                trufflebar.select_prev_row()
            end

            -- this is where the keyboard configuration should actually be.
            -- not sure I'll actually have time though
        end,
        export_keybindings = true,
    })

    return trufflebar_grabber
end

return run_keygrabber
