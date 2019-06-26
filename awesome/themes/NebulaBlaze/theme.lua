
---------------------------
-- Nebula Blaze
---------------------------

local theme_name = "NebulaBlaze"
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local gears = require("gears")
local utils = require("utils")

-- get naughty for debugging ;;;;)
local naughty = require("naughty")

local home = os.getenv("HOME")
local titlebar_icon_path = home .. "/.config/awesome/themes/" .. theme_name .. "/titlebar/"
local theme_folder = '~/.config/awesome/themes/'..theme_name..'/'

local theme = {}
theme.theme_path = home .. "/themes/" .. theme_name .. "/"

-------------------
-- Fonts
-------------------
-- Set the theme font. This is the font that will be used in menus, bars, titlebars, etc.
-- "Roboto Bold 12"
-- font = 'HelveticaNeueLTCom,HelveticaNeueLTCom25UltLt Light 20',

-- The reason I have this here, is so the padding stays consistent across
-- theme font changes.
-- Currently, the padding in widgets is done through spaces, since I don't
-- know how to do it any other way. As you can imagine, the smaller the font,
-- the smaller the spaces, the finer level of control I have over the padding.
-- The `whatever` font name just loads the default font, since `whatever` is
-- not a valid font name. At least not installed on this system.
-- EDIT: Padding with fonts is not scalable or responsive, you big ol' dummy :^) :^) :^) :^)
theme.padding_font = 'whatever 2'
-- theme.font = "TTCommons Medium 14"
theme.font = "Roboto Medium 12"
theme.monospace_font = "RobotoMono 13"

-- theme.icon_theme = '/usr/share/icons/Paper'

-- gray colors, with a slight shade of purple
-- local potential_gray1 = '#6c6a80'
-- local potential_gray2 = "#34333f"

local gray1       = "#201e24"
local gray2       = "#343038"
local gray3       = "#5c5860"
local gray4       = "#8e8a92"
local gray5       = "#c0bcc4"
local gray6       = "#d4d0d8"
local pretty_gray = '#9290a0'


-- local bg          = "#201e2a"
-- local bg1         = "#1f1e2a"
-- local bg_light    = "#2f2e3a"
-- local bg_light    = "#1f1e2a" -- really nice color
-- local bg_light    = "#1a1820"
local bg          = "#15131e"
local bg1         = "#1f1e2a"
-- local bg_light    = "#201e2b"
local bg_light    = "#1a1823"
local gamer_pink  = "#e92f52"
local red         = "#9a3049"
local blue        = "#40cfd8"
-- local blue        = "#77ffff"
local pink        = "#ff8bff"
local purple      = "#8860ed"
local beige       = "#e6c098"
local gray        = "#585070"
local fg          = "#ffffff"


-------------------
-- Global default theme colors
-------------------
-- what these do is pretty ambiguous. They seem to act as default colors for
-- certain aspects of the theme like the titlebars
-- I'll have to see if I can configure everything specifically 
-- and then maybe remove them
theme.bg            = bg -- this is not an awesomewm fallback color. I added it
theme.bg_normal     = bg_light
theme.bg_focus      = bg_light
theme.bg_urgent     = gamer_red
theme.bg_minimize   = bg_light
theme.bg_systray    = bg_light

-- this is basically the text on titlebars
theme.fg            = fg -- this is not an awesomewm fallback color. I added it
theme.fg_normal     = fg
theme.fg_focus      = fg
theme.fg_urgent     = fg
theme.fg_minimize   = fg

theme.gray1       = gray1       
theme.gray2       = gray2       
theme.gray3       = gray3       
theme.gray4       = gray4       
theme.gray5       = gray5       
theme.gray6       = gray6       
theme.pretty_gray = pretty_gray 

-------------------
-- Gaps
-------------------
theme.useless_gap   = dpi(5)
-- This could be used to manually determine how far away from the screen edge
-- the bars / notifications should be.
theme.screen_margin = dpi(10)

-------------------
-- Borders
-------------------
theme.border_width  = dpi(0)    -- hide client border
theme.border_normal = "#00ff00"
theme.border_focus  = "#00ff00" -- currently the border is 0 so it doesn't matter
theme.border_marked = "#00ff00"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Variables set for theming notifications
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
-- These are basically the default little squares on the tags that show whether or not
-- you have windows open there
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)
-- theme.taglist_fg_focus = "#ff0077"
-- theme.taglist_font = "TTCommons Bold 15"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-------------------
-- Rounded corners
-------------------
theme.border_radius = dpi(7) -- set roundness of corners

-- Until I either learn to use the new naughty api 
-- OR write my own notification library, I'll just use this
-------------------
-- Notifications
-------------------
-- Position: bottom_left, bottom_right, bottom_middle,
--         top_left, top_right, top_middle
theme.notification_position = "top_right" -- BUG: some notifications appear at top_right regardless
theme.notification_border_width = 1
theme.notification_shape = utils.rrect(7)
theme.notification_bg = "#ffffff"
theme.notification_fg = "#1a1820"
theme.notification_crit_bg = "#fe3f52"
theme.notification_crit_fg = "#350910"
theme.notification_icon_size = dpi(60)
theme.notification_height = dpi(80)
theme.notification_width = dpi(300)
theme.notification_margin = dpi(15)
theme.notification_opacity = 1
theme.notification_font = "#TTCommons Medium 13"
theme.notification_padding = theme.screen_margin * 2
theme.notification_spacing = theme.screen_margin * 2
------------------------------------------------------------------------------- MENU (RIGHT CLICK)
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-------------------
-- Sidebar
-------------------
-- Colors
-- theme.sidebar_bg = "#242430"
theme.sidebar_bg = bg
theme.sidebar_fg = "#ffffff"

-- Weather
local weather_dir = theme_folder .. 'weather/'
theme.sun_icon = weather_dir .. 'sun.png'
theme.moon_icon = weather_dir .. 'moon.svg'
theme.dclouds_icon = weather_dir .. 'dcloud.png'
theme.nclouds_icon = weather_dir .. 'ncloud.png'
theme.cloud_icon = weather_dir .. 'cloud.png'
theme.dark_cloud_icon = weather_dir .. 'cloud.png'
theme.rain_icon = weather_dir .. 'rain.png'
theme.storm_icon = weather_dir .. 'storm.png'
theme.snow_icon = weather_dir .. 'snow.png'
theme.mist_icon = weather_dir .. 'mist.png'
theme.whatever_icon = weather_dir .. 'whatever.png'

theme.weather_font = 'TTCommons 22' or 'Roboto 24' or theme.font


-- Mpd client
theme.song_status_font = 'TTCommons Medium 18' or 'Roboto Bold 20' or theme.font
theme.music_info_font = 'TTCommons 16' or 'Roboto Light 18' or theme.font

theme.next_button_icon = theme_folder .. 'sidebar/playerctl_next.png'
theme.prev_button_icon = theme_folder .. 'sidebar/playerctl_prev.png'
theme.toggle_button_icon = theme_folder .. 'sidebar/playerctl_toggle.png'

-- Icons 
-- note: this will impact how big the bars will appear. set them with caution
-- and yes, I should fix this
theme.icon_size = dpi(55)

-- the bars geometry
theme.top_infobar_shape = gears.shape.rounded_bar
theme.bottom_infobar_shape = gears.shape.rounded_bar
theme.infobar_width = dpi(330)
theme.infobar_height = dpi(40)

-- Audio
theme.audio_icon = theme_folder .. 'sidebar/volume.png'
theme.audio_bar_top_color = '#ffd143'
theme.audio_bar_bottom_color = '#b48800'
theme.audio_bar_top_color_muted = gray4
theme.audio_bar_bottom_color_muted = gray2

-- Cpu Temperature
theme.temperature_icon = theme_folder .. 'sidebar/temperature.png'
theme.temperature_bar_top_color = '#e92f52'
theme.temperature_bar_bottom_color = '#8b0039'

-- Cpu
theme.cpu_icon = theme_folder .. 'sidebar/cpu.png'
theme.cpu_bar_top_color = '#00cece'
theme.cpu_bar_bottom_color = '#007676'

-- Ram
theme.ram_icon = theme_folder .. 'sidebar/ram.png'
theme.ram_bar_top_color     = '#551383'
theme.ram_bar_bottom_color  = '#2f0a49'
-- theme.ram_bar_top_color = '#8860ed'
-- theme.ram_bar_bottom_color = '#432b6b'

-------------------
-- Titlebars
-------------------
theme.titlebars_enabled = true
theme.titlebar_height = 42
theme.titlebar_title_enabled = false
theme.titlebar_font = theme.font
-- Titlebar text alignment : left, right, center
theme.titlebar_title_align = "left"
theme.titlebar_position = "top"
-- Titlebar color
theme.titlebar_bg_normal = bg_light
theme.titlebar_bg_focus = bg_light
-- Titlebar text color
-- theme.titlebar_fg_normal = pretty_gray
-- theme.titlebar_fg_focus = pretty_gray
theme.titlebar_fg_normal = "#ffffff"
theme.titlebar_fg_focus = "#ffffff"

-- Titlebar buttons
-- Define the images to load
local tip = titlebar_icon_path -- alias to save time/space
-- theme.titlebar_close_button_normal = tip .. "close_normal.svg"
-- theme.titlebar_close_button_focus  = tip .. "close_focus.svg"
-- local ex_tip = home .. "/.conifg/awesome/themes/" .. theme_name .. "/titlebar2/"
local ex_tip = theme_folder .. "titlebar2/"

-- regular
theme.titlebar_close_button_normal = ex_tip .. "close/close_1.svg"
theme.titlebar_close_button_focus = ex_tip .. "close/close_2.svg"
theme.titlebar_maximized_button_normal_inactive = ex_tip .. "maximize/maximize_1.svg"
theme.titlebar_maximized_button_focus_inactive  = ex_tip .. "maximize/maximize_2.svg"
theme.titlebar_maximized_button_normal_active = ex_tip .. "maximize/maximize_3.svg"
theme.titlebar_maximized_button_focus_active  = ex_tip .. "maximize/maximize_3.svg"
theme.titlebar_minimize_button_normal = ex_tip .. "minimize/minimize_1.svg"
theme.titlebar_minimize_button_focus  = ex_tip .. "minimize/minimize_2.svg"

-- hover
theme.titlebar_close_button_normal_hover = ex_tip .. "close/close_3.svg"
theme.titlebar_close_button_focus_hover = ex_tip .. "close/close_3.svg"
theme.titlebar_maximized_button_normal_inactive_hover = ex_tip .. "maximize/maximize_3.svg"
theme.titlebar_maximized_button_focus_inactive_hover  = ex_tip .. "maximize/maximize_3.svg"
theme.titlebar_maximized_button_normal_active_hover = ex_tip .. "maximize/maximize_3.svg"
theme.titlebar_maximized_button_focus_active_hover  = ex_tip .. "maximize/maximize_3.svg"
theme.titlebar_minimize_button_normal_hover = ex_tip .. "minimize/minimize_3.svg"
theme.titlebar_minimize_button_focus_hover  = ex_tip .. "minimize/minimize_3.svg"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

local piggyprompt_location = "themes.".. theme_name .. ".piggyprompt.piggyprompt"
theme.piggyprompt = require(piggyprompt_location)

-- Hogbar theme
-- theme.tasklist_bg_normal = '#00000000'
-- themetasklist_bg_urgent = '#22000022'

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- theme.wallpaper = home ..'/images/elementaryos/wallpapers/Ashim_DSilva.jpg'
-- theme.wallpaper = home .. '/EHGgqUq.jpg'
-- theme.wallpaper = home .. '/images/21_9_wallpapers/Swe2Jap.png'
-- theme.wallpaper = home .. '/images/21_9_wallpapers/1y1cMG2.jpg'
-- theme.wallpaper = home .. "/images/16_9_wallpapers/4d6ed381483061.5d00e215315d2.jpg"
-- theme.wallpaper = home .. "/images/16_9_wallpapers/3e9b1878521481.5ca708b1684c4.jpg"
theme.wallpaper = theme_folder .. "cael_gibran_the_spirits_moon_and_sun.jpg"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "/usr/share/icons/Paper"

-- Launcher theme
theme.launcher_radius = 33

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
