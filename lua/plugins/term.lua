return {
  {
    'akinsho/toggleterm.nvim',
    lazy = true,
    cmd = { 'TermExec', 'ToggleTerm', 'Lazygit' },
    keys = {
      { '<A-f>', nil, desc = 'Open Terminal' },
      { '<A-b>', nil, desc = 'Select Terminal' },
      { '<A-n>', nil, desc = 'Set Terminal Name' },
      { '<A-r>', nil, desc = 'Run Command in Terminal' },
      { '<A-C-r>', nil, desc = 'Set Command to Run' },
      { '<A-R>', nil, desc = 'Toggle Run Terminal' },
      { '<A-v>f', nil, desc = 'Open Terminal (float)' },
      { '<A-v>t', nil, desc = 'Open Terminal (tab)' },
      { '<A-v>v', nil, desc = 'Open Terminal (vertical)' },
      { '<A-v>h', nil, desc = 'Open Terminal (horizontal)' },
      { '<A-v>l', nil, desc = 'Open Terminal (vertical)' },
      { '<A-v>j', nil, desc = 'Open Terminal (horizontal)' },
    },
    config = function()
      local api = vim.api
      local pickers = require('telescope.pickers')
      local finders = require('telescope.finders')
      local conf = require('telescope.config').values
      local actions = require('telescope.actions')
      local previewers = require('telescope.previewers')
      local action_state = require('telescope.actions.state')
      Term = {}
      require('toggleterm').setup({
        size = function(term)
          if term.direction == 'horizontal' then
            return 10
          elseif term.direction == 'vertical' then
            return vim.o.columns * 0.3
          end
        end,
        open_mapping = nil,
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        direction = 'float',
        close_on_exit = true,
        autochdir = true,
        autoscroll = true,
        float_opts = { border = 'single', winblend = 0 },
        winbar = {
          enabled = false,
          name_formatter = function(term)
            return term.name
          end,
        },
      })

      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new({
        cmd = 'lazygit',
        direction = 'tab',
        hidden = true,
        count = 1000,
      })
      Term.lazygit_toggle = function()
        lazygit:toggle()
      end
      vim.api.nvim_create_user_command('Lazygit', Term.lazygit_toggle, { force = true })

      Term.Terminals = {}
      Term.Last = -1

      Term.add_term = function(num, dir)
        Term.Terminals[num] = {
          term = Terminal:new({
            -- cmd = vim.o.shell,
            direction = dir or 'float',
            count = num,
            on_exit = Term.delete_term,
          }),
        }
      end

      Term.delete_term = function(term)
        Term.Terminals[term.count] = nil
        Term.Last = (next(Term.Terminals) or { count = -1 }).count
      end

      Term.focus_term = function(num, dir)
        if num < 1 then
          num = 1
        end
        if Term.Terminals[num] == nil then
          Term.add_term(num, dir)
        end
        if Term.Terminals[num].term:is_open() and not Term.Terminals[num].term:is_focused() then
          Term.Terminals[num].term:focus()
        else
          Term.Terminals[num].term:toggle(nil, dir)
        end
        Term.Last = num
      end

      Term.focus_last = function(dir)
        if Term.Last < 0 then
          Term.Last = 1
        end
        Term.focus_term(Term.Last, dir)
      end

      Term.preview_term = function(self, entry, status)
        local from = -1 * (api.nvim_win_get_height(status.preview_win) + 1)
        local lines = api.nvim_buf_get_lines(entry.value.term.bufnr, from, -1, false)
        api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines or {})
        api.nvim_win_set_option(status.preview_win, 'wrap', false)
      end

      Term.select_open_term = function(opts, title)
        opts = opts or {}
        if not next(Term.Terminals) then
          vim.notify('There are no terminals open')
          return
        end
        pickers
          .new(opts, {
            prompt_title = title or 'Terminal',
            finder = finders.new_table({
              results = Term.Terminals,
              entry_maker = function(entry)
                local name = (entry.term.display_name or 'Terminal')
                  .. ' #'
                  .. entry.term.count
                  .. ' ('
                  .. entry.term.direction
                  .. ')'
                return {
                  value = entry,
                  display = name,
                  ordinal = name,
                }
              end,
            }),
            previewer = previewers.new_buffer_previewer({
              title = 'Terminal',
              define_preview = Term.preview_term,
            }),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, _)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local entry = action_state.get_selected_entry()
                Term.focus_term(entry.value.term.count, nil)
                Term.Terminals[entry.value.term.count].term:set_mode('i')
              end)
              return true
            end,
          })
          :find()
      end

      Term.rename_term = function(opts, title)
        opts = opts or {}
        if not next(Term.Terminals) then
          vim.notify('There are no terminals open')
          return
        end
        pickers
          .new(opts, {
            prompt_title = title or 'Rename Terminal',
            finder = finders.new_table({
              results = Term.Terminals,
              entry_maker = function(entry)
                local name = (entry.term.display_name or 'Terminal')
                  .. ' #'
                  .. entry.term.count
                  .. ' ('
                  .. entry.term.direction
                  .. ')'
                return {
                  value = entry,
                  display = name,
                  ordinal = name,
                }
              end,
            }),
            previewer = previewers.new_buffer_previewer({
              title = 'Terminal',
              define_preview = Term.preview_term,
            }),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, _)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local entry = action_state.get_selected_entry()
                vim.ui.input({ prompt = 'Set Name of ' .. entry.display, kind = 'center' }, function(input)
                  if not input or input == '' then
                    return
                  end
                  entry.value.term.display_name = input
                end)
              end)
              return true
            end,
          })
          :find()
      end

      Term.runterm = Terminal:new({
        direction = 'vertical',
        hidden = true,
        count = 1001,
      })
      Term.runterm_toggle = function()
        Term.runterm:toggle()
      end

      Term.runterm_run = function()
        if Term.runcmd == nil then
          vim.ui.input({ prompt = 'Command to run: ' }, function(input)
            if not input or input == '' then
              return
            else
              Term.runcmd = input
              if not Term.runterm:is_open() then
                Term.runterm:open()
              end
              Term.runterm:send(Term.runcmd, true)
            end
          end)
        else
          if not Term.runterm:is_open() then
            Term.runterm:open()
          end
          Term.runterm:send(Term.runcmd, true)
        end
      end

      Term.runterm_askcmd = function()
        vim.ui.input({ prompt = 'Command to run: ', }, function(input)
          if not input or input == '' then
            return
          else
            Term.runcmd = input
          end
        end)
      end

      vim.api.nvim_create_user_command('RunTermDir', function(args)
        local dir = args.fargs[1]
        if not dir or dir == '' then
          return
        end
        if Term.runterm:is_open() then
          Term.runterm:close()
        end
        Term.runterm:change_direction(dir)
        Term.runterm:open()
      end, { force = true, nargs = '?' })

      vim.keymap.set({ 'n', 't', 'x' }, '<A-R>', function()
        Term.runterm_toggle()
      end, { desc = 'Set Command to Run' })
      vim.keymap.set({ 'n', 't', 'x' }, '<A-C-r>', function()
        Term.runterm_askcmd()
      end, { desc = 'Toggle Run Terminal' })
      vim.keymap.set({ 'n', 't', 'x' }, '<A-r>', function()
        Term.runterm_run()
      end, { desc = 'Run Command in Terminal' })

      vim.keymap.set({ 'n', 't', 'x' }, '<A-G>', function()
        Term.lazygit_toggle()
      end, { desc = 'Lazygit' })
      vim.keymap.set({ 'n', 'v', 't' }, [[<A-f>]], function()
        if vim.v.count == 0 then
          Term.focus_last()
        else
          Term.focus_term(vim.v.count, nil)
        end
      end, { desc = 'Open terminal' })

      vim.keymap.set({ 'n', 'v', 't' }, [[<A-b>]], function()
        Term.select_open_term()
      end, { desc = 'Select Terminal' })

      vim.keymap.set({ 'n', 'v', 't' }, [[<A-n>]], function()
        Term.rename_term()
      end, { desc = 'Set Terminal Name' })

      local directions = {
        f = 'float',
        t = 'tab',
        v = 'vertical',
        l = 'vertical',
        h = 'horizontal',
        j = 'horizontal',
      }
      for k, _ in string.gmatch('ftvhjl', '.') do
        vim.keymap.set({ 'n', 'v', 't' }, [[<A-v>]] .. k, function()
          if vim.v.count == 0 then
            Term.focus_last(directions[k])
          else
            Term.focus_term(vim.v.count, directions[k])
          end
        end, { desc = 'Open Terminal (' .. directions[k] .. ')' })
      end
    end,
  },
}
