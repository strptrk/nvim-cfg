return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      { "nvim-telescope/telescope-dap.nvim", lazy = true },
      { "nvim-telescope/telescope.nvim",     lazy = true },
      { "rcarriga/cmp-dap",                  lazy = true },
      { "theHamsta/nvim-dap-virtual-text",   lazy = true },
      { "nvim-neotest/nvim-nio",             lazy = true },
      {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        cmd = {
          "DapSelectTarget",
          "DapSetTarget",
          "DapSetArgs",
          "DapSetHost",
        },
        keys = { ---@format disable
          { "<BS>E", function() require("dapui").close() end, desc = "Debug: Close DAP UI" },
          { "<BS>b", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
          { "<BS>B", function() require("dap").set_breakpoint(vim.fn.input("Condition:")) end, desc = "Debug: Set Conditional Breakpoint" },
          { "<BS>H", function() require("dap").set_breakpoint(vim.fn.input("Condition:"), vim.fn.input("Hit Condition:")) end, desc = "Debug: Set Conditional Breakpoint with Hit Condition" },
          { "<BS>c", function() require("dap").continue() end, desc = "Debug: Continue" },
          { "<BS>i", function() require("dap").step_into() end, desc = "Debug: Step Into" },
          { "<BS>o", function() require("dap").step_over() end, desc = "Debug: Step Over" },
          { "<BS>R", function() require("dap").repl.open() end, desc = "Debug: Open REPL" },
          { "<BS>r", function() require("dap").run_to_cursor() end, desc = "Debug: Run to Cursor" },
          { "<BS>d", function() require("dap").down() end, desc = "Debug: Jump Down a Frame" },
          { "<BS>u", function() require("dap").up() end, desc = "Debug: Jump Up a Frame" },
          { "<BS>F", function() require("dap").focus_frame() end, desc = "Debug: Focus Current Frame" },
          { "<BS>U", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
          { "<BS>h", function() require("dap.ui.widgets").hover() end, desc = "Debug: Hover Symbol" },
          { "<BS>e", function() require("dapui").eval() end, desc = "Debug: Eval Expression" },
          { "<BS>se", "<cmd>DapSelectTarget<cr>", desc = "Debug: Select Target" },
          { "<BS>sE", "<cmd>DapSetTarget<cr>", desc = "Debug: Set Target" },
          { "<BS>sh", "<cmd>DapSetHost<cr>", desc = "Debug: Set Remote Host" },
          { "<BS>sa", "<cmd>DapSetArgs<cr>", desc = "Debug: Set Arguments" },
          { "<BS>;", function() require("telescope").extensions.dap.commands(require("telescope.themes").get_ivy({})) end,         desc = "Telescope DAP Commands" },
          { "<BS>C", function() require("telescope").extensions.dap.configurations(require("telescope.themes").get_ivy({})) end,   desc = "Telescope DAP Configurations" },
          { "<BS>l", function() require("telescope").extensions.dap.list_breakpoints(require("telescope.themes").get_ivy({})) end, desc = "Telescope DAP Breakpoints"},
          { "<BS>v", function() require("telescope").extensions.dap.variables(require("telescope.themes").get_ivy({})) end,        desc = "Telescope DAP Variables" },
          { "<BS>f", function() require("telescope").extensions.dap.frames(require("telescope.themes").get_ivy({})) end,           desc = "Telescope DAP Frames" },
          { "<BS>t", function() require("cfg.utils").fntab(function() require("dapui").toggle() end, { zz = true }) end,           desc = "Debug: Open UI in new tab" },
        }, ---@format disable
        config = function()
          local dapui = require("dapui")
          dapui.setup({
            mappings = {
              expand = { "<CR>", "<2-LeftMouse>" },
              open = "o",
              remove = "d",
              edit = "e",
              repl = "r",
              toggle = "t",
            },
            element_mappings = {},
            expand_lines = true,
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
          ---@format disable
          vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
          vim.fn.sign_define("DapBreakpointCondition", {text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = ""})
          vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
          vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "debugPC", numhl = "" })
          vim.fn.sign_define("DapBreakpointRejected", { text = "⊗", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })
          ---@format enable
        end,
      },
    },
    config = function()
      require("telescope").load_extension("dap")

      local state = {
        executable = nil,
        args = nil,
        host = nil,
      }

      local findcmd = function()
        -- "--no-ignore-vcs", because fd is gitignore-avare,
        -- and most build directories are excluded from version control,
        if 1 == vim.fn.executable("fd") then
          return { "fd", "--type", "x", "--color", "never", "--no-ignore-vcs" }
        elseif 1 == vim.fn.executable("fdfind") then
          return { "fdfind", "--type", "x", "--color", "never", "--no-ignore-vcs" }
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
        "lldb-mi",      -- lldb-vscode
        "OpenDebugAD7", -- cppdbg
        "codelldb",     -- codelldb
        "lldb-vscode",  -- lldb-vscode
        "lldb-dap",     -- lldb-vscode
      }, "")

      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local dap = require("dap")
      local telescope_pick_executable = function(opts, callback)
        opts = opts or {}
        pickers
            .new(opts, {
              prompt_title = "Executable to debug",
              finder = finders.new_oneshot_job(findcmd(), opts),
              sorter = conf.generic_sorter(opts),
              attach_mappings = function(prompt_bufnr, _)
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  state.executable = vim.fn.getcwd() .. "/" .. action_state.get_selected_entry()[1]
                  if callback then
                    callback()
                  end
                end)
                return true
              end,
            })
            :find()
      end

      local select_target = function(callback, force)
        if force or state.executable == nil or state.executable == "" then
          telescope_pick_executable({}, callback)
        end
        return state.executable
      end
      vim.api.nvim_create_user_command("DapSelectTarget", function()
        select_target(require("dapui").open, true)
      end, { force = true, nargs = 0 })

      local set_target = function(target, force)
        if target then
          state.executable = target
        elseif force or state.executable == nil or state.executable == "" then
          local placeholder = state.executable or (vim.fn.getcwd() .. "/")
          local tmp = vim.fn.input("Path to executable: ", placeholder, "file")
          if tmp ~= nil and tmp ~= "" then
            state.executable = tmp
          end
        end
        return state.executable
      end
      vim.api.nvim_create_user_command("DapSetTarget", function(args)
        if args.args == "" then
          set_target(nil, true)
        else
          if string.sub(args.args, 1, 1) == "/" then
            set_target(args.args)
          else
            set_target(vim.fn.getcwd() .. "/" .. args.args)
          end
        end
      end, { force = true, nargs = "?", complete = "file" })

      local set_args = function(fargs, force)
        if fargs then
          state.args = fargs
        elseif force or state.args == nil then
          local placeholder = table.concat(state.args or {}, " ")
          local split = vim.split(vim.fn.input("Arguments: ", placeholder), " ")
          if not split or (#split == 1 and split[1] == "") then
            state.args = state.args or {}
          else
            state.args = split
          end
        end
        return state.args
      end
      vim.api.nvim_create_user_command("DapSetArgs", function(args)
        if #args.fargs == 0 then
          set_args(nil, true)
        else
          set_args(args.fargs)
        end
      end, { force = true, nargs = "*" })

      local set_host = function(arg, force)
        if arg then
          state.host = arg
        elseif force or state.host == nil then
          local placeholder = state.host or "localhost:"
          local tmp = vim.fn.input("Hostname: ", placeholder)
          if tmp ~= nil and tmp ~= "" then
            state.host = tmp
          end
        end
        return state.host
      end
      vim.api.nvim_create_user_command("DapSetHost", function(args)
        if args.args == "" then
          set_host(nil, true)
        else
          set_host(args.args)
        end
      end, { force = true, nargs = "?" })

      local configurations = {
        codelldb = {
          type = "codelldb",
          request = "launch",
          cwd = "${workspaceFolder}",
          stopOnEntry = true,
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
          stopOnEntry = true,
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
            name = "Launch",
            program = set_target,
            args = set_args,
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
        local midebpath = get_path("lldb-mi", vim.env["HOME"] .. "/.local/bin/lldb-mi")
        for _, common_conf in ipairs(configurations.common) do
          common_conf.miDebuggerPath = midebpath
          local configuration = vim.tbl_deep_extend("force", configurations.cppdbg, common_conf)
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
            miDebuggerServerAddress = set_host,
            miDebuggerPath = get_path({ "gdb" }, "/usr/bin/gdb"),
            cwd = "${workspaceFolder}",
            program = set_target,
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
        command = vim.env["HOME"] .. "/.local/venvs/debugpy/bin/python",
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

      require("nvim-dap-virtual-text").setup({})
      require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
          { name = "dap" },
        },
      })
    end,
  },
}
