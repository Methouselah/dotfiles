return {
  -- 1. Указываем репозиторий плагина на GitHub
  "Exafunction/codeium.vim",

  -- 2. Условие загрузки (например, загружать только когда начинаем редактировать)
  event = "InsertEnter",

  -- 3. Настройки самого плагина (опционально)
  config = function()
    -- Твой кастомный Lua-код для настройки этого плагина
    vim.keymap.set("i", "<C-g>", function()
      return vim.fn["codeium#Accept"]()
    end, { expr = true, silent = true })
  end,
}
