return {
  -- Mostra os atalhos disponíveis ao apertar <leader> (e outros prefixos)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>f", group = "Buscar (Telescope)" },
        { "<leader>c", group = "Código" },
        { "<leader>d", group = "Debug" },
        { "<leader>r", group = "Run / Renomear" },
        { "<leader>s", group = "Splits" },
        { "<leader>v", group = "Git (hunks)" },
        { "<leader>j", group = "Java" },
        { "<leader>x", group = "Diagnósticos (Trouble)" },
      },
    },
  },

  -- Formatação ao salvar (Prettier para web, jdtls para Java, stylua para Lua)
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, mode = { "n", "v" }, desc = "Formatar" },
      { "<leader>tf", function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify("Formatar ao salvar: " .. (vim.g.disable_autoformat and "OFF" or "ON"))
        end, desc = "Alternar formatar ao salvar" },
    },
    opts = {
      formatters_by_ft = {
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        htmlangular = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
        -- java: usa o formatter do jdtls (lsp_format = "fallback")
      },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 1500, lsp_format = "fallback" }
      end,
    },
  },

  -- Marcações de git na lateral + ações por hunk
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = "Git: " .. desc })
        end
        map("]h", function() gs.nav_hunk("next") end, "Próximo hunk")
        map("[h", function() gs.nav_hunk("prev") end, "Hunk anterior")
        map("<leader>vp", gs.preview_hunk, "Preview hunk")
        map("<leader>vs", gs.stage_hunk, "Stage hunk")
        map("<leader>vr", gs.reset_hunk, "Reset hunk")
        map("<leader>vb", function() gs.blame_line({ full = true }) end, "Blame da linha")
        map("<leader>vB", gs.toggle_current_line_blame, "Alternar blame inline")
        map("<leader>vd", gs.diffthis, "Diff do arquivo")
      end,
    },
  },

  -- Lista de erros/avisos do projeto inteiro
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<Cmd>Trouble diagnostics toggle<CR>", desc = "Diagnósticos do projeto" },
      { "<leader>xb", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Diagnósticos do buffer" },
      { "<leader>xs", "<Cmd>Trouble symbols toggle focus=false<CR>", desc = "Outline de símbolos" },
      { "<leader>xt", "<Cmd>Trouble todo toggle<CR>", desc = "TODOs" },
    },
  },

  -- Destaca TODO/FIXME/HACK/NOTE
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
    keys = {
      { "<leader>ft", "<Cmd>TodoTelescope<CR>", desc = "Buscar TODOs" },
    },
  },

  -- Guias de indentação
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- termguicolors está off: define as cores em cterm
      local function hl()
        vim.api.nvim_set_hl(0, "IblIndent", { ctermfg = 236, fg = "#303030" })
        vim.api.nvim_set_hl(0, "IblScope", { ctermfg = 244, fg = "#808080" })
      end
      hl()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = hl })
      require("ibl").setup({ indent = { char = "│" }, scope = { enabled = true } })
    end,
  },

  -- Edita pares: cs"' troca aspas, ysiw) envolve palavra, ds( remove
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
}
