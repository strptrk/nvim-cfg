return {
  { 'machakann/vim-sandwich' },
  { 'junegunn/vim-easy-align' },
  { 'matze/vim-move' },
  {
    'Shatur/neovim-session-manager',
    config = function()
      local Path = require('plenary.path')
      require('session_manager').setup({
        sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'),
        path_replacer = '__',
        colon_replacer = '++',
        autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
        autosave_last_session = true,
        autosave_ignore_not_normal = true,
        autosave_ignore_filetypes = {
          'gitcommit',
        },
        autosave_only_in_session = false,
        max_path_length = 80,
      })
    end
  },
  {
    'numToStr/Comment.nvim',
    lazy = true,
    event = "BufEnter",
    config = function()
      require('Comment').setup({
        padding = true,
        sticky = true,
        ignore = '^$',
        toggler = { line = '<Space>cc', block = '<Space>cx' },
        opleader = { line = '<Space>c', block = '<Space>x' },
        extra = { above = '<Space>O', below = '<Space>o', eol = '<Space>A' },
        mappings = { basic = true, extra = true, extended = false },
        pre_hook = function() end,
        post_hook = function() end,
      })
    end

  },
  {
    'samjwill/nvim-unception',
    init = function()
      vim.g.unception_open_buffer_in_new_tab = true
      vim.g.unception_enable_flavor_text = false
    end,
  },
  {
    'nvim-lua/plenary.nvim',
    lazy = true,
  },
  {
    'ZhiyuanLck/smart-pairs',
    lazy = true,
    event = 'InsertEnter',
    config = function()
      require('pairs'):setup({ enter = { enable_mapping = false } })
    end
  },
  {
    'phaazon/hop.nvim',
    lazy = true,
    config = function()
      require('hop').setup()
    end
  },
  {
    'AllenDang/nvim-expand-expr',
    lazy = true,
  },
  {
    "elkowar/yuck.vim",
    lazy = true,
    ft = "yuck"
  },
  {
    'strptrk/clangwarningparser.nvim',
    lazy = true,
    config = function()
      require('clangwarningparser').setup({
        float_opts = {
          width_percentage = 90,
          height_percentage = 75,
          border = 'rounded',
        },
        open_on_load = true,
        center_on_select = true,
        root_env = 'WS_ROOT',
        root_cd = true,
        map_defaults = false,
        keymaps = {
          preview = 'o',
          select_entry = '<CR>',
          toggle_win = '<leader>w',
          quit_preview = 'q',
          toggle_done = { 'd', '<tab>' },
        },
      })
    end,
    init = function()
      vim.keymap.set('n', '<leader>w', function()
        require('clangwarningparser').Open()
      end)
    end
  }
}
