#!/usr/bin/bash

song_name=$(~/.config/awesome/bin/mpc_song.sh)
notify-send "$song_name"

