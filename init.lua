------------------
------ LAZY ------
------------------

---@diagnostic disable-next-line: undefined-field
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  performance = {
    cache = { enabled = true },
    change_detection = {
      enabled = false,
      notify = false,
    },
    rtp = {
      disabled_plugins = {
        "tohtml",
        "tutor",
        "netrwPlugin"
      },
    },
    readme = {
      enabled = false
    }
  },
})

local opt = vim.opt

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.syntax = "enable"
opt.virtualedit = "block"
opt.number = true
opt.relativenumber = false
opt.cursorline = false
opt.linebreak = true
opt.wrap = false
opt.showmatch = true
opt.signcolumn = "yes"
opt.splitright = true
opt.splitkeep = "screen"
opt.splitbelow = true
opt.smartcase = true
opt.hlsearch = true
opt.expandtab = true
opt.autoindent = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.conceallevel = 2
opt.sidescrolloff = 1
opt.scrolloff = 1
opt.ruler = true
opt.hidden = true
opt.history = 100
opt.lazyredraw = false
opt.synmaxcol = 240
opt.showmode = false
opt.exrc = true

-- revert back to vim's block cursor in insert mode as a default
opt.guicursor = "i-n-v-c-sm:block,ci-ve:ver25,r-cr-o:hor20"

if vim.env["NVIM_SWAP_DIR"] then
  if vim.env["NVIM_SWAP_DIR"] == "ram" then
    opt.updatetime = 750
    vim.api.nvim_set_option_value(
      "directory",
      "/tmp/.nvim_swap_dir_" .. (vim.env["USER"] or "") .. "//",
      { scope = "global" })
  else
    vim.api.nvim_set_option_value(
      "directory",
      vim.env["NVIM_SWAP_DIR"],
      { scope = "global" })
  end
end

---@diagnostic disable-next-line: inject-field
vim.g.c_syntax_for_h = 1

-- abbreviations
vim.cmd([[
  cnoreabbrev qt tabclose
  cnoreabbrev qq q!
  cnoreabbrev qqa qa!
  cnoreabbrev SL s/\ /\ \\\r/g
]])

-- load config after loading all UI elements
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("cfg.utils")
    require("cfg.maps")
    require("cfg.commands")
  end,
})
require("cfg.autocmds")
