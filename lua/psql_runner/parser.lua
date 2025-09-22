---@class Parser
local P = {}

P.parse_query_from_selection = function()
    local start_pos = vim.fn.getpos "'<"
    local end_pos = vim.fn.getpos "'>"

    if #start_pos < 2 or #end_pos < 2 then
        return nil
    end

    local lines = vim.fn.getline(start_pos[2], end_pos[2])
    if type(lines) == 'string' then
        lines = table.insert({}, lines)
    end

    if #lines == 0 then
        return nil
    end

    lines[1] = string.sub(lines[1], start_pos[3], -1)
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])

    local query = table.concat(lines, '\n')
    if query == '' then
        return nil
    end
    return query
end

return P
