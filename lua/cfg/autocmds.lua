local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- highlight on yank
local yankhl = augroup("YankHL", { clear = true })
autocmd("TextYankPost", {
  pattern = "*",
  group = yankhl,
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 300,
    })
  end,
})

-- 2 spaces for selected filetypes
autocmd("FileType", {
  pattern = { "xml", "html", "xhtml", "css", "scss", "javascript", "yaml", "lua" },
  callback = function()
    vim.opt.shiftwidth = 2
  end,
})

-- usual line width limitations for git commit messages
autocmd("FileType", {
  pattern = { "gitcommit" },
  callback = function()
    vim.wo.colorcolumn = "72,100,120"
  end,
})

autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.wo.number = false
  end,
})

-- for <C-x><C-e> commandline editing
autocmd("BufReadPost", {
  pattern = "/tmp/zsh*",
  callback = function()
    vim.keymap.set("n", "<CR>", ":wq<CR>")
  end,
})
