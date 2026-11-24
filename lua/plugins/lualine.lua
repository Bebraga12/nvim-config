return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local auto_theme = require('lualine.themes.auto')
    
    -- Itera sobre todos os modos (normal, insert, visual, etc) e remove o fundo
    for _, mode in pairs(auto_theme) do
      if mode.a then mode.a.bg = 'NONE' end
      if mode.b then mode.b.bg = 'NONE' end
      if mode.c then mode.c.bg = 'NONE' end
    end

    require("lualine").setup({
      options = {
        theme = auto_theme,
        component_separators = '|',
        section_separators = '',
      }
    })
  end,
}
