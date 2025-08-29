-- Устанавливаем лид (Space)
vim.g.mapleader = " "

-- Базовые настройки
vim.o.number = true -- показывать номера строк
vim.o.relativenumber = true -- относительные номера
vim.o.termguicolors = true -- красивые цвета
vim.o.expandtab = true -- табы = пробелы
vim.o.shiftwidth = 2 -- размер таба
vim.o.tabstop = 2
vim.o.smartindent = true
vim.o.ignorecase = true -- игнорить регистр при поиске
vim.o.smartcase = true -- если есть заглавная буква — учитывать регистр

-- Базовые бинды
vim.keymap.set("n", "<leader>w", ":w<CR>") -- сохранить
vim.keymap.set("n", "<leader>q", ":q<CR>") -- выйти

-- ===== Lazy.nvim bootstrap =====
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
vim.fn.system({
"git", "clone", "--filter=blob:none",
"https://github.com/folke/lazy.nvim.git",
"--branch=stable", lazypath,
})
end
vim.opt.rtp:prepend(lazypath)

-- Подключаем плагины
require("lazy").setup({
-- Тема
{ "folke/tokyonight.nvim", lazy = false, priority = 1000,
config = function()
vim.cmd([[colorscheme tokyonight]])
end
},

-- Подсветка синтаксиса
{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

-- Файловый поиск (Telescope)
{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

-- LSP (подсветка ошибок, автокомплит)
{ "neovim/nvim-lspconfig" },
})
