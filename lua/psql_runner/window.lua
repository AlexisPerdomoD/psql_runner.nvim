---@class WindowManager
local WM = {}

---@class CreatePromptOpts
---@field title string
---@field prompt string
---@field height number
---@field width number
---@param opts CreatePromptOpts
---@return number, number
WM.create_prompt = function(opts)
    if type(opts.title) ~= 'string' then
        error '[create_prompt]:Invalid title provided'
    end

    if type(opts.prompt) ~= 'string' then
        error '[create_prompt]:Invalid prompt provided'
    end

    if type(opts.width) ~= 'number' or type(opts.height) ~= 'number' then
        error '[create_prompt]:Invalid dimensions provided'
    end

    local buf_idx = vim.api.nvim_create_buf(false, true)
    local buf = vim.bo[buf_idx]
    buf.buftype = 'prompt'
    -- Esto funcionara correctamente en la mayoria de los casos
    -- Buscar casos donde pueda ser buggi confiar en que la primera ui es la principal o no
    local ui = vim.api.nvim_list_uis()[1]

    local width = math.min(math.floor(ui.width * 0.8), opts.width)
    local height = math.min(math.floor(ui.height * 0.8), opts.height)
    local row = math.floor((ui.height - height) / 2)
    local col = math.floor((ui.width - width) / 2)
    local title = opts.title
    local prompt = opts.prompt

    local win_idx = vim.api.nvim_open_win(buf_idx, true, {
        relative = 'editor',
        border = 'rounded',
        style = 'minimal',
        row = row,
        col = col,
        height = height,
        width = width,
        title = title,
        title_pos = 'center',
    })

    vim.fn.prompt_setprompt(buf_idx, prompt)

    return win_idx, buf_idx
end

return WM
