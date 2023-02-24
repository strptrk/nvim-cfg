return {
  {
    'sindrets/diffview.nvim',
    lazy = true,
    dependencies = 'nvim-lua/plenary.nvim',

    config = function()
      local actions = require('diffview.actions')
      require('diffview').setup({
        diff_binaries = false,
        enhanced_diff_hl = true,
        git_cmd = { 'git' },
        use_icons = true,
        icons = {
          folder_closed = '',
          folder_open = '',
        },
        signs = {
          fold_closed = '',
          fold_open = '',
        },
        view = {
          default = {
            layout = "diff2_horizontal",
            winbar_info = true,
          },
          merge_tool = {
            layout = "diff4_mixed",
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = {
            layout = "diff2_horizontal",
            winbar_info = true,
          },
        },
        file_panel = {
          listing_style = 'tree',
          tree_options = {
            flatten_dirs = true,
            folder_statuses = 'only_folded',
          },
          win_config = {
            position = 'left',
            width = 35,
          },
        },
        file_history_panel = {
          log_options = {
            git = {
              single_file = {
                diff_merges = 'combined',
              },
              multi_file = {
                diff_merges = 'first-parent',
              },
            },
          },
          win_config = {
            position = 'bottom',
            height = 16,
          },
        },
        commit_log_panel = {
          win_config = {},
        },
        default_args = {
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },
        hooks = {
          diff_buf_read = function(_)
            vim.opt_local.wrap = false
            vim.opt_local.list = false
            vim.opt_local.number = false
          end
        },
        keymaps = {
          disable_defaults = false,
          view = {
            ['<tab>']      = actions.select_next_entry,
            ['<s-tab>']    = actions.select_prev_entry,
            ['gF']         = actions.goto_file,
            ['gS']         = actions.goto_file_split,
            ['gf']         = actions.goto_file_tab,
            ['[x']         = actions.prev_conflict,
            [']x']         = actions.next_conflict,
            ['<leader>e']  = actions.focus_files,
            ['<leader>b']  = actions.toggle_files,
            ["<leader>co"] = actions.conflict_choose("ours"),
            ["<leader>ct"] = actions.conflict_choose("theirs"),
            ["<leader>cb"] = actions.conflict_choose("base"),
            ["<leader>ca"] = actions.conflict_choose("all"),
            ["<leader>cd"] = actions.conflict_choose("none"),
          },
          file_panel = {
            ['j'] = actions.next_entry,
            ['k'] = actions.prev_entry,
            ['<cr>'] = actions.select_entry,
            ['o'] = actions.select_entry,
            ['<2-LeftMouse>'] = actions.select_entry,
            ['-'] = actions.toggle_stage_entry,
            ['S'] = actions.stage_all,
            ['U'] = actions.unstage_all,
            ['X'] = actions.restore_entry,
            ['R'] = actions.refresh_files,
            ['L'] = actions.open_commit_log,
            ['<c-b>'] = actions.scroll_view( -0.25),
            ['<c-f>'] = actions.scroll_view(0.25),
            ['<down>'] = actions.scroll_view(1),
            ['<up>'] = actions.scroll_view( -1),
            ['<tab>'] = actions.select_next_entry,
            ['<s-tab>'] = actions.select_prev_entry,
            ['gF'] = actions.goto_file,
            ['gS'] = actions.goto_file_split,
            ['gf'] = actions.goto_file_tab,
            ['i'] = actions.listing_style,
            ['f'] = actions.toggle_flatten_dirs,
            ['<leader>e'] = actions.focus_files,
            ['<leader>b'] = actions.toggle_files,
            ["[x"] = actions.prev_conflict,
            ["]x"] = actions.next_conflict,
          },
          file_history_panel = {
            ['g!'] = actions.options,
            ['<C-A-d>'] = actions.open_in_diffview,
            ['y'] = actions.copy_hash,
            ['L'] = actions.open_commit_log,
            ['zR'] = actions.open_all_folds,
            ['zM'] = actions.close_all_folds,
            ['j'] = actions.next_entry,
            ['<down>'] = actions.next_entry,
            ['k'] = actions.prev_entry,
            ['<up>'] = actions.prev_entry,
            ['<cr>'] = actions.select_entry,
            ['o'] = actions.select_entry,
            ['<2-LeftMouse>'] = actions.select_entry,
            ['<c-b>'] = actions.scroll_view( -0.25),
            ['<c-f>'] = actions.scroll_view(0.25),
            ['<tab>'] = actions.select_next_entry,
            ['<s-tab>'] = actions.select_prev_entry,
            ['gF'] = actions.goto_file,
            ['gS'] = actions.goto_file_split,
            ['gf'] = actions.goto_file_tab,
            ['<leader>e'] = actions.focus_files,
            ['<leader>b'] = actions.toggle_files,
          },
          option_panel = {
            ['<tab>'] = actions.select_entry,
            ['q'] = actions.close,
          },
        },
      })
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
          change = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
          delete = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
          topdelete = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
          changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        },
        signcolumn = true,
        numhl = true,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = function()
          return '<author>, <author_time:%Y-%m-%d> - <summary>'
        end,
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
        preview_config = {

          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1,
        },
        yadm = {
          enable = false,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function maploc(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          maploc('n', ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end, { expr = true })
          maploc('n', '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end, { expr = true })
          maploc({ 'n', 'v' }, '<A-g>sh', ':Gitsigns stage_hunk<CR>')
          maploc({ 'n', 'v' }, '<A-g>rh', ':Gitsigns reset_hunk<CR>')
          maploc('n', '<A-g>sb', gs.stage_buffer, { desc = "Stage Buffer" })
          maploc('n', '<A-g>uh', gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
          maploc('n', '<A-g>rb', gs.reset_buffer, { desc = "Reset Buffer" })
          maploc('n', '<A-g>ph', gs.preview_hunk, { desc = "Preview Hunk" })
          maploc('n', '<A-g>bl', function()
            gs.blame_line({ full = true })
          end, { desc = "Blame Line" })
          maploc('n', '<A-g>bt', gs.toggle_current_line_blame, { desc = "Toggle Current Line Blame" })
          maploc('n', '<A-g>Dt', gs.diffthis, { desc = "Diff This" })
          maploc('n', '<A-g>Dh', function()
            gs.diffthis('~')
          end, { desc = "Diff ~" })
          maploc('n', '<A-g>td', gs.toggle_deleted, { desc = "Toggle Deleted" })
          maploc({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
      })
    end
  },
}
