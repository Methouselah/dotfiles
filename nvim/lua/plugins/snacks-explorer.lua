return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    explorer = {
      enabled = true,
      show_hidden = true, -- changed 'hidden' to 'show_hidden' which is more typical
      sources = {
        files = true,
        git = true,
        scripts = false,
      },
    },
    picker = {
      enabled = true,
      sources = {
        files = {
          show_hidden = true, -- unified property name and plural files
          show_ignored = true,
        },
        explorer = {
          layout = {
            preset = "sidebar",
            preview = false,
            position = "left",
            width = 10,
          },
        },
      },
    },
  },
  config = function(_, opts)
    local Snacks = require("snacks")
    Snacks.setup(opts)
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if vim.fn.argc(-1) == 0 then
          Snacks.explorer.open()
        end
      end,
    })
  end,
}
