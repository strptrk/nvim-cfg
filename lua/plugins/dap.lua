local CPP_ADAPTER = 'cppdbg'

return {
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    dependencies = {
      { 'nvim-telescope/telescope-dap.nvim', lazy = true },
      { 'theHamsta/nvim-dap-virtual-text', lazy = true },
      {
        'rcarriga/nvim-dap-ui',
        lazy = true,
        keys = {
          { '<BS>E', function() require('dapui').close() end, desc = 'Debug: Close DAP UI' },
          { '<BS>b', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
          { '<BS>c', function() require('dap').continue() end, desc = 'Debug: Continue' },
          { '<BS>i', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
          { '<BS>o', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
          { '<BS>r', function() require('dap').repl.open() end, desc = 'Debug: Open REPL' },
          { '<BS>u', function() require('dapui').toggle() end, desc = 'Debug: Toggle UI' },
          { '<BS>h', function() require('dap.ui.widgets').hover() end, desc = 'Debug: Hover Symbol' },
          { '<BS>e', function() require('dapui').eval() end, desc = 'Debug: Eval Expression' },
        },
        config = function()
          local dapui = require('dapui')
          dapui.setup({
            icons = { expanded = '', collapsed = '', current_frame = '' },
            mappings = {
              expand = { '<CR>', '<2-LeftMouse>' },
              open = 'o',
              remove = 'd',
              edit = 'e',
              repl = 'r',
              toggle = 't',
            },
            element_mappings = {},
            expand_lines = vim.fn.has('nvim-0.7') == 1,
            layouts = {
              {
                elements = {
                  { id = 'scopes', size = 0.25 },
                  'breakpoints',
                  'stacks',
                  'watches',
                },
                size = 40,
                position = 'left',
              },
              {
                elements = {
                  'repl',
                  'console',
                },
                size = 0.25,
                position = 'bottom',
              },
            },
            controls = {
              enabled = true,
              element = 'repl',
              icons = {
                pause = '',
                play = '',
                step_into = '',
                step_over = '',
                step_out = '',
                step_back = '',
                run_last = '',
                terminate = '',
              },
            },
            floating = {
              max_height = nil,
              max_width = nil,
              border = 'single',
              mappings = {
                close = { 'q', '<Esc>' },
              },
            },
            windows = { indent = 1 },
            render = {
              max_type_length = nil,
              max_value_lines = 100,
            },
          })
          vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = ""})
          vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = ""})
          vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = ""})
        end,
      },
    },
    config = function()
      require('telescope').load_extension('dap')
      local pickers = require('telescope.pickers')
      local finders = require('telescope.finders')
      local conf = require('telescope.config').values
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')
      local dap = require('dap')
      local defcommand = vim.api.nvim_create_user_command
      local map = vim.keymap.set
      local Executable = nil
      local findcmd = function()
        if 1 == vim.fn.executable('find') then
          return { 'find', '.', '-executable', '-type', 'f' }
        elseif 1 == vim.fn.executable('fd') then
          return { 'fd', '--type', 'x', '--color', 'never' }
        elseif 1 == vim.fn.executable('fdfind') then
          return { 'fdfind', '--type', 'x', '--color', 'never' }
        end
        return {}
      end
      local getpath = function(program, fallback)
        if type(program) ~= 'table' then
          program = { program }
        end
        for _, pr in ipairs(program) do
          local path = vim.fn.exepath(pr)
          if path ~= '' then
            return path
          end
        end
        return fallback
      end
      local select_executable = function(opts, fn)
        opts = opts or {}
        pickers
          .new(opts, {
            prompt_title = 'Executable to run with debugger',
            finder = finders.new_oneshot_job(findcmd(), opts),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, _)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                Executable = action_state.get_selected_entry()
                if fn then
                  fn()
                end
              end)
              return true
            end,
          })
          :find()
      end

      defcommand('DBGSelectExecutable', function()
        select_executable(require('telescope.themes').get_dropdown({}))
      end, { force = true })
      local get_exec = function()
        if Executable ~= nil and Executable[1] ~= nil then
          return vim.fn.getcwd() .. '/' .. Executable[1]
        else
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end
      end
      local get_args = function()
        return vim.split(vim.fn.input('Arguments: '), ' ')
      end
      local get_host = function()
        return vim.fn.input('Hostname: ', 'localhost:')
      end
      if CPP_ADAPTER == 'codelldb' then
        dap.adapters.codelldb = {
          type = 'server',
          port = '${port}',
          executable = {
            command = getpath({ 'codelldb' }, '/usr/bin/codelldb'),
            args = { '--port', '${port}' },
          },
        }
        dap.configurations.cpp = {
          {
            name = 'Launch',
            type = 'codelldb',
            request = 'launch',
            program = get_exec,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
          },
          {
            name = 'Launch (with arguments)',
            type = 'codelldb',
            request = 'launch',
            program = get_exec,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = get_args,
          },
        }
      elseif CPP_ADAPTER == 'cppdbg' then
        local gdbpath = getpath({ 'gdb' }, '/usr/bin/gdb')
        local opendbgpath = getpath({ 'OpenDebugAD7' }, os.getenv('HOME') .. '/.local/bin/OpenDebugAD7')
        dap.adapters.cppdbg = {
          id = 'cppdbg',
          type = 'executable',
          command = opendbgpath,
        }
        dap.configurations.cpp = {
          {
            name = 'Launch',
            type = 'cppdbg',
            request = 'launch',
            program = get_exec,
            cwd = '${workspaceFolder}',
            stopAtEntry = true,
            setupCommands = {
              {
                text = '-enable-pretty-printing',
                description = 'enable pretty printing',
                ignoreFailures = false,
              },
            },
          },
          {
            name = 'Launch (with arguments)',
            type = 'cppdbg',
            request = 'launch',
            program = get_exec,
            cwd = '${workspaceFolder}',
            args = get_args,
            stopAtEntry = true,
            setupCommands = {
              {
                text = '-enable-pretty-printing',
                description = 'enable pretty printing',
                ignoreFailures = false,
              },
            },
          },
          {
            name = 'Attach to gdbserver',
            type = 'cppdbg',
            request = 'launch',
            MIMode = 'gdb',
            miDebuggerServerAddress = get_host,
            miDebuggerPath = gdbpath,
            cwd = '${workspaceFolder}',
            program = get_exec,
            setupCommands = {
              {
                text = '-enable-pretty-printing',
                description = 'enable pretty printing',
                ignoreFailures = false,
              },
            },
          },
        }
      elseif CPP_ADAPTER == 'lldb-vscode' then
        local lldbpath = getpath({ 'lldb-vscode-14', 'lldb-vscode' }, '/usr/bin/lldb-vscode')
        dap.adapters.lldb = {
          type = 'executable',
          command = lldbpath,
          name = 'lldb',
        }
        dap.configurations.cpp = {
          {
            name = 'Launch',
            type = 'lldb',
            request = 'launch',
            program = get_exec,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
            env = function()
              local variables = {}
              for k, v in pairs(vim.fn.environ()) do
                table.insert(variables, string.format('%s=%s', k, v))
              end
              return variables
            end,
          },
          {
            name = 'Launch (with arguments)',
            type = 'lldb',
            request = 'launch',
            program = get_exec,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = get_args,
            env = function()
              local variables = {}
              for k, v in pairs(vim.fn.environ()) do
                table.insert(variables, string.format('%s=%s', k, v))
              end
              return variables
            end,
          },
        }
      end
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp
      -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#Python
      dap.adapters.python = {
        type = 'executable',
        -- command = getpath({ 'debugpy', 'python-debugpy' }, os.getenv('HOME') .. '/.local/bin/python-debugpy'),
        command = os.getenv('HOME') .. '/.clones/virtualenvs/debugpy/bin/python',
        args = { '-m', 'debugpy.adapter' },
      }
      dap.configurations.python = {
        {
          type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
          request = 'launch',
          name = 'Launch file',
          -- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
          program = '${file}',
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              local venv = os.getenv('VIRTUAL_ENV')
              return getpath({ venv and (venv .. '/bin/python') or 'python' }, '/usr/bin/python')
            end
          end,
        },
      }

      dap.listeners.after.event_initialized['dapui_config'] = function()
        require('dapui').open({})
      end
      -- dap.listeners.before.event_terminated["dapui_config"] = function()
      --   dapui.close({})
      -- end
      -- dap.listeners.before.event_exited["dapui_config"] = function()
      --   dapui.close({})
      -- end
      require('nvim-dap-virtual-text').setup({})
      map('n', '<BS>se', function()
        select_executable({}, require('dapui').open)
      end, { desc = 'Debug: Select Executable' })
    end,
  },
}
