#!/usr/bin/bash

# The reason for this script:
# Problem:
#   the sane ways calling scripts once every `x` amount of time in awesome
#   don't maintain their state across awesome restarts and automatically invoke
#   the script when awesome restarts.
#   If you use the openweathermap api too much, they ban your account.
#   And to test new changes in awesome, you have to restart it.
#   So we can't call the openweathermap api from awesome too much, or we'll get banned

#   Solution :
#   Write this script separately, set up a cron job that would call the script
#   once every 2 hours and write the weather status to a file
#   Then have awesome read the file to get weather info.
#   This way we can restart awesome as much as we want and not get banned (*cool-as-fuck-emoji-rn*)


source ~/personal_dont_put_on_github.sh
#KEY="" we don't declare them here, they're imported from the file above
#CITY=""
UNITS="metric"
SYMBOL="°C"

weather=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?APPID=$KEY&id=$CITY_ID&units=$UNITS")

# if true; then
if [ -n "$weather" ]; then
weather_temp=$(echo "$weather" | jq ".main.temp" | cut -d "." -f 1)
weather_icon=$(echo "$weather" | jq -r ".weather[].icon" | head -1)
weather_description=$(echo "$weather" | jq -r ".weather[].description" | head -1)

CURRENT_WEATHER="$weather_icon $weather_description $weather_temp$SYMBOL"
# CURRENT_WEATHER="10n light rain 7°C"
else
CURRENT_WEATHER="... Info unavailable"
# export $CURRENT_WEATHER
fi
echo "$CURRENT_WEATHER" > $HOME/WEATHER
# echo $(env | grep "CURRENT_WEATHER")

