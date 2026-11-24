vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.termguicolors = false
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus" -- Requer wl-clipboard no Hyprland
opt.updatetime = 250
opt.timeoutlen = 400
opt.scrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.undofile = true -- histórico de undo persiste entre sessões
opt.mouse = "a"
opt.confirm = true -- pergunta antes de fechar buffer modificado
opt.completeopt = { "menu", "menuone", "noselect" }

-- Folds via treesitter (começam abertos; use za / zc / zR / zM)
opt.foldlevel = 99
opt.foldlevelstart = 99

-- Força a transparência herdando o fundo do terminal
local function transparent()
  for _, group in ipairs({ "Normal", "NormalNC", "NormalFloat", "LineNr", "SignColumn", "EndOfBuffer", "FloatBorder" }) do
    vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
  end
  vim.api.nvim_set_hl(0, "MsgArea", { fg = "white", ctermfg = "White", bg = "none", ctermbg = "none" })
end
transparent()
-- reaplica se algum colorscheme for carregado depois
vim.api.nvim_create_autocmd("ColorScheme", { callback = transparent })
