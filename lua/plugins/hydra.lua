return {
  {
    'anuvyklack/hydra.nvim',
    lazy = true,
    keys = {
      { '<A-z>', nil, desc = 'Scroll' },
      { '<A-g>', nil, desc = 'Git Actions' },
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
      -- TODO
      -- vim.keymap.set('n', '<A-g>f', function() require('telescope.builtin').git_files() end, 'Git files')
      -- vim.keymap.set('n', '<A-g>c', function() require('telescope.builtin').git_commits() end, 'Git commits')
      -- vim.keymap.set('n', '<A-g>bc', function() require('telescope.builtin').git_bcommits() end, 'Git branch commits')
      -- vim.keymap.set('n', '<A-g>br', function() require('telescope.builtin').git_branches() end, 'Git branches')
      -- vim.keymap.set('n', '<A-g>ss', function() require('telescope.builtin').git_status() end, 'Git status')
      -- vim.keymap.set('n', '<A-g>st', function() require('telescope.builtin').git_stash() end, 'Git stash')
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
            vim.cmd('mkview')
            vim.cmd('silent! %foldopen!')
            vim.bo.modifiable = false
            -- gitsigns.toggle_signs(true)
            gitsigns.toggle_linehl(true)
          end,
          on_exit = function()
            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            vim.cmd('loadview')
            vim.api.nvim_win_set_cursor(0, cursor_pos)
            vim.cmd('normal zv')
            -- gitsigns.toggle_signs(false)
            gitsigns.toggle_linehl(false)
            gitsigns.toggle_deleted(false)
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
      ^ ^        Options ^ ^ ^
      ^
   _v_ %{ve} virtual edit
   _i_ %{list} invisible characters  
   _s_ %{spell} spell
   _w_ %{wrap} wrap
   _l_ %{cul} cursor line
   _c_ %{cc} color column
   _n_ %{nu} number
   _r_ %{rnu} relative number
      ^
           _q_ / _<Esc>_
      ]]

      Hydra({
        name = 'Options',
        hint = hint,
        config = {
          color = 'amaranth',
          invoke_on_body = true,
          hint = {
            border = 'rounded',
            position = 'bottom',
            funcs = {
              cc = function()
                if vim.o.colorcolumn ~= '80,120' then
                  return '[ ]'
                end
                return '[x]'
              end,
            },
          },
        },
        mode = { 'n', 'x' },
        body = '<A-o>',
        heads = {
          {
            'n',
            function()
              if vim.o.number == true then
                vim.o.number = false
              else
                vim.o.number = true
              end
            end,
            { desc = 'number' },
          },
          {
            'r',
            function()
              if vim.o.relativenumber == true then
                vim.o.relativenumber = false
              else
                vim.o.number = true
                vim.o.relativenumber = true
              end
            end,
            { desc = 'relativenumber' },
          },
          {
            'v',
            function()
              if vim.o.virtualedit == 'all' then
                vim.o.virtualedit = 'block'
              else
                vim.o.virtualedit = 'all'
              end
            end,
            { desc = 'virtualedit' },
          },
          {
            'i',
            function()
              if vim.o.list == true then
                vim.o.list = false
              else
                vim.o.list = true
              end
            end,
            { desc = 'show invisible' },
          },
          {
            's',
            function()
              if vim.o.spell == true then
                vim.o.spell = false
              else
                vim.o.spell = true
              end
            end,
            { exit = true, desc = 'spell' },
          },
          {
            'w',
            function()
              if vim.o.wrap ~= true then
                vim.o.wrap = true
                vim.keymap.set('n', 'k', function()
                  return vim.v.count > 0 and 'k' or 'gk'
                end, { expr = true, desc = 'k or gk' })
                vim.keymap.set('n', 'j', function()
                  return vim.v.count > 0 and 'j' or 'gj'
                end, { expr = true, desc = 'j or gj' })
              else
                vim.o.wrap = false
                vim.keymap.del('n', 'k')
                vim.keymap.del('n', 'j')
              end
            end,
            { desc = 'wrap' },
          },
          {
            'l',
            function()
              if vim.o.cursorline == true then
                vim.o.cursorline = false
              else
                vim.o.cursorline = true
              end
            end,
            { desc = 'cursor line' },
          },
          {
            'c',
            function()
              if vim.o.colorcolumn ~= '80,120' then
                vim.o.colorcolumn = '80,120'
              else
                vim.o.colorcolumn = ''
              end
            end,
            { desc = 'color column' },
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
