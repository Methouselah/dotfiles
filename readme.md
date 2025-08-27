-- ~/.config/nvim/lua/plugins/autosave_on_tab.lua

local M = {}

function M.setup()
-- Автокоманда для сохранения файла при уходе с текущего буфера
vim.api.nvim_create_autocmd({"BufLeave", "TabLeave", "WinLeave"}, {
pattern = "\*",
callback = function()
-- Проверяем, что файл редактируемый и не readonly
if vim.bo.modifiable and vim.bo.modified then
vim.cmd("silent! write")
end
end,
})
end

return M
