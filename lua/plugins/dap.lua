return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text",   lazy = true },
      { "nvim-neotest/nvim-nio",             lazy = true },
      { "folke/snacks.nvim",                 lazy = false },
      {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        cmd = {
          "DapSelectTarget",
          "DapSetTarget",
          "DapSetArgs",
          "DapSetHost",
          "DapCommands",
        },
        keys = { ---@format disable
          { "<BS>E", function() require("dapui").close() end, desc = "Debug: Close DAP UI" },
          { "<BS>b", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
          { "<BS>B", function() require("dap").set_breakpoint(vim.fn.input("Condition:")) end, desc = "Debug: Set Conditional Breakpoint" },
          { "<BS>H", function() require("dap").set_breakpoint(vim.fn.input("Condition:"), vim.fn.input("Hit Condition:")) end, desc = "Debug: Set Conditional Breakpoint with Hit Condition" },
          { "<BS>c", function() require("dap").continue() end, desc = "Debug: Continue" },
          { "<BS>i", function() require("dap").step_into() end, desc = "Debug: Step Into" },
          { "<BS>o", function() require("dap").step_over() end, desc = "Debug: Step Over" },
          { "<BS>O", function() require("dap").step_out() end, desc = "Debug: Step Out" },
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
          { "<BS>;",  "<cmd>DapCommands<cr>", desc = "Debug: DAP Commands" },
          { "<BS>t", function() require("config.utils").fntab(function() require("dapui").toggle() end, { zz = true }) end,           desc = "Debug: Open UI in new tab" },
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
              border = vim.g.float_border_style,
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
      local dap = require("dap")
      local daputils = require("config.daputils")

      if not daputils.snacks_available() and daputils.telescope_available() then
        require("telescope").load_extension("dap")
      end

      local ADAPTER = daputils.get_first_path({
        "lldb-mi",      -- lldb-vscode
        "OpenDebugAD7", -- cppdbg
        "codelldb",     -- codelldb
        "lldb-vscode",  -- lldb-vscode
        "lldb-dap",     -- lldb-vscode
      }, "")

      vim.api.nvim_create_user_command("DapCommands", function()
        daputils.pick_dap_commands()
      end, { force = true, nargs = 0 })

      vim.api.nvim_create_user_command("DapSelectTarget", function(args)
        local opts = {
          force = true,
          callback = require("dapui").open
        }
        if args.args and args.args ~= "" then
          opts.cwd = args.args
        end
        daputils.pick_target(opts)
      end, { force = true, nargs = "?", complete = "dir" })

      vim.api.nvim_create_user_command("DapSetTarget", function(args)
        if args.args == "" then
          daputils.set_target(nil, true)
        else
          if string.sub(args.args, 1, 1) == "/" then
            daputils.set_target(args.args)
          else
            daputils.set_target(vim.fn.getcwd() .. "/" .. args.args)
          end
        end
      end, { force = true, nargs = "?", complete = "file" })

      vim.api.nvim_create_user_command("DapSetArgs", function(args)
        if #args.fargs == 0 then
          daputils.set_args(nil, true)
        else
          daputils.set_args(args.fargs)
        end
      end, { force = true, nargs = "*" })

      vim.api.nvim_create_user_command("DapSetHost", function(args)
        if args.args == "" then
          daputils.set_host(nil, true)
        else
          daputils.set_host(args.args)
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
            program = daputils.set_target,
            args = daputils.set_args,
          },
        },
      }
      if string.match(ADAPTER, "codelldb$") then
        dap.adapters.codelldb = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = daputils.get_first_path({ "codelldb" }),
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
          command = daputils.get_first_path({ "OpenDebugAD7" }, vim.env["HOME"] .. "/.local/bin/OpenDebugAD7"),
        }
        dap.configurations.cpp = {}
        local midebpath = daputils.get_first_path("lldb-mi", vim.env["HOME"] .. "/.local/bin/lldb-mi")
        for _, common_conf in ipairs(configurations.common) do
          common_conf.miDebuggerPath = midebpath
          local configuration = vim.tbl_deep_extend("force", configurations.cppdbg, common_conf)
          table.insert(dap.configurations.cpp, configuration)
        end
      elseif string.match(ADAPTER, "OpenDebugAD7$") then
        dap.adapters.cppdbg = {
          id = "cppdbg",
          type = "executable",
          command = daputils.get_first_path({ "OpenDebugAD7" }, vim.env["HOME"] .. "/.local/bin/OpenDebugAD7"),
        }
        dap.configurations.cpp = {
          {
            name = "Attach to gdbserver",
            type = "cppdbg",
            request = "launch",
            MIMode = "gdb",
            miDebuggerServerAddress = daputils.set_host,
            miDebuggerPath = daputils.get_first_path({ "gdb" }),
            cwd = "${workspaceFolder}",
            program = daputils.set_target,
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
          command = daputils.get_first_path({
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
              return daputils.get_first_path({ venv and (venv .. "/bin/python") or "python", "python3" }, nil)
            end
          end,
        },
      }

      dap.listeners.after.event_initialized["dapui_config"] = function()
        require("dapui").open({})
      end

      require("nvim-dap-virtual-text").setup({})

      -- for project-specific configs in .nvim.lua files
      vim.api.nvim_exec_autocmds("User", { pattern = "DapConfigLoaded" })
    end,
  },
}
