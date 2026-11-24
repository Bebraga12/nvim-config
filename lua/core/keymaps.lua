local keymap = vim.keymap

-- =========================================================
-- EXPLORER (NvimTree)
-- =========================================================
keymap.set("n", "<F1>", "<Cmd>NvimTreeToggle<CR>", { silent = true, desc = "NvimTree: Toggle" })
keymap.set("n", "<F2>", "<Cmd>NvimTreeFocus<CR>", { silent = true, desc = "NvimTree: Focus" })
keymap.set("n", "<leader>E", "<Cmd>NvimTreeFindFileToggle<CR>", { silent = true, desc = "NvimTree: Revelar arquivo atual" })

-- =========================================================
-- UI / VISUAL
-- =========================================================
keymap.set("n", "<leader>h", "<Cmd>nohl<CR>", { desc = "UI: Limpar highlight da busca" })
keymap.set("n", "<Esc>", "<Cmd>nohl<CR><Esc>", { silent = true })

keymap.set("n", "<F3>", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { silent = true, desc = "UI: Alternar relativenumber" })

-- Manter seleção ao indentar
keymap.set("v", "<", "<gv", { desc = "Indent: esquerda" })
keymap.set("v", ">", ">gv", { desc = "Indent: direita" })

-- Ctrl+I estilo Eclipse: corrige a indentação da linha/seleção
-- (no Kitty o Neovim diferencia <C-i> de <Tab>; substitui o "avançar no jumplist")
keymap.set("n", "<C-i>", "==", { desc = "Corrigir indentação da linha" })
keymap.set("v", "<C-i>", "=gv", { desc = "Corrigir indentação da seleção" })

-- Mover linhas/blocos com Alt+j / Alt+k
keymap.set("n", "<A-j>", "<Cmd>m .+1<CR>==", { desc = "Mover linha p/ baixo" })
keymap.set("n", "<A-k>", "<Cmd>m .-2<CR>==", { desc = "Mover linha p/ cima" })
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Mover bloco p/ baixo" })
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Mover bloco p/ cima" })

-- Navegar entre janelas (splits)
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Janela à esquerda" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Janela abaixo" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Janela acima" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Janela à direita" })
keymap.set("n", "<leader>sv", "<Cmd>vsplit<CR>", { desc = "Split vertical" })
keymap.set("n", "<leader>sh", "<Cmd>split<CR>", { desc = "Split horizontal" })

-- Salvar
keymap.set({ "n", "i", "v" }, "<C-s>", "<Cmd>write<CR><Esc>", { desc = "Salvar arquivo" })

-- =========================================================
-- TERMINAL
-- =========================================================
-- F4: Kitty externo na raiz do projeto
keymap.set("n", "<F4>", function()
  local root = vim.fs.root(0, { ".git", "pom.xml", "package.json" }) or vim.fn.getcwd()
  vim.fn.jobstart("kitty", { cwd = root })
end, { silent = true, desc = "Terminal: Kitty na raiz do projeto" })

-- Sair do modo terminal com Esc Esc
keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Terminal: modo normal" })

-- =========================================================
-- EXECUÇÃO (detecta Spring/Maven, Gradle, Ionic, Angular, Node)
-- =========================================================
keymap.set("n", "<F11>", function() require("core.runner").run() end, { silent = true, desc = "Run: projeto/arquivo" })
keymap.set("n", "<leader>rr", function() require("core.runner").run() end, { desc = "Run: projeto/arquivo" })
keymap.set("n", "<leader>rt", function() require("core.runner").test() end, { desc = "Run: testes do projeto" })

-- =========================================================
-- BUFFERS / ABAS
-- =========================================================
for i = 1, 9 do
  keymap.set("n", "<C-" .. i .. ">", "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", {
    silent = true,
    desc = "BufferLine: buffer " .. i,
  })
end
keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Próximo buffer" })
keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Buffer anterior" })

-- Ctrl + w: fecha o buffer atual (mantém a janela/layout)
-- OBS: isso substitui o prefixo nativo <C-w> de janelas; use <C-h/j/k/l> e <leader>s* acima.
keymap.set("n", "<C-w>", function()
  local buf = vim.api.nvim_get_current_buf()
  vim.cmd("BufferLineCyclePrev")
  if vim.api.nvim_get_current_buf() == buf then vim.cmd("enew") end
  pcall(vim.cmd, "bdelete " .. buf)
end, { silent = true, desc = "Buffer: fechar atual" })

-- =========================================================
-- GIT
-- =========================================================
keymap.set("n", "<leader>g", "<Cmd>tabnew | terminal lazygit<CR>i", { silent = true, desc = "Git: Lazygit" })

-- =========================================================
-- ATALHOS ESTILO EDITOR COMUM
-- =========================================================
keymap.set("n", "<C-a>", "ggVG", { desc = "Selecionar tudo" })
keymap.set("n", "<C-z>", "u", { desc = "Desfazer" })
keymap.set("i", "<C-z>", "<C-o>u", { desc = "Desfazer (insert)" })

keymap.set("n", "<S-Home>", "v$", { desc = "Selecionar até o fim da linha" })
keymap.set("i", "<S-Home>", "<Esc>v$", { desc = "Selecionar até o fim da linha" })
keymap.set("n", "<End>", "$", { desc = "Fim da linha" })
keymap.set("i", "<End>", "<Esc>$a", { desc = "Fim da linha" })
keymap.set("v", "<End>", "<Esc>$", { desc = "Cancelar seleção e ir p/ fim da linha" })

-- =========================================================
-- DIAGNÓSTICOS
-- =========================================================
keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnóstico da linha" })
keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Diagnóstico anterior" })
keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Próximo diagnóstico" })

-- =========================================================
-- MARKDOWN
-- =========================================================
keymap.set("n", "<F6>", "<Cmd>MarkdownPreviewToggle<CR>", { desc = "Preview Markdown" })
keymap.set("n", "<leader>mp", "<Cmd>MarkdownPreviewToggle<CR>", { desc = "Preview Markdown" })

-- =========================================================
-- TELESCOPE
-- =========================================================
local function tb(name, opts)
  return function() require("telescope.builtin")[name](opts) end
end
keymap.set("n", "<leader>ff", tb("find_files"), { desc = "Buscar arquivos" })
keymap.set("n", "<C-p>", tb("find_files"), { desc = "Buscar arquivos" })
keymap.set("n", "<leader>fg", tb("live_grep"), { desc = "Buscar texto (grep)" })
keymap.set("n", "<leader>fw", tb("grep_string"), { desc = "Buscar palavra sob o cursor" })
keymap.set("n", "<leader>fb", tb("buffers"), { desc = "Buscar buffers" })
keymap.set("n", "<leader>fh", tb("help_tags"), { desc = "Buscar ajuda" })
keymap.set("n", "<leader>fr", tb("oldfiles"), { desc = "Arquivos recentes" })
keymap.set("n", "<leader>fd", tb("diagnostics"), { desc = "Diagnósticos do projeto" })
keymap.set("n", "<leader>fs", tb("lsp_document_symbols"), { desc = "Símbolos do arquivo" })
keymap.set("n", "<leader>fS", tb("lsp_dynamic_workspace_symbols"), { desc = "Símbolos do projeto" })
keymap.set("n", "<leader>fk", tb("keymaps"), { desc = "Buscar atalhos" })
