------------------
------ LAZY ------
------------------

---@diagnostic disable-next-line: undefined-field
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
        'tohtml',
        'tutor',
      },
    },
  },
})

local opt = vim.opt

opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.syntax = 'enable'
opt.virtualedit = 'block'
opt.number = true
opt.relativenumber = false
opt.cursorline = false
opt.linebreak = true
opt.wrap = false
opt.showmatch = true
opt.colorcolumn = '0'
opt.signcolumn = 'yes'
opt.splitright = true
opt.splitkeep = "screen"
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.expandtab = true
opt.autoindent = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.conceallevel = 2
opt.sidescrolloff = 1
opt.scrolloff = 1
opt.completeopt = 'menuone,noselect'
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
opt.ruler = true
opt.hidden = true
opt.history = 100
opt.lazyredraw = false
opt.synmaxcol = 240
opt.showmode = false

-- revert back to vim's block cursor in insert mode as a default
opt.guicursor = "i-n-v-c-sm:block,ci-ve:ver25,r-cr-o:hor20"

-- lower updatetime to trigger treesitter-refactor's token highlight
-- swapfile directory changed to ramfs to avoid excessive disk writes
-- but nvim will not be able to recover after a power outage
opt.updatetime = 750
vim.api.nvim_set_option_value('directory', '/tmp/nvimswap//', { scope = "global" })

---@diagnostic disable-next-line: inject-field
vim.g.c_syntax_for_h = 1

-- abbreviations
vim.cmd([[
  cnoreabbrev qt tabclose
  cnoreabbrev qq q!
  cnoreabbrev qqa qa!
  cnoreabbrev SL s/\ /\ \\\r/g
]])

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require("config.utils")
    require("config.autocmds")
    require("config.maps")
  end,
})

vim.api.nvim_create_user_command('Diff', function(args)
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

vim.api.nvim_create_user_command("Mktmpf", function (args)
  math.randomseed(os.time())
  local dname = '/tmp/tmpdir_nvim_' .. tostring(math.random(100000,999999))
  local fname = 'main.' .. args.fargs[1]
  os.execute('mkdir -p ' .. dname)
  vim.cmd('cd ' .. dname)
  vim.cmd('e ' .. fname)
end, { nargs = 1 })
