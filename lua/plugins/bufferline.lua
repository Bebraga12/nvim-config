return {
  "akinsho/bufferline.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("bufferline").setup({
      options = {
        numbers = "ordinal", -- Mostra o número 1, 2, 3 na aba para você saber qual atalho apertar
        close_command = "bd %d", -- Fecha o buffer corretamente
        --indicator = { style = "underline" },
        indicator = { style = "icon", icon = "▎" },
      }
    })
  end,
}