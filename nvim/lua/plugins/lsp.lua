return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        update_in_insert = false,
        virtual_text = false,
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      lsp = { progress = { enabled = false } },
      routes = {
        {
          filter = { event = "msg_show", find = "AutoSave" },
          opts = { skip = true },
        },
      },
    },
  },
}
