-- Desabilitar providers que não uso
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.commands")

-- =========================================================
-- Diagnósticos
-- =========================================================
vim.diagnostic.config({
  update_in_insert = true,
  virtual_text = { spacing = 2, prefix = "●" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰌶",
    },
  },
  underline = true,
  severity_sort = true,
  float = { border = "rounded", source = true },
})

-- =========================================================
-- lazy.nvim
-- =========================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  change_detection = { notify = false },
  checker = { enabled = false },
})
