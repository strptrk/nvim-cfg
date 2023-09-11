vim.g.ts_installed = {
  'bash', 'norg', 'c', 'cpp', 'rust', 'python',
  'lua', 'json', 'markdown', 'markdown_inline',
  'comment', 'awk', 'cmake',
  "css", "diff", "dockerfile", "fennel",
  "git_rebase", "gitcommit", "gitignore", "gitattributes",
  "go", "jq", "latex", "make", "meson", "ninja", "perl",
  "regex", "scss", "html", "sql", "toml", "yaml",
}

vim.g.ts_ft = {
  'bash', 'norg', 'c', 'cpp', 'rust', 'python',
  'lua', 'json', 'markdown', 'markdown_inline',
  'comment', 'awk', 'cmake',
  "css", "diff", "dockerfile", "fennel",
  "git_rebase", "gitcommit", "gitignore", "gitattributes",
  "go", "jq", "latex", "tex", "make", "meson", "ninja", "perl",
  "regex", "scss", "html", "sql", "toml", "yaml",
}

vim.g.max_filesize = 300;

return {
  {
    'lukas-reineke/indent-blankline.nvim',
    lazy = true, -- no config, has to be loaded after TS
    ft = vim.g.ts_ft,
    keys = {
      { '<A-I>', '<cmd>IndentBlanklineToggle<cr>', desc = 'Toggle Indent Lines' },
    },
    cmd = {
      'IndentBlanklineToggle',
    },
    config = function()
      require('indent_blankline').setup({
        -- char = '·',
        buftype_exclude = { 'terminal', 'nofile', 'norg', 'text', '' },
        use_treesitter = true,
        enabled = false,
        show_current_context = true,
        show_current_context_start = false,
        char_highlight_list = {
          'Comment',
        },
        show_trailing_blankline_indent = false,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    cmd = { 'TSInstall', 'TSUpdate' },
    ft = vim.g.ts_ft,
    keys = {
      { '<A-S>', '<cmd>TSToggle refactor.highlight_current_scope<cr>', desc = 'Toggle Current Scope' },
    },
    lazy = true,
    dependencies = {
      { 'nvim-treesitter/playground',                  lazy = true },
      {
        'andymass/vim-matchup',
        lazy = true,
        init = function()
          vim.g.matchup_matchparen_offscreen = { method = 'popup' }
        end,
      },
      {
        'Wansmer/treesj',
        lazy = true,
        cmd = { 'TSJToggle', 'TSJSplit', 'TSJJoin' },
        keys = {
          { '<Space>j', '<cmd>TSJToggle<cr>', desc = 'Toggle Block Split' },
        },
        config = function()
          require('treesj').setup({
            use_default_keymaps = false,
            check_syntax_error = true,
            max_join_length = 120,
            cursor_behavior = 'hold',
            notify = true,
            -- langs = {},
          })
        end,
      },
      { 'nvim-treesitter/nvim-treesitter-textobjects', lazy = true },
      {
        'nvim-treesitter/nvim-treesitter-context',
        lazy = true,
        config = function()
          require('treesitter-context').setup({
            enable = true,
            max_lines = 0,
            trim_scope = 'outer',
            patterns = {
              default = {
                'class',
                'function',
                'method',
                'for',
                'while',
                'if',
                'switch',
                'case',
              },
            },
            exact_patterns = {},
            zindex = 20,
            mode = 'cursor',
            separator = nil,
          })
        end,
      },
      {
        'simrat39/symbols-outline.nvim',
        lazy = true,
        cmd = { 'SymbolsOutlineOpen', 'SymbolsOutline' },
        keys = {
          { 'so', '<cmd>SymbolsOutline<CR>' },
        },
        config = function()
          require('symbols-outline').setup()
          vim.api.nvim_create_autocmd('FileType', {
            pattern = 'Outline',
            callback = function()
              vim.wo.cursorline = true
            end,
          })
        end,
      },
      -- {
      --   'stevearc/aerial.nvim',
      --   lazy = true,
      --   cmd = { 'AerialOpen', 'AerialToggle', 'AerialNavToggle', 'AerialNavOpen' },
      --   keys = {
      --     { 'so', '<cmd>AerialOpen<CR>' },
      --   },
      --   config = function()
      --     require('aerial').setup({
      --       backends = { "treesitter", "lsp", "markdown", "man" },
      --     })
      --     vim.api.nvim_create_autocmd('FileType', {
      --       pattern = 'aerial',
      --       callback = function()
      --         vim.wo.cursorline = true
      --       end,
      --     })
      --   end,
      -- },
      {
        'nvim-treesitter/nvim-treesitter-refactor',
        lazy = true,
        config = function()
          require('nvim-treesitter-refactor')
        end,
      },
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = vim.g.ts_installed,
        highlight = {
          enable = true,
          disable = vim.g.file_too_big(vim.g.max_filesize)
        },
        indent = { enable = false },
        autopairs = { enable = true },
        rainbow = { enable = false, extended_mode = true },
        refactor = {
          disable = vim.g.file_too_big(vim.g.max_filesize),
          navigation = {
            enable = true,
            keymaps = {
              goto_definition = "gsd",
              goto_next_usage = 'gsn',
              goto_previous_usage = 'gsp',
              list_definitions = "gso",
              list_definitions_toc = "gsO",
            },
          },
          highlight_definitions = {
            enable = true,
            disable = vim.g.file_too_big(vim.g.max_filesize),
            clear_on_cursor_move = true,
          },
          highlight_current_scope = {
            enable = false,
          },
          smart_rename = {
            enable = true,
            disable = vim.g.file_too_big(vim.g.max_filesize),
            keymaps = {
              smart_rename = 'st',
            },
          },
        },
        textobjects = {
          select = {
            enable = true,
            disable = vim.g.file_too_big(vim.g.max_filesize),
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['al'] = '@loop.outer',
              ['il'] = '@loop.inner',
              ['as'] = '@statement.outer',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['ax'] = '@block.outer',
              ['ix'] = '@block.inner',
              ['ak'] = '@comment.outer',
              ['ik'] = '@comment.outer',
              ['ia'] = { query = '@parameter.inner' },
              ['aa'] = { query = '@parameter.outer' },
            },
            selection_modes = {
              ['@class.outer'] = 'V',
            },
          },
          swap = {
            enable = true,
            swap_next = { ['<C-l>'] = '@parameter.inner' },
            swap_previous = { ['<C-h>'] = '@parameter.inner' },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']f'] = { query = '@function.outer', desc = 'Next function start' },
              [']c'] = { query = '@class.outer', desc = 'Next class start' },
              [']l'] = { query = '@loop.*', desc = 'Next loop' },
              [']s'] = { query = '@statement', desc = 'Next statement' },
              [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
              [']a'] = { query = '@parameter.inner', desc = 'Next parameter' },
              [']r'] = { query = '@regex.inner', desc = 'Next regex' },
              [']R'] = { query = '@return.inner', desc = 'Next return' },
              [']k'] = { query = '@comment.outer', desc = 'Next comment' },
              [']n'] = { query = '@number.*', desc = 'Next number' },
              [']b'] = { query = '@block', desc = 'Next block' }, -- block instead of scope
              [']i'] = { query = '@conditional.inner', desc = 'Next conditional' },
              [']h'] = { query = '@call.outer', desc = 'Next call' },
            },
            goto_next_end = {
              [']F'] = { query = '@function.outer', desc = 'Next function end' },
              [']C'] = { query = '@class.outer', desc = 'Next class end' },
              [']B'] = { query = '@block.outer', desc = 'Next block end' },
            },
            goto_previous_start = {
              ['[f'] = { query = '@function.outer', desc = 'Previous function start' },
              ['[c'] = { query = '@class.outer', desc = 'Previous class start' },
              ['[l'] = { query = '@loop.*', desc = 'Previous loop' },
              ['[s'] = { query = '@statement', desc = 'Previous statement' },
              ['[z'] = { query = '@fold', query_group = 'folds', desc = 'Previous fold' },
              ['[a'] = { query = '@parameter.inner', desc = 'Previous parameter' },
              ['[r'] = { query = '@regex.inner', desc = 'Previous regex' },
              ['[R'] = { query = '@return.inner', desc = 'Previous return' },
              ['[k'] = { query = '@comment.outer', desc = 'Previous comment' },
              ['[n'] = { query = '@number.*', desc = 'Previous number' },
              ['[b'] = { query = '@block', desc = 'Previous block' },
              ['[i'] = { query = '@conditional.inner', desc = 'Previous conditional' },
              ['[h'] = { query = '@call.outer', desc = 'Previous call' },
            },
            goto_previous_end = {
              ['[F'] = { query = '@function.outer', desc = 'Previous function end' },
              ['[C'] = { query = '@class.outer', desc = 'Previous class end' },
              ['[B'] = { query = '@block.outer', desc = 'Previous block end' },
            },
          },
          lsp_interop = {
            enable = true,
            border = 'single',
            floating_preview_opts = {},
            peek_definition_code = {
              ["<Space>pf"] = "@function.outer",
              ["<Space>pc"] = "@class.outer",
            },
          },
        },
        playground = {
          enable = true,
          disable = vim.g.file_too_big(vim.g.max_filesize),
          updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        },
        matchup = {
          enable = true,
          disable = {},
        },
      })
    end,
  },
}
