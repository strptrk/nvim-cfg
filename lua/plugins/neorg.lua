return {
  {
    'nvim-neorg/neorg',
    lazy = true,
    ft = 'norg',
    config = function()
      vim.keymap.set('n', '<A-r>', '<cmd>Neorg toggle-concealer<CR>')
      vim.api.nvim_create_user_command('Present', 'Neorg presenter start', { force = true })
      vim.o.wrap = false
      require('neorg').setup({
        load = {
          ['core.defaults'] = {},
          ['core.norg.concealer'] = {
            config = {
              folds = false,
              conceal = false,
              adaptive = false,
            },
          },
          ['core.norg.dirman'] = {},
          ['core.norg.qol.toc'] = {},
          ['core.presenter'] = {
            config = {
              zen_mode = 'truezen',
            },
          },
          ['core.export'] = {},
          ['core.export.markdown'] = {},
          ['core.norg.manoeuvre'] = {},
        },
      })
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
  },
}
