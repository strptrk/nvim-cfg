vim.g.ts_installed = {
  'bash', 'norg', 'c', 'cpp', 'rust', 'python',
  'lua', 'json', 'markdown', 'markdown_inline',
  'comment', 'awk', 'cmake', "awk", "cmake",
  "css", "diff", "dockerfile", "fennel",
  "git_rebase", "gitcommit", "gitignore", "gitattributes",
  "go", "jq", "latex", "make", "meson", "ninja", "perl",
  "regex", "scss", "html", "sql", "toml", "yaml",
}

vim.g.ts_ft = {
  'bash', 'norg', 'c', 'cpp', 'rust', 'python',
  'lua', 'json', 'markdown', 'markdown_inline',
  'comment', 'awk', 'cmake', "awk", "cmake",
  "css", "diff", "dockerfile", "fennel",
  "git_rebase", "gitcommit", "gitignore", "gitattributes",
  "go", "jq", "latex", "tex", "make", "meson", "ninja", "perl",
  "regex", "scss", "html", "sql", "toml", "yaml",
}

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
        show_current_context = false,
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
    cmd = 'TSInstall',
    ft = vim.g.ts_ft,
    lazy = true,
    dependencies = {
      { 'nvim-treesitter/playground', lazy = true },
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
        config = function()
          require('symbols-outline').setup()
          vim.api.nvim_create_autocmd('FileType', {
            pattern = 'Outline',
            callback = function()
              vim.wo.cursorline = true
            end,
          })
          vim.keymap.set('n', 'so', '<cmd>SymbolsOutline<CR>')
        end,
      },
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
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = false },
        autopairs = { enable = true },
        rainbow = { enable = false, extended_mode = true },
        refactor = {
          navigation = {
            enable = true,
            keymaps = {
              goto_next_usage = '<C-.>',
              goto_previous_usage = '<C-,>',
            },
          },
          highlight_definitions = {
            enable = true,
            clear_on_cursor_move = true,
          },
          highlight_current_scope = { enable = false },
          smart_rename = {
            enable = true,
            keymaps = {
              smart_rename = 'sT',
            },
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['al'] = '@loop.outer',
              ['il'] = '@loop.inner',
              ['aA'] = '@statement.outer',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['ai'] = '@block.outer',
              ['ii'] = '@block.inner',
              ['ij'] = { query = '@scope', query_group = 'locals'},
              ['aj'] = { query = '@scope', query_group = 'locals'},
              ['ak'] = '@comment.outer',
              ['ik'] = '@comment.outer',
              ['iP'] = { query = '@parameter.inner' },
              ['aP'] = { query = '@parameter.outer' },
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
              [',f'] = { query = '@function.outer', desc = 'Next function start' },
              [',c'] = { query = '@class.outer', desc = 'Next class start' },
              [',l'] = { query = '@loop.*', desc = 'Next loop' },
              [',S'] = { query = '@statement', desc = 'Next statement' },
              [',z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
              [',p'] = { query = '@parameter.inner', desc = 'Next parameter' },
              [',r'] = { query = '@regex.inner', desc = 'Next regex' },
              [',R'] = { query = '@return.inner', desc = 'Next return' },
              [',k'] = { query = '@comment.outer', desc = 'Next comment' },
              [',n'] = { query = '@number.*', desc = 'Next number' },
              [',s'] = { query = '@block', desc = 'Next block' }, -- block instead of scope
              [',i'] = { query = '@conditional.inner', desc = 'Next conditional' },
              [',a'] = { query = '@call.outer', desc = 'Next call' },
            },
            goto_next_end = {
              [',F'] = { query = '@function.outer', desc = 'Next function end' },
              [',C'] = { query = '@class.outer', desc = 'Next class end' },
              [',B'] = { query = '@block.outer', desc = 'Next block end' },
            },
            goto_previous_start = {
              [',,f'] = { query = '@function.outer', desc = 'Previous function start' },
              [',,c'] = { query = '@class.outer', desc = 'Previous class start' },
              [',,l'] = { query = '@loop.*', desc = 'Previous loop' },
              [',,S'] = { query = '@statement', desc = 'Previous statement' },
              [',,z'] = { query = '@fold', query_group = 'folds', desc = 'Previous fold' },
              [',,p'] = { query = '@parameter.inner', desc = 'Previous parameter' },
              [',,r'] = { query = '@regex.inner', desc = 'Previous regex' },
              [',,R'] = { query = '@return.inner', desc = 'Previous return' },
              [',,k'] = { query = '@comment.outer', desc = 'Previous comment' },
              [',,n'] = { query = '@number.*', desc = 'Previous number' },
              [',,s'] = { query = '@block', desc = 'Previous block' },
              [',,i'] = { query = '@conditional.inner', desc = 'Previous conditional' },
              [',,a'] = { query = '@call.outer', desc = 'Previous call' },
            },
            goto_previous_end = {
              [',,F'] = { query = '@function.outer', desc = 'Previous function end' },
              [',,C'] = { query = '@class.outer', desc = 'Previous class end' },
              [',,B'] = { query = '@block.outer', desc = 'Previous block end' },
            },
          },
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
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
