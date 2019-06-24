
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local utils = require("utils")
local dpi = beautiful.xresources.apply_dpi
-- the awesome wm prompt has a few bugs so we'll use a custom one
local pig_prompt = require("brickware.pigprompt")

local piggyprompt = {}

local function setup_searchbar( args )

    local searchbox_height = args.searchbox_height
    local searchbox_width = args.searchbox_width
    local padding = args.padding
    local hacked_padding = dpi(16) -- this shouldn't be happening

    local searchbar = {
        layout = wibox.layout.manual,
        {
            widget = wibox.container.background,
            point = { x = padding, y = padding },
            forced_width = searchbox_width - padding - padding,
            forced_height = searchbox_height - padding - padding,
            shape = gears.shape.rounded_bar,
            -- shape_border_width = dpi(2),
            -- shape_border_color = "#201e2a",
            -- bg = "#2288ff77",
            {
                layout = wibox.layout.manual,
                {
                    widget = wibox.container.background,
                    -- bg = "#333388",
                    point = { x = hacked_padding , y = 0 },
                    forced_width = searchbox_width - padding - padding - searchbox_height - hacked_padding,
                    forced_height = searchbox_height - padding - padding,
                    {
                        id = "searchbox",
                        widget = wibox.widget.textbox,
                        font = "TTCommons Medium 15",
                    },
                },
                {
                    widget = wibox.container.background,
                    -- bg = "#ffc855",
                    point = { x = searchbox_width - padding - padding - searchbox_height, y = 0 },
                    forced_width = searchbox_height,
                    forced_height = searchbox_height - padding - padding,
                    {
                        widget = wibox.container.place,
                        halign = "right",
                        {
                            widget = wibox.container.background,
                            -- bg = "#dd3346",
                            shape = gears.shape.circle,
                            shape_border_width = dpi(2),
                            -- shape_border_color = "#a2d722",
                            {
                                widget = wibox.container.margin,
                                margins = 16,
                                {
                                    widget = wibox.widget.imagebox,
                                    image = beautiful.piggyprompt.play_black,
                                },
                            },
                        },
                    },
                },
            },
        },
    }
    return searchbar
end

local function setup_rows( args )

    local num_rows = args.num_rows

    local default_bg = "#ffffff"
    local row_template = {
        id = "rows_bgs",
        widget = wibox.container.background,
        bg = default_bg,
        backup_bg = default_bg,
        fg = "#ffffff",
        {
            widget = wibox.container.margin,
            left = dpi(20),
            right = dpi(20),
            {
                widget = wibox.container.background,
                bg = "#00000000",
                fg = "#000000",
                {
                    layout = wibox.layout.fixed.horizontal,
                    {
                        widget = wibox.container.place,
                        valign = "center",
                        halign = "center",
                        {
                            id = "play",
                            forced_width = dpi(12),
                            forced_height = dpi(12),
                            widget = wibox.widget.imagebox,
                            image = beautiful.piggyprompt.play_black,
                        },
                    },
                    {
                        widget = wibox.container.margin,
                        left = dpi(6),
                        {
                            id = "rows_texts",
                            widget = wibox.widget.textbox,
                            text = "uhhh",
                        },
                    },
                },
            },
        },
    }

    local rows = {
        id = "rows_container",
        widget = wibox.layout.flex.vertical,
        sel = 1,
        selectable = num_rows,
        max_selectable_rows = num_rows, -- this shouldn't be changed at all by anything else
    }

    for i=1, num_rows do
        table.insert(rows, row_template)
    end

    return rows

end

local function make_foundation( args )

    local width = args.width or dpi(400) -- set some reasonable defaults
    local height = args.height or dpi(600)

    local x_crd = awful.screen.focused().geometry.width / 2 - width / 2
    local y_crd = awful.screen.focused().geometry.height / 2 - height / 2

    local foundation = wibox({
        x = x_crd,
        y = y_crd,
        width = width,
        height = height,
        bg = "#00000000",
        screen = awful.screen.focused(),
        type = "dock", -- let compton know we don't want shadows
        visible = false,
        ontop = true,
    })
    return foundation
end

local function setup_entire_widget()

    local widget_width = dpi(360)
    local widget_height = dpi(520)
    local wid = make_foundation({
        width = widget_width,
        height = widget_height,
    })
    local top_half_height = dpi(80)

    wid:setup({
        widget = wibox.container.background,
        bg = "#ffffff",
        shape = utils.rrect(30),
        {
            widget = wibox.layout.manual,
            {
                -- bg = "#c8b0ff", -- will potentially use
                -- bg = "#cc88bb",
                point = { x = 0, y = 0},
                forced_height = top_half_height,
                forced_width = widget_width,
                widget = wibox.container.background,
                -- bg = "#100422",
                bg = "#ffffff",
                fg = "#100422",
                    setup_searchbar({ 
                        searchbox_width = widget_width,
                        searchbox_height = top_half_height,
                        padding = dpi(10),
                    }),
            },
            {
                point = { x = 0, y = top_half_height },
                forced_width = widget_width,
                forced_height = widget_height - top_half_height,
                widget = wibox.container.background,
                -- bg = "#22083d",
                bg = "#ffffff",
                fg = "#000000",
                    -- doesn't look the cleanest, but it's correct
                    setup_rows({ num_rows = 8 }),
            },
        }
    })
    return wid
end

local function get_all_commands_in_PATH ()
    local program_paths = {}
    -- get all the paths in the `PATH` environment variable
    for val in string.gmatch(os.getenv("PATH"), "[^:]*") do
        table.insert(program_paths, val)
    end
    -- now recursively find all the executable names and put them in `executables`
    local executables = {}

    -- let's make sure we've met the `luafilesystem` dependency
    if type(utils.get_files_recursively) == "function" then 
        for k, path in pairs(program_paths) do
            utils.get_files_recursively(executables, path)
        end
    else
        naughty.notify({text = tostring("MISSING `luafilesystem` DEPENDENCY")})
    end
    return executables
end

-- TODO: refactor this function. It's pretty ugly.
local function organize_commands( prompt_text, executables )
    local raw_organized_matches = {}

    -- we add as many tables as there are conditions to match the commands
    for i=1, 3 do
        table.insert(raw_organized_matches, {})
    end

    -- get all executables and their ranking in the tables above
    for _, cmd in pairs(executables) do
        
        if string.sub(cmd, 1, #cmd) == prompt_text then
            table.insert(raw_organized_matches[1], cmd)

        elseif string.sub(cmd, 1, #prompt_text) == prompt_text then
            table.insert(raw_organized_matches[2], cmd)

        elseif string.match(string.sub(cmd, #prompt_text, #cmd), prompt_text) then
            table.insert(raw_organized_matches[3], cmd)
        end
    end

    local final_organized_matches = {}
    for _, tabl in pairs(raw_organized_matches) do
        local uniq = {}
        -- let's put them in a hash table to take out the duplicates
        for _, v in pairs(tabl) do
            uniq[tostring(v)] = true
        end

        -- now let's put them back together. we need to do this for sorting
        local indexed_commands = {}
        for val, _ in pairs(uniq) do
            table.insert(indexed_commands, val)
        end
        table.sort(indexed_commands)

        -- and now let's just add all that's in 
        -- the `back_together` table into the final table
        for _, val in pairs(indexed_commands) do
            table.insert(final_organized_matches, val)
        end
    end

    return final_organized_matches
end

local whole_widget = setup_entire_widget()
function piggyprompt.launch()

    local r_container = whole_widget:get_children_by_id("rows_container")[1]
    local r_bgs = whole_widget:get_children_by_id("rows_bgs")
    local r_texts = whole_widget:get_children_by_id("rows_texts")
    local r_icons = whole_widget:get_children_by_id("play")
    
    -- local row-selecting function
    -- NOTE: not meant to be taken outside of this scope
    local function own_select_row( n )
        -- not efficient, but easy to write and understand
        for i=1, r_container.max_selectable_rows do 
            r_bgs[i].bg = r_bgs[i].backup_bg
            r_icons[i].visible = false
        end
        if n == 0 then
            return
        end
        r_container.sel = n
        r_bgs[n].bg = "#ff3355"
        r_icons[n].visible = true
    end

    -- the pig_prompt.run function below accepts a function (that will only get called with 1 parameter)
    -- that does something once the text in the prompt changes. 
    -- We'll use that so that when you type in something, 
    -- the first row gets selected,
    -- and also the matching commands get reorganized
    local function hacked_organize_commands ( prompt_text )

        for i=1, r_container.max_selectable_rows do
            r_texts[i].text = ''
            r_icons[i].visible = false
        end

        local oc = organize_commands( prompt_text, get_all_commands_in_PATH() )
        if #oc < r_container.max_selectable_rows then
            r_container.selectable = #oc
        else 
            r_container.selectable = r_container.max_selectable_rows
        end

        own_select_row(1)
        if #oc < 1 then
            own_select_row(0)
            return
        end

        for i=1, r_container.selectable do
            r_texts[i].text = tostring(oc[i])
        end
    end

    local function select_prev()
        if r_container.sel == 1 then return end
        own_select_row(r_container.sel - 1)
    end
    local function select_next()
        if r_container.sel >= r_container.selectable then return end
        own_select_row( r_container.sel + 1 )
    end

    hacked_organize_commands("")
    own_select_row(1) -- when you open the prompt, the selected row should by default be "1"
    whole_widget.visible = true
    pig_prompt.run({
        font = "TTCommons Medium 14",
        textbox = whole_widget:get_children_by_id("searchbox")[1],
        prompt = "<b>Run: </b>",
        changed_callback = hacked_organize_commands,
        done_callback = function() whole_widget.visible = false end,
        hooks = {
            {{  }, "Escape", function(cmd)
                return nil, true
            end},
            {{  }, "Return", function(cmd)
                awful.spawn( r_texts[r_container.sel].text )
                return nil, true
            end,},
            {{  }, "Up", function(cmd)
                select_prev()
                return cmd, false
            end},
            {{  }, "Down", function(command)
                select_next()
                return cmd, false
            end},
        },
    })

end

return piggyprompt
