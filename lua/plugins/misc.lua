return {
  {
    "echasnovski/mini.surround",
    version = false,
    lazy = true,
    keys = {
      { "sa", nil, mode = { "n", "x" } },
      { "sd", nil, mode = { "n", "x" } },
      { "sr", nil, mode = { "n", "x" } },
      { "sur", nil, mode = { "n", "x" } },
      { "sul", nil, mode = { "n", "x" } },
      { "suh", nil, mode = { "n", "x" } },
      { "sun", nil, mode = { "n", "x" } },
    },
    opts = {
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "sd", -- Delete surrounding
        replace = "sr", -- Replace surrounding
        find = "sur", -- Find surrounding (to the right)
        find_left = "sul", -- Find surrounding (to the left)
        highlight = "suh", -- Highlight surrounding
        update_n_lines = "sun", -- Update `n_lines`
        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
      n_lines = 20, -- Number of lines within which surrounding is searched
      respect_selection_type = false,
      custom_surroundings = {
        -- by default, left {parentheses, brackets, tags, braces} add spaces and right ones don't, swap that
        [')'] = { output = { left = '( ', right = ' )' } },
        ['('] = { output = { left = '(', right = ')' } },
        ['>'] = { output = { left = '< ', right = ' >' } },
        ['<'] = { output = { left = '<', right = '>' } },
        ['{'] = { output = { left = '{', right = '}' } },
        ['}'] = { output = { left = '{ ', right = ' }' } },
        -- never add spaces for []
        ['['] = { output = { left = '[', right = ']' } },
        [']'] = { output = { left = '[', right = ']' } },
      }
    },
  },
  {
    "junegunn/vim-easy-align",
    lazy = true,
    cmd = { "EasyAlign" },
    keys = {
      { "<Space>E", ":EasyAlign<cr>*<Space>", mode = { "n", "v" } },
      { "<Space>e", "<Plug>(EasyAlign)", mode = { "n", "v" } },
    },
  },
  {
    "Shatur/neovim-session-manager",
    lazy = true,
    cmd = {
      "SessionManager",
    },
    init = function()
      vim.api.nvim_create_user_command("SaveSession", "SessionManager save_current_session", { force = true })
      vim.api.nvim_create_user_command("LoadSession", "SessionManager load_session", { force = true })
      vim.api.nvim_create_user_command("LastSession", "SessionManager load_last_session", { force = true })
    end,
    config = function()
      require("session_manager").setup({
        sessions_dir = require("plenary.path"):new(vim.fn.stdpath("data"), "sessions"),
        path_replacer = "__",
        colon_replacer = "++",
        autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
        autosave_last_session = true,
        autosave_ignore_not_normal = true,
        autosave_ignore_filetypes = {
          "gitcommit",
        },
        autosave_only_in_session = true,
        max_path_length = 80,
      })
    end,
  },
  {
    -- TODO: replace with builtin commenting from v0.10
    "numToStr/Comment.nvim",
    lazy = true,
    event = "VeryLazy",
    opts = {
      padding = true,
      sticky = true,
      ignore = "^$",
      toggler = { line = "<Space>cc", block = "<Space>cx" },
      opleader = { line = "<Space>c", block = "<Space>x" },
      mappings = { basic = true, extra = true, extended = false },
    },
  },
  {
    "samjwill/nvim-unception",
    lazy = false,
    init = function()
      ---@diagnostic disable-next-line: inject-field
      vim.g.unception_open_buffer_in_new_tab = true
      ---@diagnostic disable-next-line: inject-field
      vim.g.unception_enable_flavor_text = false
    end,
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "windwp/nvim-autopairs",
    lazy = true,
    event = "InsertEnter",
    opts = {},
  },
  {
    "phaazon/hop.nvim",
    lazy = true,
    init = function()
      vim.keymap.set({ "n", "x" }, "<Space><CR>", function()
        require("hop").hint_words()
      end)
      vim.keymap.set({ "n", "x" }, "<Space><BS>", function()
        require("hop").hint_lines()
      end)
      vim.keymap.set({ "n", "x", "o" }, "f", function()
        require("hop").hint_char1({
          direction = require("hop.hint").HintDirection.AFTER_CURSOR,
          current_line_only = true,
        })
      end)
      vim.keymap.set({ "n", "x", "o" }, "F", function()
        require("hop").hint_char1({
          direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
          current_line_only = true,
        })
      end)
      vim.keymap.set({ "n", "x", "o" }, "t", function()
        require("hop").hint_char1({
          direction = require("hop.hint").HintDirection.AFTER_CURSOR,
          current_line_only = true,
          hint_offset = -1,
        })
      end)
      vim.keymap.set({ "n", "x", "o" }, "T", function()
        require("hop").hint_char1({
          direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
          current_line_only = true,
          hint_offset = -1,
        })
      end)
    end,
    config = function()
      require("hop").setup()
    end,
  },
}
