local map = vim.keymap.set
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local g = vim.g -- global variables
local o = vim.o -- global options
local b = vim.bo -- buffer-scoped options
local w = vim.wo -- windows-scoped options

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

o.termguicolors = true

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
  pattern = "sh",
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

-- dont autocomment new lines
autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.opt.formatoptions:remove('c')
    vim.opt.formatoptions:remove('r')
    vim.opt.formatoptions:remove('o')
  end,
})
