local chance_db_command = require 'psql_runner.commands.chance_db'
---@class Register
local R = {}
---@param plugin Plugin
function R.register_commands(plugin)
    local create_command = vim.api.nvim_create_user_command

    create_command('PsqlChangeDB', function()
        chance_db_command(plugin)
    end, { desc = 'Change your database connection string' })
end

return R
