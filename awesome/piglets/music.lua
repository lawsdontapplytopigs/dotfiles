
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local utils = require("utils")
local dpi = xresources.apply_dpi
local gears = require("gears")

local music = {}

local song_status = wibox.widget.textbox("Current song:")
song_status.font = beautiful.song_status_font

local music_info = wibox.widget.textbox("Loading...")
music_info.font = beautiful.music_info_font

local song_data = wibox.widget({
    {
        song_status,
        halign = 'center',
        widget = wibox.container.place,
    },
    utils.pad_height(1),
    {
        {
            id = "scrolling_song",
            music_info,
            max_size = dpi(280),
            speed = 80,
            fps = 60,
            step_function = wibox.container.scroll.step_functions
                .waiting_nonlinear_back_and_forth,
            widget = wibox.container.scroll,
            layout = wibox.container.scroll.horizontal,
        },
        halign = 'center',
        widget = wibox.container.place,
    },
    layout = wibox.layout.fixed.vertical,
})

song_data:connect_signal("mouse::enter", 
    function()
        song_data.get_children_by_id(song_data, "scrolling_song")[1]:reset_scrolling()
        song_data.get_children_by_id(song_data, "scrolling_song")[1]:pause()
    end
)

song_data:connect_signal("mouse::leave",
    function()
        song_data.get_children_by_id(song_data, "scrolling_song")[1]:continue()
    end
)

local button_size = dpi(70)

-- make the toggle button
local toggle_button = wibox.widget.imagebox(beautiful.toggle_button_icon)
toggle_button.forced_height = button_size
toggle_button.forced_width = button_size

-- make the next button
local next_button = wibox.widget.imagebox(beautiful.next_button_icon)
next_button.forced_height = button_size
next_button.forced_width = button_size

-- make the prev button
local prev_button = wibox.widget.imagebox(beautiful.prev_button_icon)
prev_button.forced_height = button_size
prev_button.forced_width = button_size

local toggle_buttons = gears.table.join(
    awful.button({ }, 1,
        function()
            awful.spawn([[ bash -c "mpc toggle" ]])
        end
    )
)
toggle_button:buttons(toggle_buttons)

local next_buttons = gears.table.join(
    awful.button({ }, 1, 
        function()
            awful.spawn([[ bash -c "mpc next" ]])
        end
    )
)
next_button:buttons(next_buttons)

local prev_buttons = gears.table.join(
    awful.button({ }, 1,
        function()
            awful.spawn([[ bash -c "mpc prev" ]])
        end
    )
)
prev_button:buttons(prev_buttons)

-- here we put the buttons together and we put them in a layout that automatically
-- arranges them to be in the middle of the sidebar (or of whatever widget they're
-- placed in)
local put_buttons_together = wibox.widget({
    {
        prev_button,
        toggle_button,
        next_button,
        layout = wibox.layout.fixed.horizontal,
    },
    halign = 'center',
    widget = wibox.container.place,
})

-- put the buttons and the song info in the table to be returned at the end
music.music_widget = ({
    put_buttons_together,
    song_data,
    layout = wibox.layout.fixed.vertical,
})


-- I don't like getting the artist name, the name of the song etc from
-- the metadata because sometimes songs don't have it, then I have to edit
-- the metadata, etc etc, whereas pretty much all songs have a file name.
-- And that's exactly what I'll use to display in the widget
local is_song_playing_script = [[ bash -c "mpc status | head -n2 | tail -n1 | grep -o 'playing'" ]]

local function update_music()

    -- if it's playing
    awful.spawn.easy_async(is_song_playing_script, 
        function(out) 
            local is_playing = out == 'playing\n'
            song_status.text = 'Current song:'
            if is_playing then
                song_status.text = 'Now playing:'
            end
        end
    )

    awful.spawn.easy_async([[bash -c '~/.config/awesome/bin/mpc_song.sh']], 
        function(txt)
            music_info.text = txt
        end
    )

end
update_music()

local mpc_subscribe_script = [[ bash -c 'mpc idleloop player' ]]
awful.spawn.with_line_callback(mpc_subscribe_script, {
    stdout = function (line) 
        update_music(line) 
    end 
})

return music

