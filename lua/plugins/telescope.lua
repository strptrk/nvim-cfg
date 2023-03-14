return {
  {
    'nvim-telescope/telescope.nvim',
    lazy = true,
    cmd = 'Telescope',
    dependencies = {
      { 'nvim-lua/plenary.nvim', lazy = true },
      { 'ThePrimeagen/harpoon', lazy = true },
    },
    config = function()
      local telescope = require('telescope')
      telescope.load_extension('harpoon')
      telescope.setup()
    end,
  },
}
