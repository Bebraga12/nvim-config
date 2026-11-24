local au = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("braga", { clear = true })

-- Destaca o texto copiado
au("TextYankPost", {
  group = group,
  callback = function() vim.hl.on_yank({ timeout = 150 }) end,
})

-- Volta para a última posição do cursor ao reabrir um arquivo
au("BufReadPost", {
  group = group,
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lines = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Java usa 4 espaços (padrão Spring / Google style)
au("FileType", {
  group = group,
  pattern = { "java", "xml" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})
