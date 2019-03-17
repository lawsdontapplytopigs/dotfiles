
function modalbind.init()
	local modewibox = wibox({
			ontop=true,
			visible=false,
			x=0,
			y=0,
			width=1,
			height=1,
			opacity=defaults.opacity,
			bg=beautiful.modebox_bg or
				beautiful.bg_normal,
			fg=beautiful.modebox_fg or
				beautiful.fg_normal,
			shape=gears.shape.round_rect,
			type="toolbar"
	})

	modewibox:setup({
			{
				id="text",
				align="left",
				font=beautiful.modalbind_font or
					beautiful.monospaced_font or
					beautiful.fontface or
					beautiful.font,
				widget=wibox.widget.textbox
			},
			id="margin",
			margins=beautiful.modebox_border_width or
				beautiful.border_width,
			color=beautiful.modebox_border or
				beautiful.border_focus,
			layout=wibox.container.margin,
	})

	awful.screen.connect_for_each_screen(function(s)
			s.modewibox = modewibox
	end)
end


