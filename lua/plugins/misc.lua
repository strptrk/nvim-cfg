return {
  {
    -- TODO: maybe replace?
    lazy = true,
    event = { 'VeryLazy' },
    'machakann/vim-sandwich',
  },
  {
    lazy = true,
    event = { 'VeryLazy' },
    'junegunn/vim-easy-align',
  },
  {
    'Shatur/neovim-session-manager',
    lazy = true,
    cmd = {
      'SessionManager',
    },
    init = function()
      vim.api.nvim_create_user_command('SaveSession', "SessionManager save_current_session", { force = true })
      vim.api.nvim_create_user_command('LoadSession', "SessionManager load_session", { force = true })
      vim.api.nvim_create_user_command('LastSession', "SessionManager load_last_session", { force = true })
    end,
    config = function()
      require('session_manager').setup({
        sessions_dir = require('plenary.path'):new(vim.fn.stdpath('data'), 'sessions'),
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
    event = 'VeryLazy',
    opts = {
      padding = true,
      sticky = true,
      ignore = '^$',
      toggler = { line = '<Space>cc', block = '<Space>cx' },
      opleader = { line = '<Space>c', block = '<Space>x' },
      extra = { above = '<Space>O', below = '<Space>o', eol = '<Space>e' },
      mappings = { basic = true, extra = true, extended = false },
      pre_hook = function() end,
      post_hook = function() end,
    }
  },
  {
    'samjwill/nvim-unception',
    lazy = false,
    init = function()
      ---@diagnostic disable-next-line: inject-field
      vim.g.unception_open_buffer_in_new_tab = true
      ---@diagnostic disable-next-line: inject-field
      vim.g.unception_enable_flavor_text = false
    end,
  },
  {
    'nvim-lua/plenary.nvim',
    lazy = true,
  },
  {
    'echasnovski/mini.pairs',
    version = false,
    lazy = true,
    event = 'InsertEnter',
    config = function()
      require('mini.pairs').setup()
    end
  },
  {
    'phaazon/hop.nvim',
    lazy = true,
    init = function()
      vim.keymap.set({ 'n', 'x' }, '<Space><CR>', function()
        require('hop').hint_words()
      end)
      vim.keymap.set({ 'n', 'x' }, '<Space><BS>', function()
        require('hop').hint_lines()
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, 'f', function()
        require('hop').hint_char1({
          direction = require('hop.hint').HintDirection.AFTER_CURSOR,
          current_line_only = true,
        })
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', function()
        require('hop').hint_char1({
          direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
          current_line_only = true,
        })
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, 't', function()
        require('hop').hint_char1({
          direction = require('hop.hint').HintDirection.AFTER_CURSOR,
          current_line_only = true,
          hint_offset = -1,
        })
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', function()
        require('hop').hint_char1({
          direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
          current_line_only = true,
          hint_offset = -1,
        })
      end)
    end,
    config = function()
      require('hop').setup()
    end
  },
  {
    "elkowar/yuck.vim",
    lazy = true,
    ft = "yuck"
  },
}
