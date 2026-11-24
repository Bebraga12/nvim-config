return {
  {
    "mattn/emmet-vim",
    ft = { "html", "htmlangular", "css", "scss", "javascriptreact", "typescriptreact" },
    init = function()
      -- Expandir: digite a abreviação e aperte <C-e>,
      vim.g.user_emmet_leader_key = "<C-e>"
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { check_ts = true },
  },

  -- Fecha/renomeia tags HTML automaticamente (HTML, Angular, JSX, XML)
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
