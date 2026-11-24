-- nvim-treesitter (branch main). Requer o CLI: sudo pacman -S tree-sitter-cli
local parsers = {
  "lua", "vim", "vimdoc", "query", "regex", "bash",
  "java", "xml", "properties", "sql",
  "javascript", "typescript", "tsx", "jsdoc",
  "html", "angular", "css", "scss",
  "json", "yaml", "toml", "dockerfile",
  "markdown", "markdown_inline", "gitignore", "diff",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      if vim.fn.executable("tree-sitter") == 1 then
        ts.install(parsers)
      else
        vim.schedule(function()
          vim.notify("tree-sitter CLI não encontrado: sudo pacman -S tree-sitter-cli", vim.log.levels.WARN)
        end)
      end

      -- Ativa highlight, folds e indentação para qualquer filetype com parser instalado
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("braga-treesitter", { clear = true }),
        callback = function(ev)
          if not pcall(vim.treesitter.start, ev.buf) then return end
          vim.wo[0][0].foldmethod = "expr"
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          if ev.match ~= "java" then -- jdtls/vim indent já funciona melhor para Java
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
