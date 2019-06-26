#!/usr/bin/env fish
# Xephyr :5 & sleep 1; env DISPLAY=:5 awesome
Xephyr -screen 1920x1080 :5 & sleep 1; env DISPLAY=:5 awesome

