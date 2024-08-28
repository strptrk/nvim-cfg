return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      { "nvim-telescope/telescope-dap.nvim", lazy = true },
      { "theHamsta/nvim-dap-virtual-text", lazy = true },
      { "nvim-neotest/nvim-nio", lazy = true },
      {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        keys = {
          {
            "<BS>E",
            function()
              require("dapui").close()
            end,
            desc = "Debug: Close DAP UI",
          },
          {
            "<BS>b",
            function()
              require("dap").toggle_breakpoint()
            end,
            desc = "Debug: Toggle Breakpoint",
          },
          {
            "<BS>c",
            function()
              require("dap").continue()
            end,
            desc = "Debug: Continue",
          },
          {
            "<BS>i",
            function()
              require("dap").step_into()
            end,
            desc = "Debug: Step Into",
          },
          {
            "<BS>o",
            function()
              require("dap").step_over()
            end,
            desc = "Debug: Step Over",
          },
          {
            "<BS>r",
            function()
              require("dap").repl.open()
            end,
            desc = "Debug: Open REPL",
          },
          {
            "<BS>u",
            function()
              require("dapui").toggle()
            end,
            desc = "Debug: Toggle UI",
          },
          {
            "<BS>t",
            function()
              require("cfg.utils").fntab(nil, { zz = true })
              require("dapui").toggle()
            end,
            desc = "Debug: Toggle UI",
          },
          {
            "<BS>h",
            function()
              require("dap.ui.widgets").hover()
            end,
            desc = "Debug: Hover Symbol",
          },
          {
            "<BS>e",
            function()
              require("dapui").eval()
            end,
            desc = "Debug: Eval Expression",
          },
        },
        config = function()
          local dapui = require("dapui")
          dapui.setup({
            icons = { expanded = "", collapsed = "", current_frame = "" },
            mappings = {
              expand = { "<CR>", "<2-LeftMouse>" },
              open = "o",
              remove = "d",
              edit = "e",
              repl = "r",
              toggle = "t",
            },
            element_mappings = {},
            expand_lines = vim.fn.has("nvim-0.7") == 1,
            layouts = {
              {
                elements = {
                  { id = "scopes", size = 0.25 },
                  "breakpoints",
                  "stacks",
                  "watches",
                },
                size = 40,
                position = "left",
              },
              {
                elements = {
                  "repl",
                  "console",
                },
                size = 0.25,
                position = "bottom",
              },
            },
            controls = {
              enabled = true,
              element = "repl",
              icons = {
                pause = "",
                play = "",
                step_into = "",
                step_over = "",
                step_out = "",
                step_back = "",
                run_last = "",
                terminate = "",
              },
            },
            floating = {
              max_height = nil,
              max_width = nil,
              border = "single",
              mappings = {
                close = { "q", "<Esc>" },
              },
            },
            windows = { indent = 1 },
            render = {
              max_type_length = nil,
              max_value_lines = 100,
            },
          })
          vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
          vim.fn.sign_define(
            "DapBreakpointCondition",
            { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
          )
          vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
        end,
      },
    },
    config = function()
      require("telescope").load_extension("dap")
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local dap = require("dap")
      local defcommand = vim.api.nvim_create_user_command
      local map = vim.keymap.set
      local state = {
        executable = nil,
        args = nil,
        host = nil,
      }
      local findcmd = function()
        if 1 == vim.fn.executable("fd") then
          return { "fd", "--type", "x", "--color", "never" }
        elseif 1 == vim.fn.executable("fdfind") then
          return { "fdfind", "--type", "x", "--color", "never" }
        elseif 1 == vim.fn.executable("find") then
          return { "find", ".", "-executable", "-type", "f" }
        end
        return {}
      end

      local get_path = function(program, fallback)
        if type(program) ~= "table" then
          program = { program }
        end
        for _, pr in ipairs(program) do
          local path = vim.fn.exepath(pr)
          if path ~= "" then
            return path
          end
        end
        return fallback
      end
      local ADAPTER = get_path({
        "lldb-mi", -- lldb-vscode
        "OpenDebugAD7", -- cppdbg
        "codelldb", -- codelldb
        "lldb-vscode", -- lldb-vscode
        "lldb-dap", -- lldb-vscode
      }, nil)
      local select_executable = function(opts, fn)
        opts = opts or {}
        pickers
          .new(opts, {
            prompt_title = "Executable to run with debugger",
            finder = finders.new_oneshot_job(findcmd(), opts),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, _)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                state.executable = vim.fn.getcwd() .. "/" .. action_state.get_selected_entry()[1]
                if fn then
                  fn()
                end
              end)
              return true
            end,
          })
          :find()
      end

      defcommand("DapSelectExecutable", function()
        select_executable(require("telescope.themes").get_dropdown({}))
      end, { force = true })

      local get_exec = function()
        if state.executable ~= nil then
          return state.executable
        else
          state.executable = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          return state.executable
        end
      end
      local get_exec_modify = function()
        state.executable = nil
        return get_exec()
      end

      local get_exec_env = function()
        if state.executable ~= nil then
          return state.executable
        else
          local exec_string = vim.env["DEBUG_EXECUTABLE"]
          if exec_string then
            state.executable = exec_string
          else
            state.executable = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end
          return state.executable
        end
      end

      local get_args = function()
        if state.args == nil then
          state.args = vim.split(vim.fn.input("Arguments: "), " ")
        end
        return state.args
      end
      local get_args_modify = function()
        state.args = nil
        return get_args()
      end

      local get_args_env = function()
        if state.args ~= nil then
          return state.args
        else
          local arg_string = vim.env["DEBUG_ARGS"]
          if arg_string then
            state.args = vim.split(arg_string, " ")
          else
            state.args = vim.split(vim.fn.input("Arguments: "), " ")
          end
        end
        return state.args
      end

      local get_host = function()
        if state.host == nil then
          state.host = vim.fn.input("Hostname: ", "localhost:")
        end
        return state.host
      end

      local get_host_modify = function()
        state.host = nil
        return get_host()
      end

      local configurations = {
        codelldb = {
          type = "codelldb",
          request = "launch",
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        cppdbg = {
          type = "cppdbg",
          request = "launch",
          cwd = "${workspaceFolder}",
          stopAtEntry = true,
          setupCommands = {
            {
              text = "-enable-pretty-printing",
              description = "enable pretty printing",
              ignoreFailures = false,
            },
          },
        },
        lldb = {
          type = "lldb",
          request = "launch",
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          env = function()
            local variables = {}
            for k, v in pairs(vim.fn.environ()) do
              table.insert(variables, string.format("%s=%s", k, v))
            end
            return variables
          end,
        },
        common = {
          {
            name = "Launch (without arguments)",
            program = get_exec,
            args = {},
          },
          {
            name = "Launch (modify executable)",
            program = get_exec_modify,
            args = {},
          },
          {
            name = "Launch (with arguments)",
            program = get_exec,
            args = get_args,
          },
          {
            name = "Launch (modify arguments)",
            program = get_exec,
            args = get_args_modify,
          },
          {
            name = "Launch (modify executable and arguments)",
            program = get_exec_modify,
            args = get_args_modify,
          },
          {
            name = "Launch (using environmental variables)",
            program = get_exec_env,
            args = get_args_env,
          },
        },
      }
      if string.match(ADAPTER, "codelldb$") then
        dap.adapters.codelldb = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = get_path({ "codelldb" }, "/usr/bin/codelldb"),
            args = { "--port", "${port}" },
          },
        }
        dap.configurations.cpp = {
          {
            type = "codelldb",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
        for _, v in ipairs(configurations.common) do
          local configuration = vim.tbl_deep_extend("force", configurations.codelldb, v)
          table.insert(dap.configurations.cpp, configuration)
        end
      elseif string.match(ADAPTER, "lldb%-mi$") then -- macos bullshit :/
        dap.adapters.cppdbg = {
          id = "cppdbg",
          type = "executable",
          command = get_path({ "OpenDebugAD7" }, vim.env["HOME"] .. "/.local/bin/OpenDebugAD7"),
        }
        dap.configurations.cpp = {}
        for _, v in ipairs(configurations.common) do
          v.miDebuggerPath = get_path("lldb-mi", vim.env["HOME"] .. "/.local/bin/lldb-mi")
          local configuration = vim.tbl_deep_extend("force", configurations.cppdbg, v)
          table.insert(dap.configurations.cpp, configuration)
        end
      elseif string.match(ADAPTER, "OpenDebugAD7$") then
        dap.adapters.cppdbg = {
          id = "cppdbg",
          type = "executable",
          command = get_path({ "OpenDebugAD7" }, vim.env["HOME"] .. "/.local/bin/OpenDebugAD7"),
        }
        dap.configurations.cpp = {
          {
            name = "Attach to gdbserver",
            type = "cppdbg",
            request = "launch",
            MIMode = "gdb",
            miDebuggerServerAddress = get_host,
            miDebuggerPath = get_path({ "gdb" }, "/usr/bin/gdb"),
            cwd = "${workspaceFolder}",
            program = get_exec,
            setupCommands = {
              {
                text = "-enable-pretty-printing",
                description = "enable pretty printing",
                ignoreFailures = false,
              },
            },
          },
          {
            name = "Attach to gdbserver (modify address)",
            type = "cppdbg",
            request = "launch",
            MIMode = "gdb",
            miDebuggerServerAddress = get_host_modify,
            miDebuggerPath = get_path({ "gdb" }, "/usr/bin/gdb"),
            cwd = "${workspaceFolder}",
            program = get_exec,
            setupCommands = {
              {
                text = "-enable-pretty-printing",
                description = "enable pretty printing",
                ignoreFailures = false,
              },
            },
          },
          {
            name = "Attach to gdbserver (modify executable)",
            type = "cppdbg",
            request = "launch",
            MIMode = "gdb",
            miDebuggerServerAddress = get_host,
            miDebuggerPath = get_path({ "gdb" }, "/usr/bin/gdb"),
            cwd = "${workspaceFolder}",
            program = get_exec_modify,
            setupCommands = {
              {
                text = "-enable-pretty-printing",
                description = "enable pretty printing",
                ignoreFailures = false,
              },
            },
          },
        }
        for _, v in ipairs(configurations.common) do
          local configuration = vim.tbl_deep_extend("force", configurations.cppdbg, v)
          table.insert(dap.configurations.cpp, configuration)
        end
      elseif string.match(ADAPTER, "lldb%-") then
        dap.adapters.lldb = {
          type = "executable",
          command = get_path({
            "lldb-vscode",
            "lldb-dap",
            "lldb-mi",
          }, "/usr/bin/lldb-dap"),
          name = "lldb",
        }
        dap.configurations.cpp = {}
        for _, v in ipairs(configurations.common) do
          local configuration = vim.tbl_deep_extend("force", configurations.lldb, v)
          table.insert(dap.configurations.cpp, configuration)
        end
      end
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

      -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#Python
      dap.adapters.python = {
        type = "executable",
        -- command = getpath({ 'debugpy', 'python-debugpy' }, vim.env['HOME'] .. '/.local/bin/python-debugpy'),
        command = vim.env["HOME"] .. "/.clones/virtualenvs/debugpy/bin/python",
        args = { "-m", "debugpy.adapter" },
      }
      dap.configurations.python = {
        {
          type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
          request = "launch",
          name = "Launch file",
          -- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
          program = "${file}",
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
              return cwd .. "/venv/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
              return cwd .. "/.venv/bin/python"
            else
              local venv = vim.env["VIRTUAL_ENV"]
              return get_path({ venv and (venv .. "/bin/python") or "python", "python3" }, nil)
            end
          end,
        },
      }

      dap.listeners.after.event_initialized["dapui_config"] = function()
        require("dapui").open({})
      end
      -- dap.listeners.before.event_terminated["dapui_config"] = function()
      --   dapui.close({})
      -- end
      -- dap.listeners.before.event_exited["dapui_config"] = function()
      --   dapui.close({})
      -- end
      require("nvim-dap-virtual-text").setup({})
      map("n", "<BS>se", function()
        select_executable({}, require("dapui").open)
      end, { desc = "Debug: Select Executable" })
    end,
  },
}
