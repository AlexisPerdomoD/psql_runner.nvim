local api = vim.api
local fn = vim.fn
local cmd = vim.cmd
local keybinding = vim.keymap
local notify = vim.notify

local PROMPT = 'Write singleline database conexion string bellow:'
---@param prompt string
local function create_prompt(prompt)
    if type(prompt) ~= 'string' then
        error '[create_prompt]:Invalid prompt provided'
    end

    local buf_idx = api.nvim_create_buf(false, true)
    local buf = vim.bo[buf_idx]
    buf.buftype = 'prompt'
    -- Esto funcionara correctamente en la mayoria de los casos
    -- Buscar casos donde pueda ser buggi confiar en que la primera ui es la principal o no
    local ui = api.nvim_list_uis()[1]

    local width = math.min(math.floor(ui.width * 0.8), 80)
    local height = 1
    local row = math.floor((ui.height - height) / 2)
    local col = math.floor((ui.width - width) / 2)

    local win_idx = api.nvim_open_win(buf_idx, true, {
        relative = 'editor',
        border = 'rounded',
        style = 'minimal',
        row = row,
        col = col,
        height = height,
        width = width,
        title = prompt,
        title_pos = 'center',
    })

    fn.prompt_setprompt(buf_idx, 'db=')

    return win_idx, buf_idx
end

---@param plugin Plugin
local function chance_db_command(plugin)
    --BUFFER CREATION
    local win_idx, buf_idx = create_prompt(PROMPT)

    --WINDOW CREATION

    --SET HOOKS
    local end_process_cb = function()
        api.nvim_win_close(win_idx, true)
        api.nvim_buf_delete(buf_idx, { force = true })
    end

    fn.prompt_setcallback(buf_idx, function(connection_string)
        local success = plugin:change_db(connection_string)
        local notify_message
        if success then
            notify_message = 'Connection db settled'
        else
            notify_message = 'Invalid database conexion string provided'
        end

        notify(notify_message)
        end_process_cb()
    end)

    fn.prompt_setinterrupt(buf_idx, end_process_cb)

    keybinding.set({ 'i', 'n' }, '<C-x>', end_process_cb, { buffer = buf_idx })
    cmd 'startinsert'
end

return chance_db_command
