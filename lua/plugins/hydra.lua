return {
  {
    'anuvyklack/hydra.nvim',
    lazy = true,
    keys = {
      { '<A-z>', nil, desc = 'Scroll' },
      { '<A-g>', nil, desc = 'Git Actions' },
      { '<A-G>', nil, desc = 'Git Telescope' },
      { '<A-o>', nil, desc = 'Options' },
      { '<A-O>', nil, desc = 'Development Options' },
    },
    config = function()
      local Hydra = require('hydra')
      Hydra({
        name = 'Scroll',
        mode = 'n',
        config = {
          invoke_on_body = true,
        },
        body = '<A-z>',
        heads = {
          { 'h', '5zh' },
          { 'l', '5zl', { desc = '←/→' } },
          { 'H', 'zH' },
          { 'L', 'zL', { desc = '⇇/⇉' } },
          { 'j', '<C-e>' },
          { 'k', '<C-y>', { desc = '↓/↑' } },
          { 'J', '<C-f>' },
          { 'K', '<C-b>', { desc = '⇊/⇈' } },
        },
      })
      local gitsigns = require('gitsigns')
      local hint = [[
   _J_: next hunk   _s_: stage hunk        _d_: show deleted      _D_: diffview
   _K_: prev hunk   _u_: undo last stage   _p_: preview hunk      _C_: commit diffview ^ ^ ^
   ^ ^              _S_: stage buffe       _P_: preview hunk (il) _F_: file history
   ^ ^              _R_: reset hunk        _b_: blame line       
   ^ ^ ^ ^                                 _B_: blame show full   _;_: Gitsigns   
   ^ ^
   ^ ^              _<Enter>_: Lazygit              _q_: exit
      ]]

      Hydra({
        name = 'Git',
        hint = hint,
        config = {
          -- buffer = bufnr,
          color = 'pink',
          invoke_on_body = true,
          hint = {
            border = 'rounded',
          },
          on_enter = function()
            if vim.api.nvim_buf_get_name(0) ~= "" then
              vim.cmd('mkview')
              vim.cmd('silent! %foldopen!')
              vim.bo.modifiable = false
              -- gitsigns.toggle_signs(true)
              gitsigns.toggle_linehl(true)
            end
          end,
          on_exit = function()
            if vim.api.nvim_buf_get_name(0) ~= "" then
              local cursor_pos = vim.api.nvim_win_get_cursor(0)
              vim.cmd('loadview')
              vim.api.nvim_win_set_cursor(0, cursor_pos)
              vim.cmd('normal zv')
              -- gitsigns.toggle_signs(false)
              gitsigns.toggle_linehl(false)
              gitsigns.toggle_deleted(false)
            end
          end,
        },
        mode = { 'n', 'x' },
        body = '<A-g>',
        heads = {
          {
            'J',
            function()
              if vim.wo.diff then
                return ']c'
              end
              vim.schedule(function()
                gitsigns.next_hunk()
              end)
              return '<Ignore>'
            end,
            { expr = true, desc = 'next hunk' },
          },
          {
            'K',
            function()
              if vim.wo.diff then
                return '[c'
              end
              vim.schedule(function()
                gitsigns.prev_hunk()
              end)
              return '<Ignore>'
            end,
            { expr = true, desc = 'prev hunk' },
          },
          { 's', gitsigns.stage_hunk, { desc = 'stage hunk' } },
          { 'u', gitsigns.undo_stage_hunk, { desc = 'undo last stage' } },
          { 'S', gitsigns.stage_buffer, { desc = 'stage buffer' } },
          { 'p', gitsigns.preview_hunk, { desc = 'preview hunk' } },
          {
            'P',
            function()
              gitsigns.preview_hunk_inline({ inline = true })
            end,
            { desc = 'preview hunk' },
          },
          {
            'R',
            gitsigns.reset_hunk,
            { exit = true, desc = 'reset hunk' },
          },
          {
            'd',
            gitsigns.toggle_deleted,
            { nowait = true, desc = 'toggle deleted' },
          },
          {
            'D',
            '<cmd>DiffviewOpen<cr>',
            { exit = true, desc = 'diffview' },
          },
          {
            'C',
            '<cmd>DiffviewFileHistory<cr>',
            { exit = true, desc = 'commit diffview' },
          },
          {
            'F',
            '<cmd>DiffviewFileHistory %<cr>',
            { exit = true, desc = 'file diffview' },
          },
          {
            ';',
            '<cmd>Gitsigns<cr>',
            { exit = true, desc = 'Gitsigns' },
          },
          { 'b', gitsigns.blame_line, { desc = 'blame' } },
          {
            'B',
            function()
              gitsigns.blame_line({ full = true })
            end,
            { desc = 'blame show full' },
          },
          {
            '<Enter>',
            '<Cmd>Lazygit<CR>',
            { exit = true, desc = 'Lazygit' },
          },
          {
            'q',
            nil,
            { exit = true, nowait = true, desc = 'exit' },
          },
        },
      })

      hint = [[
      ^ ^        Telescope Git ^ ^ ^
      ^
   _f_ Files
   _S_ Status
   _s_ Stash
   _c_ Commits
   _b_ Branches
   _C_ Branch Commits
      ^
           _q_ / _<Esc>_
      ]]

      Hydra({
        name = 'Telescope Git',
        hint = hint,
        config = {
          color = 'amaranth',
          invoke_on_body = true,
          hint = {
            border = 'rounded',
            position = 'bottom',
            funcs = { },
          },
        },
        mode = { 'n', 'x' },
        body = '<A-G>',
        heads = {
          {
            'f',
            function()
              require('telescope.builtin').git_files()
            end,
            { desc = 'Git Files', exit = true },
          },
          {
            'S',
            function()
              require('telescope.builtin').git_status()
            end,
            { desc = 'Git Status', exit = true },
          },
          {
            's',
            function()
              require('telescope.builtin').git_stash()
            end,
            { desc = 'Git Status', exit = true },
          },
          {
            'c',
            function()
              require('telescope.builtin').git_commits()
            end,
            { desc = 'Git Commits', exit = true },
          },
          {
            'b',
            function()
              require('telescope.builtin').git_branches()
            end,
            { desc = 'Git Branches', exit = true },
          },
          {
            'C',
            function()
              require('telescope.builtin').git_bcommits()
            end,
            { desc = 'Git Branch Commits', exit = true },
          },
          { '<Esc>', nil, { exit = true } },
          { 'q', nil, { exit = true } },
        },
      })

      hint = [[
      ^ ^  Development Options ^ ^ ^
      ^
      _d_ %{diag} diagnostics
      ^
           _q_ / _<Esc>_
      ]]

      Hydra({
        name = 'Development Options',
        hint = hint,
        config = {
          color = 'amaranth',
          invoke_on_body = true,
          hint = {
            border = 'rounded',
            position = 'bottom',
            funcs = {
              diag = function()
                if vim.diagnostic.is_disabled() then
                  return '[ ]'
                end
                return '[x]'
              end,
            },
          },
        },
        mode = { 'n', 'x' },
        body = '<A-O>',
        heads = {
          {
            'd',
            function()
              if vim.diagnostic.is_disabled() then
                vim.diagnostic.enable()
              else
                vim.diagnostic.disable()
              end
            end,
            desc = 'lsp diagnostics',
          },
          { '<Esc>', nil, { exit = true } },
          { 'q', nil, { exit = true } },
        },
      })
    end,
  },
}
