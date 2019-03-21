
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

-- get naughty for debugging ;)
local naughty = require("naughty")

local home = os.getenv("HOME")
local titlebar_icon_path = home .. "/.config/awesome/themes/" .. theme_name .. "/titlebar/"

local theme = {}

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
theme.padding_font = 'whatever 2'
-- theme.font = "TTCommons Medium 14"
theme.font = "Roboto Medium 12"
theme.monospace_font = "RobotoMono 13"

-- theme.icon1 = "/home/ciugamenn/adobe_color_cc.png"
-- theme.icon_theme = '/usr/share/icons/Paper'

-- gray colors, with a slight shade of purple
-- local potential_gray1 = '#6c6a80'
-- local potential_gray2 = "#34333f"

local gray1       = "#201c24"
local gray2       = "#343038"
local gray3       = "#5c5860"
local gray4       = "#8e8a92"
local gray5       = "#c0bcc4"
local gray6       = "#d4d0d8"
local pretty_gray = '#9290a0'


local bg          = "#1f1e2a"
local bg_light    = "#2f2e3a"
local gamer_pink  = "#e92f52"
local red         = "#9a3049"
local blue        = "#77ffff"
local pink        = "#ff8bff"
local purple      = "#8860ed"
local beige       = "#e6c098"
local gray        = "#5d5543"
local fg          = "#fffdd8"


-------------------
-- Global default theme colors
-------------------
-- what these do is pretty ambiguous. They seem to act as default colors for
-- certain aspects of the theme like the titlebars
-- I'll have to see if I can configure everything specifically 
-- and then maybe remove them
theme.bg_dark       = bg
theme.bg_normal     = bg_light
theme.bg_focus      = bg_light
theme.bg_urgent     = gamer_red
theme.bg_minimize   = bg_light
theme.bg_systray    = bg_light

-- this is basically the text on titlebars
theme.fg_normal     = fg
theme.fg_focus      = fg
theme.fg_urgent     = fg
theme.fg_minimize   = fg

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

-------------------
-- Notifications
-------------------
theme.notification_font = theme.font
theme.notification_border_width = 0

------------------------------------------------------------------------------- MENU (RIGHT CLICK)
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"


-------------------
-- Rounded corners
-------------------
theme.border_radius = dpi(7) -- set roundness of corners

-------------------
-- Sidebar
-------------------
-- Colors
-- theme.sidebar_bg = "#242430"
theme.sidebar_bg = bg
theme.sidebar_fg = "#ffffff"

local theme_folder = '~/.config/awesome/themes/'..theme_name..'/'

-- Weather
local weather_dir = theme_folder .. 'weather/'
theme.sun_icon = weather_dir .. 'sun.png'
theme.moon_icon = weather_dir .. 'moon.png'
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

-- theme.cpu_bar_top_color = '#8860ed'
-- theme.cpu_bar_bottom_color = '#432b6b'

-- Ram
theme.ram_icon = theme_folder .. 'sidebar/ram.png'
theme.ram_bar_top_color     = '#551383'
theme.ram_bar_bottom_color  = '#2f0a49'



-- theme.inner_bar_foreground = '#22ff22'

-- theme.outer_bar_foreground = '#22ff22'
-------------------
-- Titlebars
-------------------
theme.titlebars_enabled = true
theme.titlebar_height = 36
theme.titlebar_title_enabled = false
theme.titlebar_font = theme.font
-- Titlebar text alignment : left, right, center
theme.titlebar_title_align = "left"
theme.titlebar_position = "top"
-- Titlebar color
theme.titlebar_bg_normal = bg_light
theme.titlebar_bg_focus = bg_light
-- Titlebar text color
theme.titlebar_fg_normal = pretty_gray
theme.titlebar_fg_focus = pretty_gray

-- Titlebar buttons
-- Define the images to load
local tip = titlebar_icon_path -- alias to save time/space
theme.titlebar_close_button_normal = tip .. "close_normal.svg"
theme.titlebar_close_button_focus  = tip .. "close_focus.svg"
theme.titlebar_minimize_button_normal = tip .. "minimize_normal.svg"
theme.titlebar_minimize_button_focus  = tip .. "minimize_focus.svg"
theme.titlebar_ontop_button_normal_inactive = tip .. "ontop_normal_inactive.svg"
theme.titlebar_ontop_button_focus_inactive  = tip .. "ontop_focus_inactive.svg"
theme.titlebar_ontop_button_normal_active = tip .. "ontop_normal_active.svg"
theme.titlebar_ontop_button_focus_active  = tip .. "ontop_focus_active.svg"
theme.titlebar_sticky_button_normal_inactive = tip .. "sticky_normal_inactive.svg"
theme.titlebar_sticky_button_focus_inactive  = tip .. "sticky_focus_inactive.svg"
theme.titlebar_sticky_button_normal_active = tip .. "sticky_normal_active.svg"
theme.titlebar_sticky_button_focus_active  = tip .. "sticky_focus_active.svg"
theme.titlebar_floating_button_normal_inactive = tip .. "floating_normal_inactive.svg"
theme.titlebar_floating_button_focus_inactive  = tip .. "floating_focus_inactive.svg"
theme.titlebar_floating_button_normal_active = tip .. "floating_normal_active.svg"
theme.titlebar_floating_button_focus_active  = tip .. "floating_focus_active.svg"
theme.titlebar_maximized_button_normal_inactive = tip .. "maximized_normal_inactive.svg"
theme.titlebar_maximized_button_focus_inactive  = tip .. "maximized_focus_inactive.svg"
theme.titlebar_maximized_button_normal_active = tip .. "maximized_normal_active.svg"
theme.titlebar_maximized_button_focus_active  = tip .. "maximized_focus_active.svg"
-- (hover)
theme.titlebar_close_button_normal_hover = tip .. "close_normal_hover.svg"
theme.titlebar_close_button_focus_hover  = tip .. "close_focus_hover.svg"
theme.titlebar_minimize_button_normal_hover = tip .. "minimize_normal_hover.svg"
theme.titlebar_minimize_button_focus_hover  = tip .. "minimize_focus_hover.svg"
theme.titlebar_ontop_button_normal_inactive_hover = tip .. "ontop_normal_inactive_hover.svg"
theme.titlebar_ontop_button_focus_inactive_hover  = tip .. "ontop_focus_inactive_hover.svg"
theme.titlebar_ontop_button_normal_active_hover = tip .. "ontop_normal_active_hover.svg"
theme.titlebar_ontop_button_focus_active_hover  = tip .. "ontop_focus_active_hover.svg"
theme.titlebar_sticky_button_normal_inactive_hover = tip .. "sticky_normal_inactive_hover.svg"
theme.titlebar_sticky_button_focus_inactive_hover  = tip .. "sticky_focus_inactive_hover.svg"
theme.titlebar_sticky_button_normal_active_hover = tip .. "sticky_normal_active_hover.svg"
theme.titlebar_sticky_button_focus_active_hover  = tip .. "sticky_focus_active_hover.svg"
theme.titlebar_floating_button_normal_inactive_hover = tip .. "floating_normal_inactive_hover.svg"
theme.titlebar_floating_button_focus_inactive_hover  = tip .. "floating_focus_inactive_hover.svg"
theme.titlebar_floating_button_normal_active_hover = tip .. "floating_normal_active_hover.svg"
theme.titlebar_floating_button_focus_active_hover  = tip .. "floating_focus_active_hover.svg"
theme.titlebar_maximized_button_normal_inactive_hover = tip .. "maximized_normal_inactive_hover.svg"
theme.titlebar_maximized_button_focus_inactive_hover  = tip .. "maximized_focus_inactive_hover.svg"
theme.titlebar_maximized_button_normal_active_hover = tip .. "maximized_normal_active_hover.svg"
theme.titlebar_maximized_button_focus_active_hover  = tip .. "maximized_focus_active_hover.svg"

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

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

theme.wallpaper = '/home/ciugamenn/images/21_9_wallpapers/Swe2Jap.png'
-- theme.wallpaper = '/home/ciugamenn/images/21_9_wallpapers/y1ycMG2.jpg'
-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "/usr/share/icons/Paper"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
