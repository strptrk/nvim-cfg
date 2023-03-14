return {
  {
    'ms-jpq/chadtree',
    branch = 'chad',
    cmd = 'CHADopen',
    lazy = true,
    init = function()
      vim.g.chadtree_settings = {
        view = { width = 26 },
        keymap = {
          tertiary = { '<A-t>' },
          v_split = { 'wv' },
          h_split = { 'wh' },
        },
        ignore = {
          name_glob = { [[.*]] },
        },
      }
    end,
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'CHADTree',
        callback = function()
          vim.keymap.set('n', '?', ':CHADhelp keybind<CR>')
        end,
      })
    end,
  },
}
