-- treesitter parser names and their respective filetypes are not always the same
local ts_parsers = {
  "c",
  "cpp",
  "rust",
  "python",
  "go",
  "lua",
  "perl",
  "awk",
  "bash",
  "toml",
  "yaml",
  "json",
  "markdown",
  "cmake",
  "make",
  "meson",
  "ninja",
  "dockerfile",
  "html",
  "css",
  "scss",
  "sql",
  "git_rebase",
  "gitcommit",
  "gitignore",
  "gitattributes",
  "diff",
  "latex",
  "comment",
  "regex",
  "vim"
}

local ts_filetypes = {
  "c",
  "cpp",
  "rust",
  "python",
  "go",
  "lua",
  "perl",
  "awk",
  "bash",
  "zsh",
  "sh",
  "toml",
  "yaml",
  "json",
  "markdown",
  "cmake",
  "make",
  "meson",
  "ninja",
  "dockerfile",
  "html",
  "css",
  "scss",
  "sql",
  "git_rebase",
  "gitcommit",
  "gitignore",
  "gitattributes",
  "diff",
  "latex",
  "tex",
}

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    lazy = true, -- no config, has to be loaded after TS
    ft = ts_filetypes,
    keys = {
      { "<A-I>", "<cmd>IBLToggle<cr>", desc = "Toggle Indent Lines" },
    },
    cmd = {
      "IBLToggle",
      "IBLToggleScope",
    },
    opts = {
      indent = {
        char = "│",
      },
      scope = {
        enabled = false,
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "trouble",
          "lazy",
          "neo-tree",
          "terminal",
          "nofile",
          "norg",
          "text",
          "",
        },
      },
    },
  },
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
    lazy = true,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    build = ":TSUpdate",
    cmd = {
      "TSInstall",
      "TSUpdate",
      "TSBufEnable",
      "TSBufToggle",
      "TSEnable",
      "TSBufToggle",
      "TSToggle",
    },
    ft = ts_filetypes,
    keys = {
      { "<A-S>", "<cmd>TSToggle refactor.highlight_current_scope<cr>", desc = "Toggle Current Scope" },
    },
    dependencies = {
      {
        "andymass/vim-matchup",
        lazy = true,
        init = function()
          vim.g.matchup_matchparen_deferred_show_delay = 100
          vim.g.matchup_matchparen_deferred_hide_delay = 100
          vim.g.matchup_matchparen_timeout = 20
          vim.g.matchup_matchparen_insert_timeout = 20
          vim.g.matchup_matchparen_deferred = 1
          vim.g.matchup_matchparen_nomode = 'i'
          vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
      },
      {
        "Wansmer/treesj",
        lazy = true,
        cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
        keys = {
          { "<Space>j", "<cmd>TSJToggle<cr>", desc = "Toggle Block Split" },
        },
        config = function()
          require("treesj").setup({
            use_default_keymaps = false,
            check_syntax_error = true,
            max_join_length = 240,
            cursor_behavior = "hold",
            notify = true,
            -- langs = {},
          })
        end,
      },
      { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },
      {
        "nvim-treesitter/nvim-treesitter-context",
        lazy = true,
        config = function()
          require("treesitter-context").setup({
            enable = true,
            max_lines = 0,
            trim_scope = "outer",
            patterns = {
              default = {
                "class",
                "function",
                "method",
                "for",
                "while",
                "if",
                "switch",
                "case",
              },
            },
            exact_patterns = {},
            zindex = 20,
            mode = "cursor",
            separator = nil,
          })
        end,
      },
      {
        "nvim-treesitter/nvim-treesitter-refactor",
        lazy = true,
        config = function()
          require("nvim-treesitter-refactor")
        end,
      },
    },
    config = function()
      vim.treesitter.language.register("bash", "sh")
      vim.treesitter.language.register("bash", "zsh")
      require("nvim-treesitter.configs").setup({
        ensure_installed = ts_parsers,
        highlight = {
          enable = true,
          disable = require("cfg.utils").file_too_big(128),
        },
        indent = {
          enable = false,
        },
        autopairs = {
          enable = false,
        },
        rainbow = {
          enable = false,
          extended_mode = true,
        },
        refactor = {
          navigation = {
            enable = true,
            disable = require("cfg.utils").file_too_big(128),
            keymaps = {
              goto_definition = "gsd",
              goto_next_usage = "]u",
              goto_previous_usage = "[u",
              list_definitions = "gso",
              list_definitions_toc = "gsO",
            },
          },
          highlight_definitions = {
            enable = false,
            disable = require("cfg.utils").file_too_big(64),
            clear_on_cursor_move = true,
          },
          highlight_current_scope = {
            enable = false,
          },
          smart_rename = {
            disable = require("cfg.utils").file_too_big(128),
            enable = true,
            keymaps = {
              smart_rename = "st",
            },
          },
        },
        textobjects = {
          select = {
            enable = true,
            disable = require("cfg.utils").file_too_big(128),
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              ["as"] = "@statement.outer",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ax"] = "@block.outer",
              ["ix"] = "@block.inner",
              ["ak"] = "@comment.outer",
              ["ik"] = "@comment.outer",
              ["ia"] = { query = "@parameter.inner" },
              ["aa"] = { query = "@parameter.outer" },
            },
            selection_modes = {
              ["@class.outer"] = "V",
            },
          },
          swap = {
            enable = true,
            disable = require("cfg.utils").file_too_big(128),
            swap_next = { ["L"] = "@parameter.inner" },
            swap_previous = { ["H"] = "@parameter.inner" },
          },
          move = {
            enable = true,
            disable = require("cfg.utils").file_too_big(128),
            set_jumps = true,
            goto_next_start = {
              ["]f"] = { query = "@function.outer", desc = "Next function start" },
              ["]c"] = { query = "@class.outer", desc = "Next class start" },
              ["]l"] = { query = "@loop.*", desc = "Next loop" },
              ["]s"] = { query = "@statement", desc = "Next statement" },
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
              ["]a"] = { query = "@parameter.inner", desc = "Next parameter" },
              ["]r"] = { query = "@regex.inner", desc = "Next regex" },
              ["]R"] = { query = "@return.inner", desc = "Next return" },
              ["]k"] = { query = "@comment.outer", desc = "Next comment" },
              ["]n"] = { query = "@number.*", desc = "Next number" },
              ["]b"] = { query = "@block", desc = "Next block" }, -- block instead of scope
              ["]i"] = { query = "@conditional.inner", desc = "Next conditional" },
              ["]h"] = { query = "@call.outer", desc = "Next call" },
            },
            goto_next_end = {
              ["]F"] = { query = "@function.outer", desc = "Next function end" },
              ["]C"] = { query = "@class.outer", desc = "Next class end" },
              ["]B"] = { query = "@block.outer", desc = "Next block end" },
            },
            goto_previous_start = {
              ["[f"] = { query = "@function.outer", desc = "Previous function start" },
              ["[c"] = { query = "@class.outer", desc = "Previous class start" },
              ["[l"] = { query = "@loop.*", desc = "Previous loop" },
              ["[s"] = { query = "@statement", desc = "Previous statement" },
              ["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
              ["[a"] = { query = "@parameter.inner", desc = "Previous parameter" },
              ["[r"] = { query = "@regex.inner", desc = "Previous regex" },
              ["[R"] = { query = "@return.inner", desc = "Previous return" },
              ["[k"] = { query = "@comment.outer", desc = "Previous comment" },
              ["[n"] = { query = "@number.*", desc = "Previous number" },
              ["[b"] = { query = "@block", desc = "Previous block" },
              ["[i"] = { query = "@conditional.inner", desc = "Previous conditional" },
              ["[h"] = { query = "@call.outer", desc = "Previous call" },
            },
            goto_previous_end = {
              ["[F"] = { query = "@function.outer", desc = "Previous function end" },
              ["[C"] = { query = "@class.outer", desc = "Previous class end" },
              ["[B"] = { query = "@block.outer", desc = "Previous block end" },
            },
          },
          lsp_interop = {
            enable = false,
            border = "single",
            floating_preview_opts = {},
            peek_definition_code = {
              -- ["<Space>pf"] = "@function.outer",
              -- ["<Space>pc"] = "@class.outer",
            },
          },
        },
        playground = {
          enable = false,
          disable = require("cfg.utils").file_too_big(128),
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
          },
        },
        matchup = {
          enable = true,
          disable = {},
        },
      })
    end,
  },
  {
    "cshuaimin/ssr.nvim",
    lazy = true,
    ft = ts_filetypes,
    keys = {
      { "<Space>sr", function() require("ssr").open() end, mode = { "x", "n" }, desc = "Structural Search & Replace" }
    },
    opts = {}
  }
}
