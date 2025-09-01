return {
  "pocco81/auto-save.nvim",
  config = function()
    require("auto-save").setup({
      trigger_events = { "BufLeave", "FocusLost", "TabLeave" },
      condition = function(buf)
        local fn = vim.fn

        if fn.getbufvar(buf, "&modifiable") == 1 and fn.empty(fn.expand("%:p")) == 0 then
          return true
        end
        return false
      end,
    })
  end,
}
