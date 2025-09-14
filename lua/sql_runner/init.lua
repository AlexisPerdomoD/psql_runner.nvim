local parser = require 'sql_runner.parser'
local M = {}

M.config = {
    db_url = nil,
    file_path = nil,
}

M.setup = function(opts)
    if type(opts) ~= 'table' then opts = {} end

    M.config = vim.tbl_extend('force', M.config, opts)

    -- create commands for
    -- change dtb url
    -- run sql
    -- run selected text as sql
    -- List queries run
end

M.run_selected_sql = function()
    -- validations
    if M.config.db_url == nil then
        vim.notify 'No database url provided'
        return
    end

    -- parsing
    local query = parser.parse_query_from_selection()
    if query == nil then vim.notify('No selected text to run', 1) end
    -- commands
    local cmd = { 'psql', M.config.db_url, '-c', query }
    local output = vim.fn.systemlist(cmd)
    vim.cmd 'new'
    vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
end

M.run_sql = function() end

M.change_db = function() end

return M
