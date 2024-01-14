local map = vim.keymap.set

map({ 'x', 'n' }, 'gA', 'ga')
map({ 'x', 'n' }, 'gs', '<Nop>')
map({ 'x', 'n' }, 'g<Space>', ':EasyAlign<CR>*<Space>')

-- for k, _ in string.gmatch('\'"[](){}<>`', '.') do
--   map('n', [[<CR>]] .. k, [[<Plug>(sandwich-add)iW]] .. k)
--   map('x', [[<CR>]] .. k, [[<Plug>(sandwich-add)]] .. k)
-- end

map('i', '<A-s>', '<Plug>luasnip-expand-or-jump')
map('i', '<A-a>', function()
  require('luasnip').jump(-1)
end)

map('n', '<A-a>', '<cmd>tabprevious<cr>')
map('n', '<A-d>', '<cmd>tabnext<cr>')
map('n', '<A-C>', '<cmd>tabclose<CR>')
map('n', '<A-t>', function()
  require('utils').FnNewTab(nil, { zz = true })
end, {desc = 'Open New Tab'})

map('n', '[q', '<cmd>cprevious<CR>')
map('n', ']q', '<cmd>cnext<CR>')
-- map('n', '[l', '<cmd>lprevious<CR>')
-- map('n', ']l', '<cmd>lnext<CR>')
map('n', '<A-A>', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
map('n', '<A-D>', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })


map('t', '<A-n>', [[<C-\><C-n>]])

map('n', '<C-M-h>', function()
  require('utils').SmartResize('h', 1)
end)
map('n', '<C-M-j>', function()
  require('utils').SmartResize('j', 1)
end)
map('n', '<C-M-k>', function()
  require('utils').SmartResize('k', 1)
end)
map('n', '<C-M-l>', function()
  require('utils').SmartResize('l', 1)
end)

map('n', '<C-s>', '<cmd>update<CR>')
map('n', '<A-c>', '<cmd>q<CR>')
map({ 'n', 't' }, '<A-Esc>', function()
  if vim.bo.buftype == 'terminal' then
    vim.cmd([[stopinsert]])
  else
    vim.cmd([[qa!]])
  end
end)

map('n', '<Up>', '<C-Y>k')
map('n', '<Down>', '<C-E>j')
map('x', '<Up>', '<C-Y>k')
map('x', '<Down>', '<C-E>j')

-- Move Lines
map("n", "<C-j>", "<cmd>m .+1<cr>==", { silent = true, desc = "Move down" })
map("n", "<C-k>", "<cmd>m .-2<cr>==", { silent = true, desc = "Move up" })
map("i", "<C-j>", "<esc><cmd>m .+1<cr>==gi", { silent = true, desc = "Move down" })
map("i", "<C-k>", "<esc><cmd>m .-2<cr>==gi", { silent = true, desc = "Move up" })
map("v", "<C-j>", ":m '>+1<cr>gv=gv", { silent = true, desc = "Move down" })
map("v", "<C-k>", ":m '<-2<cr>gv=gv", { silent = true, desc = "Move up" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

map('n', 'sE', '<cmd>g/^$/d<CR>')
map('n', 'sbc', '<cmd>.!bc -l<CR>')
map('n', 'sbq', '<cmd>.!qalc | grep "=" | cut -d"=" -f2 | xargs<CR>')
map('n', 'sbp', '<cmd>.!python<CR>')
map('x', 'sbc', '!bc -l<CR>')
map('x', 'sbp', '!python3<CR>')
-- map('n', 'se', '<cmd>.!$SHELL<CR>')
-- map('x', 'se', '!$SHELL<CR>')
map({ 'n', 'x' }, 'sF', '<cmd>Format<CR>', { desc = 'Format document (Formatter)' })
map({ 'n', 'x' }, 'sf', vim.lsp.buf.format, { desc = 'Format document (lsp)' })
map('n', 'sj', ':a<CR><CR>.<CR>', { desc = 'Append newline under', silent = true })
map('n', 'sk', ':i<CR><CR>.<CR>', { desc = 'Append newline above', silent = true })

map('n', ']s', '<cmd>bnext<CR>')
map('n', '[s', '<cmd>bprevious<CR>')
map('n', '<Space><Space>', '<C-^>')

----------------------------------------------------
-- make life a bit easier
----------------------------------------------------

map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')
map('n', 'Y', 'y$')
map('v', ';', ':')
map('n', ';', ':')
map('x', '.', ':norm.<CR>')
map('i', '<C-v>', '<C-r>+')
map('n', '<M-=>', '<cmd>wincmd =<CR>')
map('n', 'J', 'mzJ`z')
map('n', 'M', ':wall | make ')
-- should remap in future, never used
-- map('n', 'H', ':make ')
-- map('n', 'L', ':make ')

local CC = true
map('n', '<A-i>', function()
  -- exec([[IndentBlanklineToggle]])
  -- exec([[TSContextToggle]])
  if CC then
    vim.wo.colorcolumn = '80,120'
    vim.wo.cursorline = true
  else
    vim.wo.colorcolumn = '0'
    vim.wo.cursorline = false
  end
  CC = not CC
end)
map('i', '<A-e>', '<C-o>e<Right>')
map('i', '<A-w>', '<C-o>w')
map('i', '<A-b>', '<C-o>b')
map({ 'x', 'n' }, '<Left>', '^')
map({ 'x', 'n' }, '<Right>', '$')

map('i', '<C-;>', '<C-o>mz<C-o>:norm A;<CR><C-o>`z')
map('n', '<C-;>', 'mz:norm A;<CR>`z')

-- paste last yanked thing, not deleted
map('n', 'sp', '"0P', { desc = 'Paste before cursor', silent = true })
map('n', 'sP', 'viw"0P', { desc = 'Paste after cursor', silent = true })
map('x', 'sp', '"0P', { desc = 'Paste', silent = true })

map({ 'n', 'x' }, 'ga', '<Plug>(EasyAlign)')

map({ 'n', 'i', 't', 'v' }, '<A-h>', function()
  require('utils').WinMove('h')
end)
map({ 'n', 'i', 't', 'v' }, '<A-j>', function()
  require('utils').WinMove('j')
end)
map({ 'n', 'i', 't', 'v' }, '<A-k>', function()
  require('utils').WinMove('k')
end)
map({ 'n', 'i', 't', 'v' }, '<A-l>', function()
  require('utils').WinMove('l')
end)

map({ 'n', 'i', 't', 'v' }, '<A-H>', function()
  require('utils').SplitAndFocus('h')
end)
map({ 'n', 'i', 't', 'v' }, '<A-J>', function()
  require('utils').SplitAndFocus('j')
end)
map({ 'n', 'i', 't', 'v' }, '<A-K>', function()
  require('utils').SplitAndFocus('k')
end)
map({ 'n', 'i', 't', 'v' }, '<A-L>', function()
  require('utils').SplitAndFocus('l')
end)

map('n', '<Space>hv', ':vert help ')
map('n', '<Space>ht', ':tab help ')
map('n', '<Space>ho', ':help  | only' .. string.rep("<Left>", 7))
map('n', '<Space>N', "<cmd>Notifications<cr>")

local ts_rename = [[<cmd>lua require('nvim-treesitter-refactor.smart_rename').smart_rename(vim.api.nvim_win_get_buf(0))<cr>]]

local smart_rename = function()
  if require('utils').get_treesitter() then
    return ts_rename
  else
    return [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
  end
end
map('n', 'ss', smart_rename, { expr = true, desc = "Rename" })
map('n', 'sm', smart_rename, { expr = true, desc = "Rename" })
map('n', 's.', [[:.s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute (line)" })
map('n', 's,', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute (file)" })
map('n', 'sV', [[:'<,'>s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute (selection)" })
map('n', 's/', [[:%s//gI<Left><Left><Left>]], { desc = "Substitute" })
