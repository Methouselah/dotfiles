-- Лид клавиша
vim.g.mapleader = " "

-- Базовые настройки
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- Бинды
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")

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

-- ===== Плагины =====
require("lazy").setup({
-- Тема
{ "folke/tokyonight.nvim", lazy = false, priority = 1000,
config = function()
vim.cmd([[colorscheme tokyonight]])
end
},

-- Treesitter (подсветка синтаксиса)
{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

-- Telescope (поиск файлов/текста)
{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

-- LSP
{ "neovim/nvim-lspconfig" },

-- Автокомплит
{
"hrsh7th/nvim-cmp",
dependencies = {
"hrsh7th/cmp-nvim-lsp",
"hrsh7th/cmp-buffer",
"hrsh7th/cmp-path",
"L3MON4D3/LuaSnip",
},
},

-- Форматирование (Prettier и т.п.)
{ "jose-elias-alvarez/null-ls.nvim" },

-- Автосохранение
{
"Pocco81/auto-save.nvim",
config = function()
require("auto-save").setup()
end
},
})

-- ===== LSP и автокомплит =====
local lspconfig = require("lspconfig")
local cmp = require("cmp")

-- capabilities для nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Go (gopls)
lspconfig.gopls.setup({
capabilities = capabilities,
})

-- JavaScript / TypeScript (tsserver)
lspconfig.tsserver.setup({
capabilities = capabilities,
})

-- Настройка автокомплита
cmp.setup({
mapping = {
["<C-Space>"] = cmp.mapping.complete(),
["<CR>"] = cmp.mapping.confirm({ select = true }),
},
sources = {
{ name = "nvim_lsp" },
{ name = "buffer" },
{ name = "path" },
},
})

-- ===== Форматирование =====
local null_ls = require("null-ls")

null_ls.setup({
sources = {
-- JS/TS/React — Prettier
null_ls.builtins.formatting.prettier,
-- Go — goimports
null_ls.builtins.formatting.goimports,
},
})

-- Форматирование при сохранении
vim.api.nvim_create_autocmd("BufWritePre", {
callback = function()
vim.lsp.buf.format()
end,
})
