local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local utils = require("utils")
local naughty = require("naughty")

-- beautiful.taglist_fg_focus
-- beautiful.taglist_bg_focus
-- beautiful.taglist_fg_urgent
-- beautiful.taglist_bg_urgent
-- beautiful.taglist_bg_occupied
-- beautiful.taglist_fg_occupied
-- beautiful.taglist_bg_empty
-- beautiful.taglist_fg_empty
-- beautiful.taglist_bg_volatile
-- beautiful.taglist_fg_volatile
-- beautiful.taglist_squares_sel
-- beautiful.taglist_squares_unsel
-- beautiful.taglist_squares_sel_empty
-- beautiful.taglist_squares_unsel_empty
-- beautiful.taglist_squares_resize
-- beautiful.taglist_disable_icon
-- beautiful.taglist_font
-- beautiful.taglist_spacing
-- beautiful.taglist_shape
-- beautiful.taglist_shape_border_width
-- beautiful.taglist_shape_border_color
-- beautiful.taglist_shape_empty
-- beautiful.taglist_shape_border_width_empty
-- beautiful.taglist_shape_border_color_empty
-- beautiful.taglist_shape_focus
-- beautiful.taglist_shape_border_width_focus
-- beautiful.taglist_shape_border_color_focus
-- beautiful.taglist_shape_urgent
-- beautiful.taglist_shape_border_width_urgent
-- beautiful.taglist_shape_border_color_urgent
-- beautiful.taglist_shape_volatile
-- beautiful.taglist_shape_border_width_volatile
-- beautiful.taglist_shape_border_color_volatile

local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, 
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, 
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local make_left_widget = function( args )

    local taglist_width = args.taglist_width
    local s = args.screen
    local mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        style   = { 
            -- bg_focus = '#1a1823',
            bg_focus = '#daeeff',
            fg_focus = '#003040',
            fg_empty = '#cceeff',
            -- fg_occupied = '#120020',
            -- fg_occupied = '#2880c8',
            fg_occupied = '#30efb3',
            shape_border_width = 0,
            -- shape_border_color = 
            -- shape_empty
            -- shape_border_width_empty = 
            -- shape_border_color_empty
            -- shape_focus
            shape_border_width_focus = 1,
            shape_border_color_focus = "#204058",
            shape_urgent
            -- shape_border_width_urgent = 
            -- shape_border_color_urgent
            -- shape_volatile
            -- shape_border_width_volatile
            -- shape_border_color_volatile
        },
        layout = { layout = wibox.layout.flex.horizontal, },
        widget_template = {
            id = "my_bg",
            widget = wibox.container.background,
            shape  = utils.rrect(6),
            forced_width = 40,
            {
                id = 'background_role',
                widget = wibox.container.background,
                forced_width = taglist_width / 9,
                bg = '#1a1823',
                {
                    widget = wibox.container.place,
                    {
                        id = "text_role",
                        font = "Roboto Bold 12",
                        widget = wibox.widget.textbox,
                    }
                },
            },
            -- Add support for hover colors and an index label
            create_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:get_children_by_id("text_role")[1].markup = '<b> '..index..' </b>'
                self:connect_signal('mouse::enter', function()
                    if self.bg ~= '#00000000' then
                        self.backup_bg     = '#00000000'
                        self.backup_fg     = '#ffffffff'
                    end
                    self.bg = '#40cfd8'
                    self.fg = '#111111'
                end)
                self:connect_signal('mouse::leave', function()
                    if self.backup_bg then 
                        self.bg = self.backup_bg
                        self.fg = self.backup_fg
                    end
                end)
            end,
            update_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:get_children_by_id("text_role")[1].markup = '<b> '..index..' </b>'
            end,
        },
        buttons = taglist_buttons
    }
    return mytaglist
end

return make_left_widget
