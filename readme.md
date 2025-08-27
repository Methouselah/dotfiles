-- lua/after/plugin/autosave.lua
-- Автосохранение: сохраняет при уходе из буфера/фокуса и через таймер после InsertLeave.
-- Помести этот файл в lua/after/plugin/ чтобы LazyVim его подхватил.

local uv = vim.loop

local M = {}

-- Настройки — поменяй при желании
local opts = {
enabled = true, -- автосохранение включено по умолчанию
timeout = 1000, -- ms, задержка после InsertLeave перед сохранением
events = { "FocusLost", "BufLeave" }, -- события для немедленного сохранения
exclude_filetypes = { "gitcommit", "gitrebase", "fugitive", "git", "toggleterm", "neo-tree", "TelescopePrompt" },
exclude_buftypes = { "terminal", "prompt" },
silent = true, -- использовать 'silent' при записи
}

-- внутренние переменные
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

if not mod then return end
if ro or nomodifiable then return end

-- Не сохраняем, если в командной строке или в спец.окне
local winid = vim.api.nvim_get_current_win()
if not winid or winid == 0 then return end

-- Выполняем запись: silent noautocmd write
local cmd = opts.silent and "silent noautocmd write" or "noautocmd write"
-- pcall на случай, если запись выдаст ошибку (например, права доступа)
local ok, \_ = pcall(vim.cmd, cmd)
if not ok then
-- ничего не делаем — не хотим ломать рабочий процесс
end
end

local function schedule_save_after_delay(delay, bufnr)
-- отменяем предыдущий таймер
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
-- закрыть и очистить таймер
pcall(function()
timer:stop()
timer:close()
end)
timer = nil
end))
end

-- обработчики событий
local function on_insert_leave()
if not enabled then return end
-- сохраняем через timeout (чтобы не мешать быстрому редактированию)
schedule_save_after_delay(opts.timeout, vim.api.nvim_get_current_buf())
end

local function on_focus_or_bufleave()
if not enabled then return end
safe_save(vim.api.nvim_get_current_buf())
end

-- команды управления
local function enable_autosave()
enabled = true
vim.notify("AutoSave: enabled", vim.log.levels.INFO)
end

local function disable_autosave()
enabled = false
-- если есть активный таймер — закрыть
if timer then
pcall(function()
timer:stop()
timer:close()
end)
timer = nil
end
vim.notify("AutoSave: disabled", vim.log.levels.WARN)
end

local function toggle_autosave()
if enabled then
disable_autosave()
else
enable_autosave()
end
end

-- регистрация autocmd'ов и команд
local function setup_autocmds()
-- InsertLeave -> таймерное сохранение
vim.api.nvim_create_autocmd("InsertLeave", {
group = vim.api.nvim_create_augroup("AutoSaveGroup", { clear = false }),
callback = on_insert_leave,
desc = "AutoSave: save after leaving insert mode (delayed)",
})

-- FocusLost + BufLeave -> немедленное сохранение
vim.api.nvim_create_autocmd(opts.events, {
group = vim.api.nvim_create_augroup("AutoSaveGroup", { clear = false }),
callback = on_focus_or_bufleave,
desc = "AutoSave: immediate save on focus lost or buffer leave",
})

-- Команды для управления
vim.api.nvim_create_user_command("AutoSaveToggle", function() toggle_autosave() end, { desc = "Toggle AutoSave" })
vim.api.nvim_create_user_command("AutoSaveEnable", function() enable_autosave() end, { desc = "Enable AutoSave" })
vim.api.nvim_create_user_command("AutoSaveDisable", function() disable_autosave() end, { desc = "Disable AutoSave" })
end

-- Инициализация (выполняется при загрузке файла)
setup_autocmds()

-- Возвращаем таблицу если захотите require() и менять options программно
M.enable = enable_autosave
M.disable = disable_autosave
M.toggle = toggle_autosave
M.\_is_enabled = function() return enabled end
M.opts = opts

return M
