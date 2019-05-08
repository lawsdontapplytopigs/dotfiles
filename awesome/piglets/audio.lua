
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local utils = require("utils")
local timer = require("gears.timer")

local audio = {}

local audio_icon = beautiful.audio_icon or nil
local icon_size = beautiful.icon_size or dpi(20)

-- intentionally set ugly fallback colors so I know something's wrong
local top_color = beautiful.audio_bar_top_color or '#22ee22'
local bottom_color = beautiful.audio_bar_bottom_color or '#22ee22'
local top_color_muted = beautiful.audio_bar_top_color_muted or '#aaaaaa'
local bottom_color_muted = beautiful.audio_bar_bottom_color_muted or '#444444'

-- the icon
audio.audio_icon_widget = wibox.widget({
    forced_width = icon_size,
    forced_height = icon_size,
    widget = wibox.widget.imagebox(audio_icon),
    })

-- the sidebar audio bar
audio.audio_bar_widget = wibox.widget({
    max_value           = 100,
    bar_shape           = beautiful.top_infobar_shape or gears.shape.rectangle,
    color               = top_color,
    margins = {
        -- just so I only have to edit the size once at the top of the file
        top = icon_size / 5.5,
        bottom = icon_size / 5.5,
    },
    forced_height       = beautiful.infobar_height or dpi(10),
    forced_width        = beautiful.infobar_width or dpi(30), 
    background_color    = bottom_color,
    shape               = beautiful.bottom_infobar_shape or gears.shape.rectangle,
    widget              = wibox.widget.progressbar,
})

-- this is where we put together the icon and the sidebar audio bar
audio.audio_widget = wibox.widget({
    audio.audio_icon_widget,
    utils.pad_width(20),
    audio.audio_bar_widget,
    layout = wibox.layout.fixed.horizontal,
})

-- the bottom-right audio bar that's supposed to act as a notification
audio.notification_audio_bar = wibox.widget({
    max_value           = 100,
    bar_shape           = beautiful.top_infobar_shape or gears.shape.rectangle,
    color               = top_color,
    -- forced height and width don't do anything in this context
    -- because the widget stretches to meet the geometry of the
    -- parent widget (the widget it's nested in)
    -- forced_height       = beautiful.infobar_height or dpi(10),
    -- forced_width        = beautiful.infobar_width or dpi(35),
    background_color    = bottom_color,
    shape               = beautiful.bottom_infobar_shape or gears.shape.rectangle,
    widget              = wibox.widget.progressbar,
})

-- the background for the notification audio bar, on top of which 
-- we acutally put the notification
audio.notification_audio_bar_bg = wibox({
    x = awful.screen.focused().geometry.width - dpi(400),
    y = awful.screen.focused().geometry.height - dpi(100),
    height = beautiful.infobar_height or dpi(30),
    width = beautiful.infobar_width or dpi(300),
    shape = gears.shape.rectangle,
    bg = "#00000000",
    widget = audio.notification_audio_bar,
    visible = false,
    -- setting the type as dock allows compton to recognize it as dock
    -- and not draw shadows for it
    type = 'dock',
})


local function update_widget(event)
    -- event is just a line that gets outputted by the 'pactl subscribe 2' command

    -- I don't know for sure if the first sink always has the number '0', 
    -- so this is kind of a hack, but it works pretty well.
    -- EDIT: I found out that the default sink is not always '0', but this
    -- whole thing still works without a problem
    sink_number = '0'

    if event then
        if string.match(event, 'remove') then
            sink_number = '0'
        elseif string.match(event, 'new') or string.match(event, 'change') then
            sink_number = string.match(event, 'sink #(%d)')
        end
    end

    -- naughty.notify({text = tostring(sink_number)})
    awful.spawn.easy_async({"sh", "-c", "pactl list sinks"},
        function(stdout)
            local current_sink = string.match(stdout, 'Sink #'..sink_number..'.*')
            local volume = string.match(current_sink, '(%d+)%% /')
            local muted = string.match(stdout, 'Mute: [yes]')

            _top_color = top_color
            _bottom_color = bottom_color

            if muted ~= nil then
                _top_color = top_color_muted
                _bottom_color = bottom_color_muted
            end

            -- the sidebar audio widget
            local wid = audio.audio_bar_widget
            wid.value = tonumber(volume)
            wid.color = _top_color
            wid.background_color = _bottom_color

            -- the notification audio widget
            local bottom_wid = audio.notification_audio_bar
            bottom_wid.value = tonumber(volume)
            bottom_wid.color = _top_color
            bottom_wid.background_color = _bottom_color

        end
    )
end

update_widget()


-- Sleeps until pactl detects an event (volume up/down/toggle/mute)
local volume_script = [[
  bash -c '
  pactl subscribe 2> /dev/null | grep --line-buffered "sink #"
  ']]

awful.spawn.with_line_callback(volume_script, {
                                    stdout = function(line)
                                        update_widget(line)
                                        -- naughty.notify({text = tostring(line)})
                                     end
})


return audio
