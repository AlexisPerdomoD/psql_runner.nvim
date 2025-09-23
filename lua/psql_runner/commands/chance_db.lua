local WM = require 'psql_runner.window'

local TITLE = 'Write singleline database conexion string bellow:'
local PROMPT = 'DB='

---@param plugin Plugin
local function chance_db_command(plugin)
    --BUFFER/WINDOW CREATION
    local win_idx, buf_idx = WM.create_prompt { title = TITLE, prompt = PROMPT, width = 80, height = 1 }

    --SET HOOKS
    local end_process_cb = function()
        vim.api.nvim_win_close(win_idx, true)
        vim.api.nvim_buf_delete(buf_idx, { force = true })
    end

    vim.fn.prompt_setcallback(buf_idx, function(connection_string)
        local success = plugin:change_db(connection_string)
        local notify_message
        if success then
            notify_message = 'Connection db settled'
        else
            notify_message = 'Invalid database conexion string provided'
        end

        vim.notify(notify_message)
        end_process_cb()
    end)

    vim.fn.prompt_setinterrupt(buf_idx, end_process_cb)

    vim.keymap.set({ 'i', 'n' }, '<C-x>', end_process_cb, { buffer = buf_idx })
    vim.cmd 'startinsert'
end

return chance_db_command
