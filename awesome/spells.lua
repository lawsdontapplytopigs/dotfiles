
-- simple library with helpful functions to debug my config of awesome

local spells = {}


local function match(str, other_string)
    -- we're only interested in strings where the second is shorter or equal to the first
    possible_match_limit = #str - #other_string + 1
    for i=1, possible_match_limit do 
        if string.sub(str, i, i) == string.sub(other_string, 1, 1) then
            if string.sub(str, i, i+#other_string -1) == other_string then
                -- print("found the pattern on line number "..tostring(line_nr))
                return true
            end
        end
    end
    return false
end

-- DESCRIPTION: the rough equivalent of python's `in` keyword
-- @param:string The string to search for
-- @param:thing The data type to search in. it can be a filepath, a table, or a string
-- @return:boolean whether or not it found the `string` in `thing`
function spells.exists_in(thing, string)

    if type(thing) == 'table' then
        for _, v in pairs(thing) do
            if v == string then
                return true
            end
        end
    end

    if type(thing) == 'string' then

        -- if we can open it, it's a file
        if io.open(thing) ~= nil then 
            line_nr = 1
            for line in io.lines(thing) do
                if match(line, string) then
                    return true
                end
                line_nr = line_nr + 1
            end
        end
        -- if it's not a file, it's a regular string
        elseif string.match(thing, string) ~= nil then
            return true
        end
    end

    return false
end

-- DESCRIPTION: treats two files as sets and returns the lines that are different
-- @param:file1 the first file to compare
-- @param:file2 the second file to compare
-- @return:table a table containing the lines that are different
function spells.file_difference(file1, file2)

    difference = {}
    for line in io.lines(file1) do
        if not spells.exists_in(file2, line) then
            table.insert(difference, line)
        end
    end

    for line in io.lines(file2) do
        if not spells.exists_in(file1, line) then
            table.insert(difference, line)
        end
    end

    print(table.concat(difference, '\n'))
    return difference
end

return spells

