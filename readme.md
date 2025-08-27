local uv = vim.loop

-- Настройки
local opts = {
enabled = true,
timeout = 1000,
events = { "FocusLost", "BufLeave" },
exclude_filetypes = { "gitcommit", "gitrebase", "fugitive", "git", "toggleterm", "neo-tree", "TelescopePrompt" },
exclude_buftypes = { "terminal", "prompt" },
silent = true,
}

local timer = nil
local enabled = opts.enabled

local function is*excluded(bufnr)
bufnr = bufnr or vim.api.nvim_get_current_buf()
local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
for *, v in ipairs(opts.exclude*filetypes) do
if v == ft then return true end
end
local bt = vim.api.nvim_buf_get_option(bufnr, "buftype")
for *, v in ipairs(opts.exclude_buftypes) do
if v == bt then return true end
end
return false
end

local function safe_save(bufnr)
if not bufnr or bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
if not vim.api.nvim_buf_is_loaded(bufnr) then return end
if is_excluded(bufnr) then return end

local mod = vim.api.nvim_buf_get_option(bufnr, "modified")
local ro = vim.api.nvim_buf_get_option(bufnr, "readonly")
local nomodifiable = not vim.api.nvim_buf_get_option(bufnr, "modifiable")

if not mod or ro or nomodifiable then return end
local cmd = opts.silent and "silent noautocmd write" or "noautocmd write"
pcall(vim.cmd, cmd)
end

local function schedule_save_after_delay(delay, bufnr)
if timer then
pcall(function()
timer:stop()
timer:close()
end)
timer = nil
end

timer = uv.new_timer()
timer:start(delay, 0, vim.schedule_wrap(function()
safe_save(bufnr)
pcall(function()
timer:stop()
timer:close()
end)
timer = nil
end))
end

-- обработчики событий
vim.api.nvim_create_autocmd("InsertLeave", {
group = vim.api.nvim_create_augroup("AutoSaveGroup", { clear = false }),
callback = function()
if enabled then schedule_save_after_delay(opts.timeout, vim.api.nvim_get_current_buf()) end
end,
desc = "AutoSave: save after leaving insert mode (delayed)",
})

vim.api.nvim_create_autocmd(opts.events, {
group = vim.api.nvim_create_augroup("AutoSaveGroup", { clear = false }),
callback = function()
if enabled then safe_save(vim.api.nvim_get_current_buf()) end
end,
desc = "AutoSave: immediate save on focus lost or buffer leave",
})

-- команды управления
vim.api.nvim_create_user_command("AutoSaveToggle", function() enabled = not enabled end, { desc = "Toggle AutoSave" })
vim.api.nvim_create_user_command("AutoSaveEnable", function() enabled = true end, { desc = "Enable AutoSave" })
vim.api.nvim_create_user_command("AutoSaveDisable", function() enabled = false end, { desc = "Disable AutoSave" })
