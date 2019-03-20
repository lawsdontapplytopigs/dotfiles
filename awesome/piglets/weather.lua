local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local personal = require("piglets.personal_dont_put_on_github")
local dpi = require("beautiful").xresources.apply_dpi
local utils = require("utils")

-- update as much as you want. Awesome just reads the weather from a file ;)
update_interval = 7200 -- in secs (he said sex haha)

local weather = {}

local weather_text = wibox.widget{
    text = "Loading...",
    -- align  = 'center',
    valign = 'center',
    font = beautiful.weather_font or beautiful.font,
    widget = wibox.widget.textbox
}

naughty.notify({text = tostring(weather_text:get_preferred_size(1))})

local weather_icon = wibox.widget.imagebox(beautiful.whatever_icon)
weather_icon.resize = true
weather_icon.visible = true
weather_icon.forced_width = dpi(80)
weather_icon.forced_height = dpi(80)
naughty.notify({text = tostring(weather_icon.width)})

weather.weather_widget = wibox.widget({
    weather_icon,
    weather_text,
    layout = wibox.layout.fixed.horizontal,
})


-- weather.weather_widget = wibox.container.constraint(_weather_widget, 'min', dpi(170))

local function update_widget(icon_code, weather_details)
  -- Set icon
  -- these are actually all the icons supported by the openweathermap api, 
  -- at least at the time of this writing (18, march, 2018)
  if string.find(icon_code, "01d") then
    weather_icon.image = beautiful.sun_icon
  elseif string.find(icon_code, "01n") then
    weather_icon.image = beautiful.moon_icon
  elseif string.find(icon_code, "02d") then
    weather_icon.image = beautiful.dclouds_icon
  elseif string.find(icon_code, "02n") then
    weather_icon.image = beautiful.nclouds_icon
  elseif string.find(icon_code, "03d") or string.find(icon_code, "03n") then
    weather_icon.image = beautiful.cloud_icon
  elseif string.find(icon_code, "04d") or string.find(icon_code, "04n")  then
    weather_icon.image = beautiful.dark_cloud_icon
  elseif string.find(icon_code, "09") or string.find(icon_code, "10") then
    weather_icon.image = beautiful.rain_icon
  elseif string.find(icon_code, "11") then
    weather_icon.image = beautiful.storm_icon
  elseif string.find(icon_code, "13") then
    weather_icon.image = beautiful.snow_icon
  elseif string.find(icon_code, "50") or string.find(icon_code, "40") then
    weather_icon.image = beautiful.mist_icon
  else
    weather_icon.image = beautiful.whatever_icon
  end

  -- Set text --
  -- Replace -0 with 0 degrees
  weather_details = string.gsub(weather_details, '%-0', '0')
  -- Capitalize first letter of the description
  weather_details = weather_details:sub(1,1):upper()..weather_details:sub(2)
  weather_text.markup = weather_details
end

local get_weather_script = [[ bash -c "cat ~/WEATHER" ]]

awful.widget.watch(get_weather_script, update_interval, function(widget, stdout)
                    local icon_code = string.sub(stdout, 1, 3)
                    local _weather_details = string.sub(stdout, 5)
                    local weather_details = string.gsub(_weather_details, '^%s*(.-)%s*$', '%1')
                    update_widget(icon_code, weather_details)
end)

return weather

