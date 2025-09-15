-- Linea temporal para desaarrollo local
vim.opt.rtp:append '/home/cuji/repos/sql_runner'
---------------------------------

local P = require 'psql_runner.parser'
local M = {}

---@class Config
---@field db_url string|nil
---@field file_path string|nil

--- @class SetupOpts
--- @field [1] string|nil database url
--- Global config
--- @type Config
M.config = {
    db_url = nil,
    file_path = nil,
}

function M:is_valid_config()
    if self.config.db_url == nil then return false end
    -- others validations like regexs
    return true
end

--- Changes the db connection string to posgresql
function M:change_db(db)
    if type(db) ~= 'string' or db == '' then return false end
    self.config.db_url = db
    return true
end

function M:run_selected_sql()
    -- VALIDATIONS
    if M:is_valid_config() == false then
        vim.notify 'Invalid config or incomplete'
        return
    end

    -- PARSING
    local query = P.parse_query_from_selection()
    if query == nil then vim.notify('No selected text to run', 1) end
    -- COMMAND
    local cmd = { 'psql', self.config.db_url, '-c', query }
    local output = vim.fn.systemlist(cmd)
    -- BUFFER
    vim.cmd 'new'
    vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
end

--- @param opts SetupOpts
--- @return nil
M.setup = function(opts)
    if type(opts) ~= 'table' then opts = {} end

    M.config = vim.tbl_extend('force', M.config, opts)

    -- create commands for
    -- change dtb url
    -- run sql
    -- run selected text as sql
    -- List queries run
end

M.run_sql = function() end

return M
