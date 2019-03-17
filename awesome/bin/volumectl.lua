
local awful = require('awful')
local sidebar = require('piglets').sidebar.sidebar
local bottom_audio_bar = require('piglets').audio.bottom_audio_bar_widget

local volumectl = {}

local volume_up_script = 'pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +$STEP%'
local volume_down_script = 'pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -$STEP%'
local toggle_volume_script = 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
local reset_volume_script = 'pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ 50%'

function volumectl.up()
    awful.spawn(volume_up_script)



if [[ "$1" = "up" ]]; then
elif [[ "$1" = "down" ]]; then
elif [[ "$1" = "toggle" ]]; then
elif [[ "$1" = "reset" ]]; then

