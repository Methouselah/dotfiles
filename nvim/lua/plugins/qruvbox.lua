return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.o.background = "dark"

      require("gruvbox").setup({
        contrast = "soft",
      })

      vim.cmd.colorscheme("gruvbox")
    end,
  },
}
