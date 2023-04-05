------------------
------ LAZY ------
------------------

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins', {
  performance = {
    cache = { enabled = true },
    rtp = {
      disabled_plugins = {
        'gzip',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})

------------------
---- SETTINGS ----
------------------

local map = vim.keymap.set
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local api = vim.api
local defcommand = vim.api.nvim_create_user_command
local g = vim.g -- global variables
local o = vim.o -- global options
local b = vim.bo -- buffer-scoped options
local w = vim.wo -- windows-scoped options

local exec = function(s)
  vim.api.nvim_exec(s, false)
end

local exp = { expr = true, noremap = true }

o.mouse = 'a'
o.clipboard = 'unnamedplus'

o.syntax = 'enable'
o.virtualedit = 'block'
o.number = false
w.relativenumber = false
w.cursorline = false
w.linebreak = true
w.wrap = false
o.showmatch = true
w.colorcolumn = '0'
w.signcolumn = 'yes'
o.splitright = true
o.splitbelow = true
o.ignorecase = true
o.smartcase = true
o.hlsearch = false
b.expandtab = true
b.autoindent = true
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true

vim.opt.conceallevel = 1

o.sidescrolloff = 1
o.scrolloff = 1

o.completeopt = 'menuone,noselect'
o.encoding = 'utf-8'
o.fileencoding = 'utf-8'
o.ruler = true
o.hidden = true
o.history = 100
o.lazyredraw = false
b.synmaxcol = 240

-- lower updatetime to trigger treesitter-refactor's token highlight
-- swapfile directory changed to ramfs to avoid excessive disk writes
-- but nvim will not be able to recover after a power outage
o.updatetime = 750
vim.api.nvim_set_option('directory', '/tmp/nvimswap//')

g.move_map_keys = 0

g.c_syntax_for_h = 1

-- highlight on yank
local yankhl = augroup('YankHL', { clear = true })
autocmd('TextYankPost', {
  pattern = '*',
  group = yankhl,
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 300,
    })
  end,
})

-- 2 spaces for selected filetypes
autocmd('FileType', {
  pattern = 'xml,html,xhtml,css,scss,javascript,lua,yaml',
  callback = function()
    o.softtabstop = 2
    o.shiftwidth = 2
  end,
})

autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    o.number = false
  end,
})

autocmd('FileType', {
  pattern = vim.g.ts_ft,
  callback = function()
    w.number = true
  end,
})

autocmd('FileType', {
  pattern = { 'sh', 'zsh' },
  callback = function()
    vim.api.nvim_buf_set_option(0, 'filetype', 'bash')
  end,
})

autocmd('BufRead', {
  pattern = 'COMMIT_EDITMSG',
  callback = function()
    vim.api.nvim_buf_set_option(0, 'bufhidden', 'delete')
  end,
})

autocmd('BufReadPost', {
  pattern = '/tmp/zsh*',
  callback = function()
    map('n', '<CR>', ':wq<CR>')
  end,
})

defcommand('Diff', function(args)
  local a_file = args.fargs[1]
  local b_file = args.fargs[2]
  if a_file == nil or b_file == nil then
    print("error: 2 files needed")
    return
  end
  vim.cmd.tabedit(a_file)
  vim.cmd.vsplit(b_file)
  vim.cmd.windo('diffthis')
end, {
  force = true,
  nargs = "+",
  complete = 'file'
})

------------------
--- FUNCTIONS ----
------------------

local WinMove = function(key)
  local curwin = vim.fn.winnr()
  vim.cmd.wincmd(key)
  if curwin == vim.fn.winnr() then
    if os.getenv('TERM_PROGRAM') == 'WezTerm' then
      local dir = {
        ['h'] = 'Left',
        ['j'] = 'Down',
        ['k'] = 'Up',
        ['l'] = 'Right',
      }
      vim.fn.system('wezterm cli activate-pane-direction ' .. dir[key])
    end
  end
end

local SplitAndFocus = function(dir)
  if string.match(dir, '[jk]') then
    vim.cmd.wincmd('s')
  else
    vim.cmd.wincmd('v')
  end
  WinMove(dir)
end

vim.g.SplitInDirection = function(dir, fn, opts)
  opts = opts or {}
  local bufnr = api.nvim_win_get_buf(0)
  local pos = api.nvim_win_get_cursor(0)
  if opts.new or (vim.fn.winnr() == vim.fn.winnr(dir)) then
    if string.match(dir, '[jk]') then
      vim.cmd.wincmd('s')
    else
      vim.cmd.wincmd('v')
    end
  end
  WinMove(dir)
  api.nvim_win_set_buf(0, bufnr)
  api.nvim_win_set_cursor(0, pos)
  if type(fn) == 'function' then
    fn(opts.args)
  end
  if opts.zz then
    exec([[norm zz]])
  end
end

local SmartResize = function(direction, size)
  if string.match('jk', direction) and (vim.fn.winnr('j') == vim.fn.winnr('k')) then
    return -- prevent horizontally resizing the viewport
  end
  local to_dir = vim.fn.winnr(direction)
  local vertical = (direction == 'h' or direction == 'l') and 'vertical ' or ''
  if to_dir == vim.fn.winnr() then
    exec(vertical .. [[resize -]] .. size)
  else
    if to_dir == vim.fn.winnr('2' .. direction) then
      exec(vertical .. to_dir .. [[resize -]] .. size)
    else
      exec(vertical .. [[resize +]] .. size)
    end
  end
end

vim.g.FnNewTab = function(fn, opts)
  opts = opts or {}
  exec('norm m1')
  exec('tabedit %')
  exec('norm `1')
  if type(fn) == 'function' then
    fn()
  end
  if opts.zz then
    exec('norm zz')
  end
end

------------------
------ MAPS ------
------------------

map({ 'x', 'n' }, 'gA', 'ga')
map({ 'x', 'n' }, 'g<Space>', ':EasyAlign<CR>*<Space>')

for k, _ in string.gmatch('\'"[](){}<>`', '.') do
  map('n', [[<Space>]] .. k, [[<Plug>(sandwich-add)iW]] .. k)
  map('x', [[<Space>]] .. k, [[<Plug>(sandwich-add)]] .. k)
end

map('i', '<A-s>', '<Plug>luasnip-expand-or-jump')
map('i', '<A-a>', function()
  require('luasnip').jump(-1)
end)

map('n', '<A-a>', '<cmd>tabprevious<cr>')
map('n', '<A-d>', '<cmd>tabnext<cr>')
map('n', '<A-t>', '<cmd>tabnew<CR>')
map('n', '<A-C>', '<cmd>tabclose<CR>')
map('t', '<A-n>', [[<C-\><C-n>]])

map('n', '<C-M-h>', function()
  SmartResize('h', 1)
end)
map('n', '<C-M-j>', function()
  SmartResize('j', 1)
end)
map('n', '<C-M-k>', function()
  SmartResize('k', 1)
end)
map('n', '<C-M-l>', function()
  SmartResize('l', 1)
end)

map('n', '<C-s>', '<cmd>update<CR>')
map('n', '<A-c>', '<cmd>q<CR>')
map({ 'n', 't' }, '<A-Esc>', function()
  if vim.bo.buftype == 'terminal' then
    exec([[stopinsert]])
  else
    exec([[qa!]])
  end
end)

map('n', '<Up>', '<C-Y>k')
map('n', '<Down>', '<C-E>j')
map('x', '<Up>', '<C-Y>k')
map('x', '<Down>', '<C-E>j')
map('n', '<C-j>', '<Plug>MoveLineDown')
map('n', '<C-k>', '<Plug>MoveLineUp')
-- map('n', '<C-H>', '<Plug>MoveCharLeft', {})
-- map('n', '<C-L>', '<Plug>MoveCharRight', {})
map('v', '<C-j>', '<Plug>MoveBlockDown', {})
map('v', '<C-k>', '<Plug>MoveBlockUp', {})
-- map('v', '<C-H>', '<Plug>MoveBlockLeft' , {})
-- map('v', '<C-L>', '<Plug>MoveBlockRight', {})

map('n', 'sE', '<cmd>g/^$/d<CR>')
map('n', 'sbc', '<cmd>.!bc -l<CR>')
map('n', 'sbq', '<cmd>.!qalc | grep "=" | cut -d"=" -f2 | xargs<CR>')
map('n', 'sbp', '<cmd>.!python<CR>')
map('x', 'sbc', '!bc -l<CR>')
map('x', 'sbp', '!python<CR>')
map('n', 'se', '<cmd>.!$SHELL<CR>')
map('x', 'se', '!$SHELL<CR>')
map('n', 'sx', function()
  require('expand_expr').expand()
end, { desc = 'Expand lua expression' })
map({ 'n', 'x' }, 'sF', '<cmd>Format<CR>', { desc = 'Format document (Formatter)' })
map({ 'n', 'x' }, 'sf', vim.lsp.buf.format, { desc = 'Format document (lsp)' })
map('n', 'sj', ':a<CR><CR>.<CR>', { desc = 'Append newline under', silent = true })
map('n', 'sk', ':i<CR><CR>.<CR>', { desc = 'Append newline above', silent = true })

map('n', ']b', '<cmd>bnext<CR>')
map('n', '[b', '<cmd>bprevious<CR>')
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
-- map('x', 'Q', ":'<,'>:normal @q<CR>")
map({ 'n', 'v' }, 'c', '"_c')
map({ 'n', 'v' }, 'C', '"_C')
map('i', '<C-v>', '<C-r>+')
map('n', '<M-=>', '<cmd>wincmd =<CR>')
map('n', 'J', 'mzJ`z')

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

map('i', '<A-;>', '<C-o>mz<C-o>:norm A;<CR><C-o>`z')
map('n', '<A-;>', 'mz:norm A;<CR>`z')

-- paste last yanked thing, not deleted
map('n', 'sp', '"0P', { desc = 'Paste before cursor', silent = true })
map('n', 'sP', 'viw"0P', { desc = 'Paste after cursor', silent = true })
map('x', 'sp', '"0P', { desc = 'Paste', silent = true })

map({ 'n', 'x' }, 'ga', '<Plug>(EasyAlign)')

map({ 'n', 'i', 't', 'v' }, '<A-h>', function()
  WinMove('h')
end)
map({ 'n', 'i', 't', 'v' }, '<A-j>', function()
  WinMove('j')
end)
map({ 'n', 'i', 't', 'v' }, '<A-k>', function()
  WinMove('k')
end)
map({ 'n', 'i', 't', 'v' }, '<A-l>', function()
  WinMove('l')
end)

map({ 'n', 'i', 't', 'v' }, '<A-H>', function()
  SplitAndFocus('h')
end)
map({ 'n', 'i', 't', 'v' }, '<A-J>', function()
  SplitAndFocus('j')
end)
map({ 'n', 'i', 't', 'v' }, '<A-K>', function()
  SplitAndFocus('k')
end)
map({ 'n', 'i', 't', 'v' }, '<A-L>', function()
  SplitAndFocus('l')
end)

CR = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
      return '<c-y>'
    else
      return '<c-e>' .. [[<cmd>lua require'pairs.enter'.type()<CR>]]
    end
  else
    return [[<cmd>lua require'pairs.enter'.type()<CR>]]
  end
end
map('i', '<cr>', 'v:lua.CR()', exp)

map('n', '<space>T', function()
  vim.g.FnNewTab(nil, { zz = true })
end, {desc = 'Open New Tab'})

map('n', '<Space>hv', ':vert help ')
map('n', '<Space>ht', ':tab help ')
map('n', '<Space>ho', ':help  | only' .. string.rep("<Left>", 7))
map('n', '<Space>N', "<cmd>Notifications<cr>")
map('n', '<Space>L', vim.diagnostic.setloclist, { desc = 'Diagnostic Set Loclist' })
map('n', '<Space>a', vim.lsp.buf.code_action, { desc = "Code Action" })
map('n', 'gs', vim.lsp.buf.declaration, { desc = 'Go to Declaration' })

local smart_rename = function()
  if vim.g.Get_langserv() ~= '' then
    return [[<cmd>lua vim.lsp.buf.rename()<cr>]]
  elseif vim.g.Get_treesitter() ~= '' then
    return [[<cmd>lua require('nvim-treesitter-refactor.smart_rename').smart_rename(vim.api.nvim_win_get_buf(0))<cr>]]
  else
    return [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
  end
end
map('n', 'ss', smart_rename, { expr = true, desc = "Rename" })
map('n', 's.', [[:.s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute (line)" })
map('n', 's,', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute (file)" })

map('n', '<Space>qp', '<cmd>cprev<CR>')
map('n', '<Space>qn', '<cmd>cnext<CR>')
map('n', '<Space>qc', '<cmd>cclose<CR>')
map('n', '<Space>qo', '<cmd>copen<CR>')
map('n', 'g[', function() vim.diagnostic.goto_prev() end, { desc = 'Go to previous diagnostic' })
map('n', 'g]', function() vim.diagnostic.goto_next() end, { desc = 'Go to next diagnostic' })
map('n', 'sh', function() vim.lsp.buf.hover() end, { desc = 'Symbol hover information' })
map('n', '<Space>sh', '<cmd>ClangdSwitchSourceHeader<cr>', { desc = 'Switch source and header' })
