------------------
------ LAZY ------
------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- disable, so which-key does not fall back to it
vim.keymap.set({ "n", "v" }, "s", "<Nop>")
vim.keymap.set({ "n", "x" }, "gc", "<Nop>")
vim.keymap.set({ "n", "x" }, "gcc", "<Nop>")
vim.g.c_syntax_for_h = 1 -- assume .h files are c, not c++
vim.opt.guicursor = "i-n-v-c-sm:block,ci-ve:ver25,r-cr-o:hor20" -- block cursor in insert
vim.g.solutionfmt = {
  ["begin"] = "@solution begin",
  ["end"] = "@solution end"
}

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

vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.syntax = "enable"
vim.opt.virtualedit = "block"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = false
vim.opt.linebreak = true
vim.opt.wrap = false
vim.opt.showmatch = true
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitkeep = "screen"
vim.opt.splitbelow = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.conceallevel = 2
vim.opt.sidescrolloff = 1
vim.opt.scrolloff = 1
vim.opt.ruler = true
vim.opt.hidden = true
vim.opt.history = 100
vim.opt.lazyredraw = false
vim.opt.synmaxcol = 240
vim.opt.showmode = false
vim.opt.exrc = true

vim.opt.updatetime = 2000
if vim.env["NVIM_SWAP_DIR"] then
  if vim.env["NVIM_SWAP_DIR"] == "ram" then
    vim.opt.updatetime = 750
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

-- load config after loading all UI elements
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("cfg.maps")
    require("cfg.commands")
    -- abbreviations
    vim.cmd([[
      cnoreabbrev qt tabclose
      cnoreabbrev qq q!
      cnoreabbrev qqa qa!
      cnoreabbrev Splitws s/\ /\ \\\r/g
    ]])
  end,
})
require("cfg.autocmds")
