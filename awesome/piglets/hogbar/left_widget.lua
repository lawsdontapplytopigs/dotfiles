local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

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

local make_left_widget = function(screen)
    local s = screen

    -- local mytaglist = awful.widget.taglist({
        -- screen  = s,
        -- filter  = awful.widget.taglist.filter.all,
        -- buttons = taglist_buttons,
        -- layout = { layout = wibox.layout.fixed.horizontal,},
        -- widget_template = {
            -- layout = wibox.layout.fixed.horizontal,
            -- id = "background_role",
            -- widget = wibox.container.background,
            -- bg = '#8800ff',
            -- {
                -- layout = wibox.layout.fixed.horizontal,
                -- id = "index_role",
                -- widget = wibox.widget.textbox,
            -- },
        -- },
    -- })

    local mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        style   = { 
            shape = gears.shape.rectangle, 
            bg_focus = '#ffd143',
            -- fg_empty = '#b48800',
            fg_occupied = '#b48800',
            fg_focus = '#111111',
        },
        layout   = { layout  = wibox.layout.fixed.horizontal, },
        widget_template = {
            id     = 'background_role',
            widget = wibox.container.background,
            forced_width = 40,
            {
                layout = wibox.layout.flex.horizontal,
                {
                    widget = wibox.container.place,
                    {
                        id     = 'text_role',
                        font = "Roboto Bold 13",
                        widget = wibox.widget.textbox,
                    },
                }
            },

            -- Add support for hover colors and an index label
            create_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:get_children_by_id('text_role')[1].markup = '<b> '..index..' </b>'
                self:connect_signal('mouse::enter', function()
                    if self.bg ~= '#00000000' then
                        self.backup_bg     = '#00000000'
                        self.backup_fg     = '#ffffffff'
                    end
                    self.bg = '#ffd143'
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
                self:get_children_by_id('text_role')[1].markup = '<b> '..index..' </b>'
            end,
        },
        buttons = taglist_buttons
    }
    return mytaglist

end

return make_left_widget
