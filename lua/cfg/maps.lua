local map = vim.keymap.set

map({ "x", "n" }, "gA", "ga")
map({ "x", "n" }, "gs", "<Nop>")

map("n", "<A-a>", "<cmd>tabprevious<cr>")
map("n", "<A-d>", "<cmd>tabnext<cr>")
map("n", "<A-C>", "<cmd>tabclose<CR>")
map("n", "<A-t>", function()
  require("cfg.utils").fntab(nil, { zz = true })
end, { desc = "Open New Tab" })

map("n", "[q", "<cmd>cprevious<CR>")
map("n", "]q", "<cmd>cnext<CR>")
map("n", "[l", "<cmd>lprevious<CR>")
map("n", "]l", "<cmd>lnext<CR>")
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "<Space>dl", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

map("n", "<C-M-h>", function()
  require("cfg.utils").resize("h", 1)
end)
map("n", "<C-M-j>", function()
  require("cfg.utils").resize("j", 1)
end)
map("n", "<C-M-k>", function()
  require("cfg.utils").resize("k", 1)
end)
map("n", "<C-M-l>", function()
  require("cfg.utils").resize("l", 1)
end)

map("n", "<C-s>", "<cmd>update<CR>")
map("n", "<A-c>", "<cmd>q<CR>")

map("t", "<Esc><Esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("n", "<Space>u", function()
  require("cfg.utils").highlight_usages()
end, { desc = "Highlight Usages" })
map("n", "<Space>U", function()
  return require("cfg.utils").highlight_cmd_all()
end, { expr = true, desc = "Highlight Usages (all)" })
map({ "i", "n" }, "<Esc>", [[<cmd>lua require("cfg.utils").clear_highlight_usages()<CR><Esc>]], { desc = "Escape and Clear Highlights" })
map({ "n", "t" }, "<A-Esc>", function()
  if vim.bo.buftype == "terminal" then
    vim.cmd([[stopinsert]])
  else
    vim.cmd([[qa!]])
  end
end)

map({ "n", "v" }, "<Up>", "<C-Y>k")
map({ "n", "v" }, "<Down>", "<C-E>j")
map({ "n", "v" }, "<Left>", "^")
map({ "n", "v" }, "<Right>", "$")

map("n", "<C-j>", "<cmd>m .+1<cr>==", { silent = true, desc = "Move down" })
map("n", "<C-k>", "<cmd>m .-2<cr>==", { silent = true, desc = "Move up" })
map("v", "<C-j>", ":m '>+1<cr>gv=gv", { silent = true, desc = "Move down" })
map("v", "<C-k>", ":m '<-2<cr>gv=gv", { silent = true, desc = "Move up" })

map("v", "<", "<gv")
map("v", ">", ">gv")

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

map("n", "sE", "<cmd>g/^$/d<CR>")
map("n", "sj", ":a<CR><CR>.<CR>", { desc = "Append newline under", silent = true })
map("n", "sk", ":i<CR><CR>.<CR>", { desc = "Append newline above", silent = true })

map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "Y", "y$")
map({ "n", "v" }, ";", ":")
map("x", ".", ":norm.<CR>")
map("i", "<C-v>", "<C-r>+")
map("n", "<M-=>", "<cmd>wincmd =<CR>")
map("n", "J", "mzJ`z")

map("n", "<A-i>", function()
  if vim.wo.cursorline == true then
    vim.wo.cursorline = false
    vim.wo.cursorcolumn = false
    vim.wo.colorcolumn = "0"
  else
    vim.wo.cursorline = true
    vim.wo.cursorcolumn = true
    vim.wo.colorcolumn = "80,100,120"
  end
end)

-- paste last yanked thing, not deleted
map({ "n", "x" }, "<Space>p", 'mz"0P`z', { desc = "Paste", silent = true })
map("n", "<Space>w", 'mzviw"0P`z', { desc = "Replace word with last yanked text.", silent = true })

map({ "n", "i", "t", "v" }, "<A-h>", function()
  require("cfg.utils").winmove("h")
end)
map({ "n", "i", "t", "v" }, "<A-j>", function()
  require("cfg.utils").winmove("j")
end)
map({ "n", "i", "t", "v" }, "<A-k>", function()
  require("cfg.utils").winmove("k")
end)
map({ "n", "i", "t", "v" }, "<A-l>", function()
  require("cfg.utils").winmove("l")
end)
map({ "n", "v" }, "<leader>h", function()
  require("cfg.utils").winmove("h")
end)
map({ "n", "v" }, "<leader>j", function()
  require("cfg.utils").winmove("j")
end)
map({ "n", "v" }, "<leader>k", function()
  require("cfg.utils").winmove("k")
end)
map({ "n", "v" }, "<leader>l", function()
  require("cfg.utils").winmove("l")
end)

map({ "n", "i", "t", "v" }, "<A-H>", function()
  require("cfg.utils").split_focus("h")
end)
map({ "n", "i", "t", "v" }, "<A-J>", function()
  require("cfg.utils").split_focus("j")
end)
map({ "n", "i", "t", "v" }, "<A-K>", function()
  require("cfg.utils").split_focus("k")
end)
map({ "n", "i", "t", "v" }, "<A-L>", function()
  require("cfg.utils").split_focus("l")
end)

map("n", "<Space>hv", ":vert help ")
map("n", "<Space>ht", ":tab help ")
map("n", "<Space>ho", ":help  | only" .. string.rep("<Left>", 7))
map("n", "<Space>N", "<cmd>Notifications<cr>")

map("n", "ss", function()
  require("cfg.utils").smart_rename_ts()
end, { desc = "Rename" })
map("n", "s.", [[:.s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute (line)" })
map("n", "s,", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute (file)" })
map("n", "sv", [[:'<,'>s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute (selection)" })
map("n", "s/", [[:%s//gI<Left><Left><Left>]], { desc = "Substitute" })
