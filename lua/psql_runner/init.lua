-- Linea temporal para desaarrollo local
vim.opt.rtp:append '/home/cuji/repos/sql_runner'
---------------------------------

local P = require 'psql_runner.parser'
local R = require 'psql_runner.register'

---@class Config
---@field db_url string|nil
---@field dir_url string|nil
---@field cmd string

---@class SetupOpts
---@field db_url string|nil database url
---@field dir_url string|nil dir url
---@field cmd string|nil command to use

---@class Plugin
local M = {}

---@type Config
M.config = {
    db_url = nil,
    dir_url = nil,
    cmd = 'psql',
}

function M:is_valid_config()
    if self.config.db_url == nil then
        return false
    end
    -- others validations
    return true
end

--- Changes the db connection string to posgresql
---@param db string
function M:change_db(db)
    if type(db) ~= 'string' or db == '' then
        return false
    end

    -- others validations like regexs
    self.config.db_url = db
    return true
end

function M:run_selected_sql()
    -- VALIDATIONS
    if M:is_valid_config() == false then
        vim.notify 'Invalid config or incomplete'
        return nil
    end

    -- PARSING
    local query = P.parse_query_from_selection()
    if query == nil then
        return nil
    end
    -- COMMAND
    local cmd = { self.config.cmd, self.config.db_url, '-c', query }

    local lines = vim.fn.systemlist(cmd)
    if #lines == 0 then
        return nil
    end
    return lines
end

--- @param opts SetupOpts
M.setup = function(opts)
    if type(opts) ~= 'table' then
        opts = {}
    end

    if type(opts.cmd) ~= 'string' and type(opts.cmd) ~= 'nil' then
        opts.cmd = 'psql'
    end

    M.config = vim.tbl_extend('force', M.config, opts)
    R.register_commands(M)
    -- create commands for
    -- change dtb url (done)
    -- run sql
    -- run selected text as sql
    -- List queries run
end

M.run_sql = function() end

M.setup {}
return M
