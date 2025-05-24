vim.cmd([[
  if exists(':Hi')
    Hi color
    Hi todo
  endif
]])
vim.bo.commentstring = "# %s"
