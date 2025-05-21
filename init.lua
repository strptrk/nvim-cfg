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

vim.hl = vim.hl or vim.highlight -- workaround for 0.10.3 bug

-- disable, so which-key does not fall back to it
vim.keymap.set({ "n", "v" }, "s", "<Nop>")
vim.keymap.set({ "n", "x" }, "gc", "<Nop>")
vim.keymap.set({ "n", "x" }, "gcc", "<Nop>")

if 1 == vim.fn.has("nvim-0.11") then
  -- delete default lsp-related keybinds (replaced by picker-based)
  vim.keymap.del("n", "gra") -- code action
  vim.keymap.del("n", "grr") -- references
  vim.keymap.del("n", "gri") -- implementation
  vim.keymap.del("n", "gO")  -- document symbols
  vim.keymap.del("n", "grn") -- rename
end

-- custom global variables
vim.g.solutionfmt = {
  ["begin"] = "@solution begin",
  ["end"] = "@solution end"
}
---@type "nightfox" | "dayfox" | "dawnfox" | "duskfox" | "nordfox" | "terafox" | "carbonfox"
vim.g.nightfox_flavour = "nordfox"
---@type "none" | "single" | "rounded" | "solid" | "shadow"
vim.g.float_border_style = "single"
vim.g.signs = {
  Error = "",
  Warn = "",
  Hint = "",
  Info = "",
}
vim.g.transparent = vim.env["TERM_TRANSPARENT"] ~= nil

vim.opt.cmdheight = 0
vim.opt.laststatus = 3

require("lazy").setup("plugins", {
  change_detection = {
    enabled = false,
  },
  performance = {
    cache = { enabled = true },
    rtp = {
      reset = true,
      disabled_plugins = {
        "tutor",
        "netrwPlugin"
      },
    },
    readme = {
      enabled = false
    }
  },
})

vim.g.c_syntax_for_h = 1 -- assume .h files are c, not c++
vim.opt.guicursor = "i-n-v-c-sm:block,ci-ve:ver25,r-cr-o:hor20" -- block cursor in insert
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.virtualedit = "block"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.wrap = false
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.smartcase = true
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.sidescrolloff = 3
vim.opt.scrolloff = 1
vim.opt.history = 100
vim.opt.showmode = false
vim.opt.synmaxcol = 360
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

require("config.autocmds")

-- load config after loading all UI elements
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    require("config.commands")
    require("config.maps")
  end,
})
