return {
  {
    "akinsho/toggleterm.nvim",
    lazy = true,
    cmd = { "TermExec", "ToggleTerm", "ToggleTermSetName", "TermSelect", "TermNew" },
    keys = {
      { "<A-f>",   nil, desc = "Open Terminal" },
      { "<A-F>",   nil, desc = "Open Terminal (floating)" },
      { "<A-B>",   nil, desc = "Select Terminal" },
      { "<A-N>",   nil, desc = "Set Terminal Name" },
      { "<A-r>",   nil, desc = "Run Command in Terminal" },
      { "<A-C-r>", nil, desc = "Set Command to Run" },
      { "<A-R>",   nil, desc = "Toggle Run Terminal" },
      { "<A-v>f",  nil, desc = "Open Terminal (float)" },
      { "<A-v>t",  nil, desc = "Open Terminal (tab)" },
      { "<A-v>v",  nil, desc = "Open Terminal (vertical)" },
      { "<A-v>h",  nil, desc = "Open Terminal (horizontal)" },
      { "<A-v>l",  nil, desc = "Open Terminal (vertical)" },
      { "<A-v>j",  nil, desc = "Open Terminal (horizontal)" },
    },
    init = function()
      vim.g.default_runcmds = {
        ["c"] = function()
          local filename = vim.fn.expand("%:t")
          local filename_stripped = vim.fn.expand("%:t:r")
          return string.format(
            "cc -Wall -Wextra -g %s -o %s && ./%s",
            filename, filename_stripped, filename_stripped
          )
        end,
        ["cpp"] = function()
          local compiler
          if 1 == vim.fn.executable("clang++") then
            compiler = "clang++"
          elseif 1 == vim.fn.executable("g++") then
            compiler = "g++"
          else
            return ""
          end
          local filename = vim.fn.expand("%:t")
          local filename_stripped = vim.fn.expand("%:t:r")
          return string.format(
            "%s -Wall -Wextra -g %s -o %s && ./%s",
            compiler, filename, filename_stripped, filename_stripped
          )
        end,
        ["rust"] = function()
          -- are we in a git directory with a Cargo.toml present
          if 1 == vim.fn.executable("git") then
            local obj = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait()
            if obj.code == 0 and vim.uv.fs_stat(vim.fn.trim(obj.stdout) .. "/Cargo.toml") then
              return "cargo run"
            end
          end
          local filename = vim.fn.expand("%:t")
          local filename_stripped = vim.fn.expand("%:t:r")
          return string.format(
            "rustc -g %s -o %s && ./%s",
            filename, filename_stripped, filename_stripped
          )
        end,
        ["haskell"] = function()
          return string.format("runghc %s", vim.fn.expand("%:t"))
        end,
        ["lua"] = function()
          return string.format("lua %s", vim.fn.expand("%:t"))
        end,
        ["python"] = function()
          return string.format("python3 %s", vim.fn.expand("%:t"))
        end,
        ["perl"] = function()
          return string.format("perl %s", vim.fn.expand("%:t"))
        end,
        ["bash"] = function()
          return string.format("bash %s", vim.fn.expand("%:t"))
        end,
        ["sh"] = function()
          return string.format("sh %s", vim.fn.expand("%:t"))
        end
      }
      ---@param name string
      ---@return boolean
      vim.g.is_term = function(name)
        return string.match(name, "#toggleterm#") and true or false
      end
      ---@param name string
      ---@return string
      vim.g.term_name_fmt = function(name)
        local tname, nrepl = string.gsub(
          name,
          ".*;#toggleterm",
          "Terminal "
        )
        if nrepl == 0 then
          tname = "Terminal " .. tname
        end
        return tname
      end
      vim.g.term_name_to_display_name = function(name)
        local termnr = string.match(name, "#toggleterm#([0-9]+)")
        if not termnr then
          return name
        end
        local term = require("toggleterm.terminal").get(tonumber(termnr))
        if not term then
          return name
        end
        return term.display_name
      end
    end,
    config = function()
      Term = {}
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 12
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.3
          end
        end,
        open_mapping = nil,
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = false,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = "horizontal",
        close_on_exit = true,
        autochdir = true,
        autoscroll = true,
        float_opts = { border = vim.g.float_border_style, winblend = 0 },
        on_create = function(term)
          term.display_name = vim.g.term_name_fmt(term.name)
        end,
        on_open = function(term)
          if term.direction ~= "float" then
            vim.wo[term.window].winbar = "%#Title# " .. term.display_name
          else
            vim.wo[term.window].winbar = ""
          end
          vim.w[term.window].term = {
            name = term.name,
          }
        end,
        winbar = {
          enabled = false
        },
      })

      local Terminal = require("toggleterm.terminal").Terminal

      Term.Terminals = {}
      Term.Last = -1

      Term.add_term = function(num, dir)
        Term.Terminals[num] = {
          term = Terminal:new({
            direction = dir or "float",
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

      local picker_get_terminals = function()
        local items = {}
        for _, t in pairs(Term.Terminals) do
          local term = t.term
          table.insert(items, {
            text = term.display_name or term.name,
            preview = {
              text = term.display_name or term.name,
            },
            buf = term.buf,
            value = term
          })
        end
        return items
      end

      local picker_preview = function(ctx)
        ctx.preview:set_buf(ctx.item.value.bufnr)
        ctx.preview:wo({
          number = false,
          relativenumber = false,
          cursorline = false,
          signcolumn = "no",
        })
      end

      -- BUG: size and direction persistence dont work with split terminals,
      -- because it messes with the internals of toggleterm
      -- workaround: use non-preview pickers for split terminals
      Term.select_open_term = function(opts)
        opts = opts or {}
        local layout = opts.layout and { preset = opts.layout } or nil
        Snacks.picker.pick({
          source = "Open Terminal",
          items = picker_get_terminals(),
          preview = picker_preview,
          format = "text",
          layout = layout,
          confirm = function(picker, item)
            picker:close()
            if not item then
              return
            end
            Term.focus_term(item.value.count)
            vim.cmd.startinsert()
          end,
        })
      end

      Term.rename_term = function(opts)
        opts = opts or {}
        local layout = opts.layout and { preset = opts.layout } or nil
        Snacks.picker.pick({
          source = "Rename Terminal",
          items = picker_get_terminals(),
          preview = picker_preview,
          format = "text",
          layout = layout,
          confirm = function(picker, item)
            picker:close()
            if not item then
              return
            end
            local name = vim.fn.input({ prompt = "Name:" })
            if name and name ~= "" then
              item.value.display_name = vim.g.term_name_fmt(name)
            end
          end,
        })
      end

      Term.runterm = Terminal:new({
        direction = "vertical",
        hidden = true,
        count = 1001,
      })
      Term.runterm_toggle = function()
        Term.runterm:toggle()
      end

      Term.runterm_run = function()
        if Term.runcmd == nil then
          local default_runcmd
          local filename = vim.api.nvim_buf_get_name(0)
          local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
          if vim.uv.fs_access(filename, "x") and string.match(first_line, "^#!") then
            default_runcmd = "./" .. vim.fn.expand("%:t")
          else
            local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
            if vim.g.default_runcmds[ft] then
              default_runcmd = vim.g.default_runcmds[ft]()
            else
              default_runcmd = ""
            end
          end
          local input = vim.fn.input("Command to run: ", default_runcmd)
          if not input or input == "" then
            return
          end
          Term.runcmd = input
          if not Term.runterm:is_open() then
            Term.runterm:open()
          end
          Term.runterm:send(Term.runcmd, true)
        else
          if not Term.runterm:is_open() then
            Term.runterm:open()
          end
          Term.runterm:send(Term.runcmd, true)
        end
      end

      Term.runterm_askcmd = function()
        local input = vim.fn.input("Command to run: ", Term.runcmd or "")
        if not input or input == "" then
          return
        else
          Term.runcmd = input
        end
      end

      vim.api.nvim_create_user_command("RunTermDir", function(args)
        local dir = args.fargs[1]
        if not dir or dir == "" then
          return
        end
        if Term.runterm:is_open() then
          Term.runterm:close()
        end
        Term.runterm:change_direction(dir)
        Term.runterm:open()
      end, {
        force = true,
        nargs = "?",
        complete = function()
          return { "horizontal", "vertical", "float" }
        end
      })

      vim.keymap.set({ "n", "t", "x" }, "<A-R>", function()
        Term.runterm_toggle()
      end, { desc = "Set Command to Run" })
      vim.keymap.set({ "n", "t", "x" }, "<A-C-r>", function()
        Term.runterm_askcmd()
      end, { desc = "Toggle Run Terminal" })
      vim.keymap.set({ "n", "t", "x" }, "<A-r>", function()
        Term.runterm_run()
      end, { desc = "Run Command in Terminal" })

      vim.keymap.set({ "n", "v", "t" }, [[<A-f>]], function()
        if vim.v.count == 0 then
          Term.focus_last()
        else
          Term.focus_term(vim.v.count, nil)
        end
      end, { desc = "Open terminal" })

      vim.keymap.set({ "n", "v", "t" }, [[<A-B>]], function()
        Term.select_open_term({ layout = "default" })
      end, { desc = "Select Terminal" })

      vim.keymap.set({ "n", "v", "t" }, [[<A-N>]], function()
        Term.rename_term({ layout = "default" })
      end, { desc = "Set Terminal Name" })

      vim.keymap.set({ "n", "v", "t" }, [[<A-F>]], function()
        Term.focus_last("float")
      end, { desc = "Open Terminal (floating)" })

      local directions = {
        f = "float",
        t = "tab",
        v = "vertical",
        l = "vertical",
        h = "horizontal",
        j = "horizontal",
      }
      for k, _ in string.gmatch("ftvhjl", ".") do
        vim.keymap.set({ "n", "v", "t" }, [[<A-v>]] .. k, function()
          if vim.v.count == 0 then
            Term.focus_last(directions[k])
          else
            Term.focus_term(vim.v.count, directions[k])
          end
        end, { desc = "Open Terminal (" .. directions[k] .. ")" })
      end
    end,
  },
}
