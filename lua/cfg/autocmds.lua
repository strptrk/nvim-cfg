local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

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
  pattern = { "xml", "html", "xhtml", "css", "scss", "javascript", "yaml", "lua" },
  callback = function()
    vim.opt.shiftwidth = 2
  end,
})

autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    vim.wo.number = false
  end,
})

autocmd('FileType', {
  pattern = { 'sh' },
  callback = function()
    vim.api.nvim_set_option_value('filetype', 'bash', { buf = 0 })
  end,
})

autocmd('BufReadPost', {
  pattern = '/tmp/zsh*',
  callback = function()
    vim.keymap.set('n', '<CR>', ':wq<CR>')
  end,
})
