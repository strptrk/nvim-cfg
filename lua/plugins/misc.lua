return {
  {
    "echasnovski/mini.surround",
    version = false,
    lazy = true,
    keys = {
      { "sa",  nil, mode = { "n", "x" }, desc = "Surround: Add" },
      { "sd",  nil, mode = { "n", "x" }, desc = "Surround: Delete" },
      { "sr",  nil, mode = { "n", "x" }, desc = "Surround: Replace" },
      { "sur", nil, mode = { "n", "x" }, desc = "Surround: Find to the right" },
      { "sul", nil, mode = { "n", "x" }, desc = "Surround: Find to the left" },
      { "suh", nil, mode = { "n", "x" }, desc = "Surround: Hightlight" },
      { "sun", nil, mode = { "n", "x" }, desc = "Surround: Update searched line count" },
    },
    config = function()
      local minisurround = require("mini.surround")
      minisurround.setup({
        mappings = {
          add = "sa",             -- Add surrounding in Normal and Visual modes
          delete = "sd",          -- Delete surrounding
          replace = "sr",         -- Replace surrounding
          find = "sur",           -- Find surrounding (to the right)
          find_left = "sul",      -- Find surrounding (to the left)
          highlight = "suh",      -- Highlight surrounding
          update_n_lines = "sun", -- Update `n_lines`
          suffix_last = "l",      -- Suffix to search with "prev" method
          suffix_next = "n",      -- Suffix to search with "next" method
        },
        n_lines = 20,             -- Number of lines within which surrounding is searched
        respect_selection_type = false,
        custom_surroundings = {
          -- by default, left {parentheses, brackets, tags, braces} add spaces and right ones don't, swap that
          [")"] = { output = { left = "( ", right = " )" } },
          ["("] = { output = { left = "(", right = ")" } },
          [">"] = { output = { left = "< ", right = " >" } },
          ["<"] = { output = { left = "<", right = ">" } },
          ["{"] = { output = { left = "{", right = "}" } },
          ["}"] = { output = { left = "{ ", right = " }" } },
          ["["] = { output = { left = "[", right = "]" } },
          ["]"] = { output = { left = "[ ", right = " ]" } },
          -- [d]ouble brackets
          ["d"] = { output = { left = "[[", right = "]]" } },
          -- [D]ouble brackets, with whitespace
          ["D"] = { output = { left = "[[ ", right = " ]]" } },
          -- by default, b adds (), change it to p and b to {}
          ["b"] = { output = { left = "{", right = "}" } },
          ["p"] = { output = { left = "(", right = ")" } },
          -- escaped [Q]uotes
          ["Q"] = { output = { left = '\\"', right = '\\"' } },
          -- [o]utput (shell)
          ["o"] = { output = { left = "$(", right = ")" } },
          -- [v]alue (shell)
          ["v"] = { output = { left = '"${', right = '}"' } },
          -- [l]ua function
          ["l"] = { output = { left = "function() ", right = " end" } },
          -- python type [h]int, like `str` -> `Optional[str]`
          ["h"] = {
            output = function()
              local type = minisurround.user_input("Type Hint")
              return { left = type .. "[", right = "]" }
            end,
          },
          -- [i]nteractive
          ["i"] = {
            output = function()
              local s = minisurround.user_input("Surrounding")
              return { left = s, right = s }
            end,
          },
          -- interactive with [w]hitespace
          ["w"] = {
            output = function()
              local s = minisurround.user_input("Surrounding")
              if not s then
                return {}
              end
              return { left = s .. " ", right = " " .. s }
            end,
          },
        },
      })
    end,
  },
  {
    "echasnovski/mini.operators",
    version = false,
    keys = {
      { "g=",  nil, mode = { "n", "x" } },
      { "gx",  nil, mode = { "n", "x" } },
      { "gm",  nil, mode = { "n", "x" } },
      { "X",   nil, mode = { "n", "x" } },
      { "gss", nil, mode = { "n", "x" } },
    },
    opts = {
      evaluate = { -- Evaluate text and replace with output
        prefix = "g=",
        func = nil,
      },
      exchange = { -- Exchange text regions
        prefix = "gx",
        reindent_linewise = true,
      },
      multiply = { -- Multiply (duplicate) text
        prefix = "gm",
        func = nil,
      },
      replace = { -- Replace text with register
        prefix = "X",
        reindent_linewise = true,
      },
      sort = { -- Sort text
        prefix = "gss",
        func = nil,
      },
    },
  },
  {
    "echasnovski/mini.ai",
    version = false,
    lazy = true,
    event = { "BufAdd", "BufNewFile", "BufReadPost" },
    config = function()
      local gen_spec = require("mini.ai").gen_spec
      require("mini.ai").setup({
        custom_textobjects = {
          -- use treesitter's instead
          a = false,
          f = false,
          -- `j` instead of `f` as it is reserved for treesitter
          j = gen_spec.function_call(),
          -- whole buffer
          g = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line("$"),
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
        },
        mappings = {
          around      = "a",
          inside      = "i",
          around_next = "", -- an
          inside_next = "", -- in
          around_last = "", -- al
          inside_last = "", -- il
          goto_left   = "g[",
          goto_right  = "g]",
        },
        n_lines = 50,
        ---@type "cover" | "cover_or_next" | "cover_or_prev" | "cover_or_nearest" | "next" | "previous" | "nearest"
        search_method = "cover_or_next",
        silent = false,
      })
    end,
  },
  {
    "echasnovski/mini.align",
    lazy = true,
    version = false,
    keys = {
      { "ga", nil, mode = { "n", "x" } },
      { "gA", nil, mode = { "n", "x" } },
    },
    opts = {},
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
    "numToStr/Comment.nvim",
    lazy = true,
    keys = {
      { "<Space>c",  nil, mode = { "n", "x", "o" }, desc = "Comment linewise" },
      { "<Space>x",  nil, mode = { "n", "x", "o" }, desc = "Comment blockwise" },
      { "<Space>cc", nil, mode = "n",               desc = "Comment linewise" },
      { "<Space>cx", nil, mode = "n",               desc = "Comment linewise" },
      { "<Space>cO", nil, mode = "n",               desc = "Comment line above" },
      { "<Space>co", nil, mode = "n",               desc = "Comment line below" },
      { "<Space>cl", nil, mode = "n",               desc = "Comment end of line" },
    },
    opts = {
      padding = true,
      sticky = true,
      ignore = "^$",
      toggler = { line = "<Space>cc", block = "<Space>cx" },
      opleader = { line = "<Space>c", block = "<Space>x" },
      extra = { above = "<Space>cO", below = "<Space>co", eol = "<Space>cl" },
      mappings = { basic = true, extra = true, extended = false },
    },
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "windwp/nvim-autopairs",
    lazy = true,
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "spectre_panel", "dap-repl" },
    },
  },
  {
    -- TODO replace (unmaintained)
    "phaazon/hop.nvim",
    lazy = true,
    init = function()
      vim.keymap.set({ "n", "x" }, "<Space><CR>", function()
        require("hop").hint_words()
      end, { desc = "Hop Word" })
      vim.keymap.set({ "n", "x" }, "<Space><BS>", function()
        require("hop").hint_lines()
      end, { desc = "Hop Lines" })
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
