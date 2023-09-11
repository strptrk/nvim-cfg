return {
  {
    'sindrets/diffview.nvim',
    lazy = true,
    dependencies = 'nvim-lua/plenary.nvim',
    cmd = {
      'DiffviewOpen',
      'DiffviewToggleFiles',
      'DiffviewFileHistory',
    },
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
            layout = 'diff2_horizontal',
            winbar_info = true,
          },
          merge_tool = {
            layout = 'diff4_mixed',
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = {
            layout = 'diff2_horizontal',
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
            height = 14,
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
          end,
        },
        keymaps = {
          disable_defaults = false,
          view = {
            { 'n', '<tab>',   actions.select_next_entry,         { desc = "Next entry" } },
            { 'n', '<s-tab>', actions.select_prev_entry,         { desc = "Previous entry" } },
            { 'n', 'gF',      actions.goto_file,                 { desc = "Go to file" } },
            { 'n', 'gS',      actions.goto_file_split,           { desc = "Go to file (split)" } },
            { 'n', 'gf',      actions.goto_file_tab,             { desc = "Go to file (tab)" } },
            { 'n', '[x',      actions.prev_conflict,             { desc = "Previous conflict" } },
            { 'n', ']x',      actions.next_conflict,             { desc = "Next conflict" } },
            { 'n', '<A-S>',   actions.focus_files,               { desc = "Focus files" } },
            { 'n', '<A-s>',   actions.toggle_files,              { desc = "Toggle files" } },
            { 'n', 'gco',     actions.conflict_choose('ours'),   { desc = "Choose ours" } },
            { 'n', 'gct',     actions.conflict_choose('theirs'), { desc = "Choose theirs" } },
            { 'n', 'gcb',     actions.conflict_choose('base'),   { desc = "Choose base" } },
            { 'n', 'gca',     actions.conflict_choose('all'),    { desc = "Choose all" } },
            { 'n', 'gcd',     actions.conflict_choose('none'),   { desc = "Choose none" } },
          },
          file_panel = {
            { 'n', 'j',       actions.next_entry,          { desc = "Next entry" } },
            { 'n', 'k',       actions.prev_entry,          { desc = "Previous entry" } },
            { 'n', '<cr>',    actions.select_entry,        { desc = "Select entry" } },
            { 'n', 'o',       actions.select_entry,        { desc = "Select entry" } },
            { 'n', '-',       actions.toggle_stage_entry,  { desc = "Toggle staging" } },
            { 'n', 'S',       actions.stage_all,           { desc = "Stage all" } },
            { 'n', 'U',       actions.unstage_all,         { desc = "Unstage all" } },
            { 'n', 'X',       actions.restore_entry,       { desc = "Restore entry" } },
            { 'n', 'R',       actions.refresh_files,       { desc = "Refresh files" } },
            { 'n', 'L',       actions.open_commit_log,     { desc = "Open commit log" } },
            { 'n', '<c-b>',   actions.scroll_view(-0.25),  { desc = "Scroll view down (25%)" } },
            { 'n', '<c-f>',   actions.scroll_view(0.25),   { desc = "Scroll view up (25%)" } },
            { 'n', '<down>',  actions.scroll_view(1),      { desc = "Scroll view up (page)" } },
            { 'n', '<up>',    actions.scroll_view(-1),     { desc = "Scroll view down (page)" } },
            { 'n', '<tab>',   actions.select_next_entry,   { desc = "Next entry" } },
            { 'n', '<s-tab>', actions.select_prev_entry,   { desc = "Previous entry" } },
            { 'n', 'gF',      actions.goto_file,           { desc = "Go to file" } },
            { 'n', 'gS',      actions.goto_file_split,     { desc = "Go to file (split)" } },
            { 'n', 'gf',      actions.goto_file_tab,       { desc = "Go to file (tab)" } },
            { 'n', 'i',       actions.listing_style,       { desc = "Listing style" } },
            { 'n', 'f',       actions.toggle_flatten_dirs, { desc = "Flatten dirs" } },
            { 'n', '<A-S>',   actions.focus_files,         { desc = "Focus files" } },
            { 'n', '<A-s>',   actions.toggle_files,        { desc = "Toggle files" } },
            { 'n', '[x',      actions.prev_conflict,       { desc = "Previous conflict" } },
            { 'n', ']x',      actions.next_conflict,       { desc = "Next conflict" } },
          },
          file_history_panel = {
            { 'n', 'g!',      actions.options,            { desc = "Options" } },
            { 'n', 'D',       actions.open_in_diffview,   { desc = "Open in diffview" } },
            { 'n', 'y',       actions.copy_hash,          { desc = "Copy hash" } },
            { 'n', 'L',       actions.open_commit_log,    { desc = "Open commit log" } },
            { 'n', 'zo',      actions.open_all_folds,     { desc = "Open all folds" } },
            { 'n', 'zc',      actions.close_all_folds,    { desc = "Close all folds" } },
            { 'n', 'j',       actions.next_entry,         { desc = "Next entry" } },
            { 'n', 'k',       actions.prev_entry,         { desc = "Prev entry" } },
            { 'n', '<down>',  actions.scroll_view(1),     { desc = "Scroll view down (page)" } },
            { 'n', '<up>',    actions.scroll_view(-1),    { desc = "Scroll view up (page)" } },
            { 'n', '<cr>',    actions.select_entry,       { desc = "Select entry" } },
            { 'n', 'o',       actions.select_entry,       { desc = "Select entry" } },
            { 'n', '<c-b>',   actions.scroll_view(-0.25), { desc = "Scroll view up (25%)" } },
            { 'n', '<c-f>',   actions.scroll_view(0.25),  { desc = "Scroll view down (25%)" } },
            { 'n', '<tab>',   actions.select_next_entry,  { desc = "Next entry" } },
            { 'n', '<s-tab>', actions.select_prev_entry,  { desc = "Previous entry" } },
            { 'n', 'gF',      actions.goto_file,          { desc = "Go to file" } },
            { 'n', 'gS',      actions.goto_file_split,    { desc = "Go to file (split)" } },
            { 'n', 'gf',      actions.goto_file_tab,      { desc = "Go to file (tab)" } },
            { 'n', '<A-s>',   actions.toggle_files,       { desc = "Toggle files" } },
            { 'n', '<A-S>',   actions.focus_files,        { desc = "Focus files" } },
          },
          option_panel = {
            { 'n', '<tab>', actions.select_entry, { desc = "Select entry" } },
            { 'n', 'q',     actions.close,        { desc = "Close" } },
          },
        },
      })
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    lazy = true,
    event = { "VeryLazy" },
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
          maploc({ 'n', 'v' }, ',s', ':Gitsigns stage_hunk<CR>', { desc = "Stage Hunk" })
          maploc({ 'n', 'v' }, ',r', ':Gitsigns reset_hunk<CR>', { desc = "Reset Hunk" })
          maploc('n', ',S', gs.stage_buffer, { desc = 'Stage Buffer' })
          maploc('n', ',u', gs.undo_stage_hunk, { desc = 'Undo Stage Hunk' })
          maploc('n', ',R', gs.reset_buffer, { desc = 'Reset Buffer' })
          maploc('n', ',P', gs.preview_hunk, { desc = 'Preview Hunk' })
          maploc('n', ',p', gs.preview_hunk_inline, { desc = 'Preview Hunk Inline' })
          maploc('n', ',q', gs.setqflist, { desc = 'QuickFix List of Hunks' })
          maploc('n', ',w', ":Gitsigns show", { desc = 'Show Revision of file' })
          maploc('n', ',d', ":tabedit % | Gitsigns diffthis", { desc = 'Show Diff of file' })
          maploc('n', ',b', function()
            gs.blame_line({ full = true })
          end, { desc = 'Blame Line' })
          maploc({ 'o', 'x' }, 'ih', '<cmd><C-U>Gitsigns select_hunk<cr>', { desc = "Select Hunk" })
          maploc({ 'o', 'x' }, 'ah', '<cmd><C-U>Gitsigns select_hunk<cr>', { desc = "Select Hunk" })
        end,
      })
    end,
  },
}
