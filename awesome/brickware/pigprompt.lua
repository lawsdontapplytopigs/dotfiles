
-- backwards compatibility stuff
local table = table
local math = math
local ipairs = ipairs
local pcall = pcall
local capi = { selection = selection }
local unpack = unpack or table.unpack -- luacheck: globals unpack (compatibility with Lua 5.1)

-- get environment we need
local keygrabber = require("awful.keygrabber")
local beautiful = require("beautiful")
local akey = require("awful.key")
local gdebug = require('gears.debug')
local gtable = require("gears.table")
local gcolor = require("gears.color")
local gstring = require("gears.string")

local prompt = {}

local function itera (inc,a, i)
    i = i + inc
    local v = a[i]
    if v then return i,v end
end

local function is_word_char(c)
    if string.find("[{[(,.:;_-+=@/ ]", c) then
        return false
    else
        return true
    end
end

local function cword_start(s, pos)
    local i = pos
    if i > 1 then
        i = i - 1
    end
    while i >= 1 and not is_word_char(s:sub(i, i)) do 
        i = i - 1
    end
    while i >= 1 and is_word_char(s:sub(i, i)) do 
        i = i - 1
    end
    if i <= #s then
        i = i + 1
    end
    return i
end

local function cword_end(s, pos)
    local i = pos
    while i <= #s and not is_word_char(s:sub(i, i)) do
        i = i + 1
    end
    while i <= #s and  is_word_char(s:sub(i, i)) do
        i = i + 1
    end
    return i
end

--- Draw the prompt text with a cursor.
-- @tparam table args The table of arguments.
-- @field text The text.
-- @field font The font.
-- @field prompt The text prefix.
-- @field text_color The text color.
-- @field cursor_color The cursor color.
-- @field cursor_pos The cursor position.
-- @field cursor_ul The cursor underline style.
-- @field selectall If true cursor is rendered on the entire text.
local function prompt_text_with_cursor(args)
    local char, spacer, text_start, text_end, ret
    local text = args.text or ""
    local _prompt = args.prompt or ""
    local underline = args.cursor_ul or "none"

    if args.selectall then
        if #text == 0 then char = " " else char = gstring.xml_escape(text) end
        spacer = " "
        text_start = ""
        text_end = ""
    elseif #text < args.cursor_pos then
        char = " "
        spacer = ""
        text_start = gstring.xml_escape(text)
        text_end = ""
    else
        char = gstring.xml_escape(text:sub(args.cursor_pos, args.cursor_pos))
        spacer = " "
        text_start = gstring.xml_escape(text:sub(1, args.cursor_pos - 1))
        text_end = gstring.xml_escape(text:sub(args.cursor_pos + 1))
    end

    local cursor_color = gcolor.ensure_pango_color(args.cursor_color)
    local text_color = gcolor.ensure_pango_color(args.text_color)

    if args.highlighter then
        text_start, text_end = args.highlighter(text_start, text_end)
    end

    ret = _prompt .. text_start .. "<span background=\"" .. cursor_color ..
        "\" foreground=\"" .. text_color .. "\" underline=\"" .. underline ..
        "\">" .. char .. "</span>" .. text_end .. spacer
    return ret
end

--- The callback function to call with command as argument when finished.
-- @usage local function my_exe_cb(command)
--    -- do something
-- end
-- @callback exe_callback
-- @tparam string command The command (as entered).

--- The callback function to get completions.
-- @usage local function my_completion_cb(command_before_comp, cur_pos_before_comp, ncomp)
--    return command_before_comp.."foo", cur_pos_before_comp+3, 1
-- end
--
-- @callback completion_callback
-- @tparam string command_before_comp The current command.
-- @tparam number cur_pos_before_comp The current cursor position.
-- @tparam number ncomp The number of the currently completed element.
-- @treturn string command
-- @treturn number cur_pos
-- @treturn number matches

--- The callback function to always call without arguments, regardless of
-- whether the prompt was cancelled.
-- @usage local function my_done_cb()
--    -- do something
-- end
-- @callback done_callback

---  The callback function to call with command as argument when a command was
-- changed.
-- @usage local function my_changed_cb(command)
--    -- do something
-- end
-- @callback changed_callback
-- @tparam string command The current command.

--- The callback function to call with mod table, key and command as arguments
-- when a key was pressed.
-- @usage local function my_keypressed_cb(mod, key, command)
--    -- do something
-- end
-- @callback keypressed_callback
-- @tparam table mod The current modifiers (like "Control" or "Shift").
-- @tparam string key The key name.
-- @tparam string command The current command.

--- The callback function to call with mod table, key and command as arguments
-- when a key was released.
-- @usage local function my_keyreleased_cb(mod, key, command)
--    -- do something
-- end
-- @callback keyreleased_callback
-- @tparam table mod The current modifiers (like "Control" or "Shift").
-- @tparam string key The key name.
-- @tparam string command The current command.

--- A function to add syntax highlighting to the command.
-- @usage local function my_highlighter(before_cursor, after_cursor)
--    -- do something
--    return before_cursor, after_cursor
-- end
-- @callback highlighter
-- @tparam string before_cursor
-- @tparam string after_cursor

--- A callback when a key combination is triggered.
-- This callback can return many things:
--
-- * a modified command
-- * `true` If the command is successful (then it won't exit)
-- * nothing or `nil` to execute the `exe_callback` and `done_callback` and exit
--
-- An optional second return value controls if the prompt should exit or simply
-- update the command (from the first return value) and keep going. The default
-- is to execute the `exe_callback` and `done_callback` before exiting.
--
-- @usage local function my_hook(command)
--    return command.."foo", false
-- end
--
-- @callback hook
-- @tparam string command The current command.

--- Run a prompt in a box.
--
-- @tparam[opt={}] table args A table with optional arguments
-- @tparam[opt] gears.color args.fg_cursor
-- @tparam[opt] gears.color args.bg_cursor
-- @tparam[opt] gears.color args.ul_cursor
-- @tparam[opt] widget args.prompt
-- @tparam[opt] string args.text
-- @tparam[opt] boolean args.selectall
-- @tparam[opt] string args.font
-- @tparam[opt] boolean args.autoexec
-- @tparam widget args.textbox The textbox to use for the prompt.
-- @tparam[opt] function args.highlighter A function to add syntax highlighting to
--  the command.
-- @tparam function args.exe_callback The callback function to call with command as argument
-- when finished.
-- @tparam function args.completion_callback The callback function to call to get completion.
-- @tparam[opt] string args.history_path File path where the history should be
-- saved, set nil to disable history
-- @tparam[opt] function args.history_max Set the maximum entries in history
-- file, 50 by default
-- @tparam[opt] function args.done_callback The callback function to always call
-- without arguments, regardless of whether the prompt was cancelled.
-- @tparam[opt] function args.changed_callback The callback function to call
-- with command as argument when a command was changed.
-- @tparam[opt] function args.keypressed_callback The callback function to call
--   with mod table, key and command as arguments when a key was pressed.
-- @tparam[opt] function args.keyreleased_callback The callback function to call
--   with mod table, key and command as arguments when a key was pressed.
-- @tparam[opt] table args.hooks The "hooks" argument uses a syntax similar to
--   `awful.key`.  It will call a function for the matching modifiers + key.
--   It receives the command (widget text/input) as an argument.
--   If the callback returns a command, this will be passed to the
--   `exe_callback`, otherwise nothing gets executed by default, and the hook
--   needs to handle it.
--     hooks = {
--       -- Apply startup notification properties with Shift-Return.
--       {{"Shift"  }, "Return", function(command)
--         awful.screen.focused().mypromptbox:spawn_and_handle_error(
--           command, {floating=true})
--       end},
--       -- Override default behavior of "Return": launch commands prefixed
--       -- with ":" in a terminal.
--       {{}, "Return", function(command)
--         if command:sub(1,1) == ":" then
--           return terminal .. ' -e ' .. command:sub(2)
--         end
--         return command
--       end}
--     }


function prompt.run(args)
    local grabber
    local theme = beautiful.get()
    if not args then args = {} end
    local command = args.text or ""
    local prettyprompt = args.prompt or ""
    local inv_col = args.fg_cursor or theme.prompt_fg_cursor or theme.fg_focus or "black"
    local cur_col = args.bg_cursor or theme.prompt_bg_cursor or theme.bg_focus or "white"
    local cur_ul = args.ul_cursor
    local text = args.text or ""
    local font = args.font or theme.prompt_font or theme.font
    local selectall = args.selectall
    local highlighter = args.highlighter
    local hooks = {}
    local keypressed_callback = args.keypressed_callback 
    local changed_callback    = args.changed_callback
    local done_callback       = args.done_callback
    local completion_callback = args.completion_callback
    local exe_callback        = args.exe_callback
    local textbox             = args.textbox
    -- TODO: make it so you can use whatever widget and then 
    -- alter that widget through the `hooks` mechanism in this prompt
    local rows_array          = args.rows_array or nil
    -- by default, most of what we press changes the command. Since there are
    -- way fewer cases where the command doesn't change, we change this variable
    -- based on the conditionals that don't change the command
    local command_changed = true

    if not textbox then
        return
    end

    -- The cursor position
    local cur_pos = (selectall and 1) or text:wlen() + 1

    -- Build the hook map
    for _,v in ipairs(args.hooks or {}) do
        if #v == 3 then
            local _,key,callback = unpack(v)
            if type(callback) == "function" then
                hooks[key] = hooks[key] or {}
                hooks[key][#hooks[key]+1] = v
            else
                gdebug.print_warning("The hook's 3rd parameter has to be a function.")
            end
        else
            gdebug.print_warning("The hook has to have 3 parameters.")
        end
    end

    textbox:set_font(font)
    textbox:set_markup(prompt_text_with_cursor{
        text = text, text_color = inv_col, cursor_color = cur_col,
        cursor_pos = cur_pos, cursor_ul = cur_ul, selectall = selectall,
        prompt = prettyprompt, highlighter =  highlighter})

    local function exec(cb)
        textbox:set_markup("")
        keygrabber.stop(grabber)

        if cb then 
            cb(command)
        end
        if done_callback then done_callback() end
    end

    -- Update textbox
    local function update()
        textbox:set_font(font)
        textbox:set_markup(prompt_text_with_cursor{
                               text = command, text_color = inv_col, cursor_color = cur_col,
                               cursor_pos = cur_pos, cursor_ul = cur_ul, selectall = selectall,
                               prompt = prettyprompt, highlighter =  highlighter })
    end

    grabber = keygrabber.run(
    function (modifiers, key, event)
        -- Convert index array to hash table
        local mod = {}
        for _, v in ipairs(modifiers) do 
            mod[v] = true 
        end

        -- TODO: since there are only two events that will happen 
        -- ( "press" and release ) according to the awesome docs,
        -- change this `event ~= press` to `event == release` once I find
        -- out what exactly the `release` string name is
        if event ~= "press" then
            if args.keyreleased_callback then
                args.keyreleased_callback(mod, key, command)
            end
            return
        end

        -- Add the cases for mod keys (which don't change the command) so that
        -- `changed_callback` doesn't get called when they're pressed
        -- TODO: Look for a way to make these work regardless of the keyboard.
        -- Currently these things are hardcoded as keys, but they should just
        -- work based on how Xorg interprets them: `Mod1` for `Alt_L` and `Alt_R`
        -- and so on

        if key == "Control_L" or key == "Control_R" then
            command_changed = false
        elseif key == "Shift_L" or key == "Shift_R" then
            command_changed = false
        elseif key == "Caps_Lock" then
            command_changed = false
        elseif key == "Alt_L" or key == "Alt_R" then
            command_changed = false
        elseif key == "Super_R" or key == "Super_L" then
            command_changed = false
        elseif key == "Menu" then
            command_changed = false
        elseif key == "Num_Lock" then
            command_changed = false
        end
            
        -- Call the user specified callback. If it returns true as
        -- the first result then return from the function. Treat the
        -- second and third results as a new command and new prompt
        -- to be set (if provided)
        if keypressed_callback then
            local user_catched, new_command, new_prompt =
                keypressed_callback(mod, key, command)
            if new_command or new_prompt then
                if new_command then
                    command = new_command
                else
                    command_changed = false
                end
                if new_prompt then
                    prettyprompt = new_prompt
                end
                update()
            end
            if user_catched then
                if command_changed and changed_callback then
                    changed_callback(command)
                end
                return
            end
        end

        -- User defined cases
        -- I haven't yet checked out exactly what this is. TODO: See what this is
        -- and whether it makes sense to keep it anymore
        local filtered_modifiers = {}
        if hooks[key] then
            local current_command = command
            -- Remove caps and num lock
            for _, m in ipairs(modifiers) do
                if not gtable.hasitem(akey.ignore_modifiers, m) then
                    table.insert(filtered_modifiers, m)
                end
            end

            for _,v in ipairs(hooks[key]) do
                if #filtered_modifiers == #v[1] then
                    local match = true
                    for _,v2 in ipairs(v[1]) do
                        match = match and mod[v2]
                    end
                    if match then
                        local cb
                        local ret, quit = v[3](command)
                        -- local original_command = command

                        -- Support both a "simple" and a "complex" way to
                        -- control if the prompt should quit.
                        quit = quit == nil and (ret ~= true) or (quit~=false)

                        -- Allow the callback to change the command
                        command = (ret ~= true) and ret or command
                            
                        -- Quit by default, but allow it to be disabled
                        if ret and type(ret) ~= "boolean" then
                            cb = exe_callback
                            if not quit then
                                cur_pos = ret:wlen() + 1
                                update()
                            end
                        elseif quit then
                            -- No callback.
                            cb = function() end
                        end

                        -- Execute the callback
                        if cb then
                            exec(cb)
                        end

                        return
                    end
                end
            end
        end

        -- Get out cases
        if (mod.Control and (key == "c" or key == "g" or key == 'd'))
            or (not mod.Control and key == "Escape") then
            keygrabber.stop(grabber)
            textbox:set_markup("")
            -- TODO: take this line below out
            -- background_widget.visible = false -- MOVE
            if done_callback then done_callback() end
            return false
        elseif (mod.Control and (key == "j" or key == "m"))
            or (not mod.Control and key == "Return")
            or (not mod.Control and key == "KP_Enter") then
            exec(exe_callback)
            -- We already unregistered ourselves so we don't want to return
            -- true, otherwise we may unregister someone else.
            return
        end

        -- Control cases
        if mod.Control then
            selectall = nil

            if key == "a" then
                cur_pos = 1
                command_changed = false

            elseif key == "b" then
                if cur_pos > 1 then
                    cur_pos = cur_pos - 1
                end
                command_changed = false

            elseif key == "d" then
                if cur_pos <= #command then
                    command = command:sub(1, cur_pos - 1) .. command:sub(cur_pos + 1)
                else
                    command_changed = false
                end

            elseif key == "e" then
                cur_pos = #command + 1
                command_changed = false

            elseif key == "f" then
                if cur_pos <= #command then
                    cur_pos = cur_pos + 1
                end
                command_changed = false

            elseif key == "h" then
                if cur_pos > 1 then
                    command = command:sub(1, cur_pos - 2) .. command:sub(cur_pos)
                    cur_pos = cur_pos - 1
                else
                    command_changed = false
                end

            elseif key == "k" then
                if cor_pos < #command then
                    command = command:sub(1, cur_pos - 1)
                else
                    command_changed = false
                end

            elseif key == "u" then
                -- command only gets changed if the position is bigger than 1
                if cur_pos > 1 then
                    command = command:sub(cur_pos, #command)
                    cur_pos = 1
                else
                    command_changed = false
                end

            -- elseif key == "Up" then -- MOVE
                -- TODO: take this out entirely and use it through the `hooks` mechanism
                -- if the_rows.sel > 1 then
                    -- unset_selected_row(the_rows)
                    -- the_rows.sel = 1
                    -- redraw_rows(the_rows)
                -- end
                -- command_changed = false

            -- elseif key == "Down" then -- MOVE
                -- TODO: take this out entirely and use it through the `hooks` mechanism
                -- if the_rows.sel < the_rows.selectable_rows then
                    -- unset_selected_row(the_rows)
                    -- the_rows.sel = the_rows.selectable_rows
                    -- redraw_rows(the_rows)
                -- end
                -- command_changed = false

            -- PASTE FROM SELECTION WITH `ctrl + v`
            -- (also, this doesn't paste from the `CLIPBOARD` clipboard of Xorg
            -- I think it pastes stuff from `PRIMARY`
            -- TODO: use the up-coming support for `CLIPBOARD` once it gets introduced
            elseif key == 'v' then
                local selection = capi.selection()
                if selection then
                    -- Remove \n
                    local n = selection:find("\n")
                    if n then
                        selection = selection:sub(1, n - 1)
                    end
                    command = command:sub(1, cur_pos - 1) .. selection .. command:sub(cur_pos)
                    cur_pos = cur_pos + #selection
                else
                    -- if there's nothing in the clipboard, the command doesn't change
                    command_changed = false
                end

            elseif key == "w" or key == "BackSpace" then
                local wstart = 1
                local wend = 1
                local cword_start_pos = 1
                local cword_end_pos = 1
                while wend < cur_pos do
                    wend = command:find("[{[(,.:;_-+=@/ ]", wstart)
                    if not wend then wend = #command + 1 end
                    if cur_pos >= wstart and cur_pos <= wend + 1 then
                        cword_start_pos = wstart
                        cword_end_pos = cur_pos - 1
                        break
                    end
                    wstart = wend + 1
                end
                command = command:sub(1, cword_start_pos - 1) .. command:sub(cword_end_pos + 1)
                cur_pos = cword_start_pos
            end

        -- Mod1 and Mod3 cases
        elseif mod.Mod1 or mod.Mod3 then
            if key == "b" then
                cur_pos = cword_start(command, cur_pos)
                command_changed = false

            elseif key == "f" then
                cur_pos = cword_end(command, cur_pos)
                command_changed = false

            elseif key == "d" then
                command = command:sub(1, cur_pos - 1) .. command:sub(cword_end(command, cur_pos))

            elseif key == "BackSpace" then
                local wstart = cword_start(command, cur_pos)
                command = command:sub(1, wstart - 1) .. command:sub(cur_pos)
                cur_pos = wstart
            end

        -- Shift cases
        -- NOTE! If you try to get fancy and do 
        -- `if mod.Shift then; if key == "Insert" then`, 
        -- then using Shift + (anything else) doesn't work anymore. 
        -- So you won't be able to use capital letters and things like that
        -- PASTE FROM SELECTION (The "PRIMARY" clipboard of X)
        elseif mod.Shift and key == "Insert" then
            local selection = capi.selection()
            if selection then
                -- Remove \n
                local n = selection:find("\n")
                if n then
                    selection = selection:sub(1, n - 1)
                end
                command = command:sub(1, cur_pos - 1) .. selection .. command:sub(cur_pos)
                cur_pos = cur_pos + #selection
            end
            
        -- selecting the row above with Shift + Tab
        -- elseif mod.Shift and (key == "Tab" or key == "ISO_Left_Tab") then -- MOVE this
            -- TODO: make this work through the args at the top
            -- if the_rows.sel > 1 then
                -- unset_selected_row(the_rows)
                -- the_rows.sel = the_rows.sel - 1
                -- redraw_rows(the_rows)
            -- end
            -- command_changed = false

        -- Cases which don't require a modifier first
        else
            -- selecting the row below with Tab
            -- if key == "Tab" or key == "ISO_Left_Tab" then -- MOVE
                -- TODO: make this work through the args at the top
                -- if the_rows.sel < the_rows.selectable_rows then
                    -- unset_selected_row(the_rows)
                    -- the_rows.sel = the_rows.sel + 1
                    -- redraw_rows(the_rows)
                -- end
                -- command_changed = false
            -- end

            -- if completion_callback then
                -- if key == "Tab" or key == "ISO_Left_Tab" then
                    -- if key == "ISO_Left_Tab" or mod.Shift then
                        -- if ncomp == 1 then return end
                        -- if ncomp == 2 then
                            -- command = command_before_comp
                            -- textbox:set_font(font)
                            -- textbox:set_markup(prompt_text_with_cursor{
                                -- text = command_before_comp, text_color = inv_col, cursor_color = cur_col,
                                -- cursor_pos = cur_pos, cursor_ul = cur_ul, selectall = selectall,
                                -- prompt = prettyprompt })
                            -- cur_pos = cur_pos_before_comp
                            -- ncomp = 1
                            -- return
                        -- end
-- 
                        -- ncomp = ncomp - 2
                    -- elseif ncomp == 1 then
                        -- command_before_comp = command
                        -- cur_pos_before_comp = cur_pos
                    -- end
                    -- local matches
                    -- command, cur_pos, matches = completion_callback(command_before_comp, cur_pos_before_comp, ncomp)
                    -- ncomp = ncomp + 1
                    -- key = ""
                    -- -- execute if only one match found and autoexec flag set
                    -- if matches and #matches == 1 and args.autoexec then
                        -- exec(exe_callback)
                        -- return
                    -- end
                -- elseif key ~= "Shift_L" and key ~= "Shift_R" then
                    -- ncomp = 1
                -- end
            -- end

            if key == "Home" then
                cur_pos = 1
                command_changed = false

            elseif key == "End" then
                cur_pos = #command + 1
                command_changed = false

            elseif key == "BackSpace" then
                if cur_pos > 1 then
                    command = command:sub(1, cur_pos - 2) .. command:sub(cur_pos)
                    cur_pos = cur_pos - 1
                else
                    command_changed = false
                end

            elseif key == "Delete" then
                command = command:sub(1, cur_pos - 1) .. command:sub(cur_pos + 1)

            elseif key == "Left" then
                cur_pos = cur_pos - 1
                command_changed = false

            elseif key == "Right" then
                cur_pos = cur_pos + 1
                command_changed = false

            -- select the row above
            -- elseif key == "Up" then -- MOVE
                -- no need to update if the selected row is already the first one
                -- TODO: make this work through the args at the top
                -- if the_rows.sel > 1 then
                    -- unset_selected_row(the_rows)
                    -- the_rows.sel = the_rows.sel - 1
                    -- redraw_rows(the_rows)
                -- end
                -- command_changed = false

            -- select the row below
            -- elseif key == "Down" then -- MOVE
                -- no need to update if the selected row is already the last one
                -- TODO: make this work through the args at the top
                -- if the_rows.sel < the_rows.selectable_rows then
                    -- unset_selected_row(the_rows)
                    -- the_rows.sel = the_rows.sel + 1
                    -- redraw_rows(the_rows)
                -- end
                -- command_changed = false
                
            -- I have no clue what was supposed to happen here.
            -- handling multi-byte characters such as UTF-8 (maybe)???
            else
                -- wlen() is UTF-8 aware but #key is not,
                -- so check that we have one UTF-8 char but advance the cursor of # position
                if key:wlen() == 1 then
                    if selectall then command = "" end
                    command = command:sub(1, cur_pos - 1) .. key .. command:sub(cur_pos)
                    cur_pos = cur_pos + #key
                end
            end
            if cur_pos < 1 then
                cur_pos = 1
            elseif cur_pos > #command + 1 then
                cur_pos = #command + 1
            end
            selectall = nil
        end

        local success = pcall(update)
        while not success do
            -- * Nice one, Uli ;;;;;) *

            -- TODO UGLY HACK TODO
            -- Setting the text failed. Most likely reason is that the user
            -- entered a multibyte character and pressed backspace which only
            -- removed the last byte. Let's remove another byte.
            if cur_pos <= 1 then
                -- No text left?!
                break
            end

            command = command:sub(1, cur_pos - 2) .. command:sub(cur_pos)
            cur_pos = cur_pos - 1
            success = pcall(update)
        end

        if command_changed and changed_callback then
            changed_callback(command)
        end
        -- have to set it back to default for the next keypresses
        command_changed = true
    end)
end

return prompt
