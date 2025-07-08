return {
  {
    "folke/snacks.nvim",
    priority = 1001,
    lazy = false,
    keys = { ---@format disable
      { "<A-C-c>",   function() Snacks.bufdelete() end,                    desc = "Delete buffer" },
      { ",B",        function() Snacks.gitbrowse() end,                    desc = "Git Browse", mode = { "n", "v" } },
      { ",h",        function() Snacks.image.hover() end,                  desc = "Show Image" },
      { ",l",        function() Snacks.lazygit() end,                      desc = "Lazygit" },
      { ",L",        function() Snacks.lazygit.log_file() end,             desc = "Lazygit (log current file)" },
      { "gI",        function() Snacks.picker.lsp_implementations() end,   desc = "Go to Implementation" },
      { "<Space>,",  function() Snacks.picker.resume() end,                desc = "Resume previous picker" },
      { "<Space>u",  function() Snacks.picker.undo() end,                  desc = "Undo" },
      { "<Space>z",  function() Snacks.picker.zoxide() end,                desc = "Zoxide" },
      { "<Space>f",  function() Snacks.picker.files() end,                 desc = "Find Files" },
      { "<Space>F",  function() Snacks.picker.git_files() end,             desc = "Find Files (Git)" },
      { "<Space>g",  function() Snacks.picker.grep() end,                  desc = "Grep" },
      { "<Space>M",  function() Snacks.picker.marks() end,                 desc = "Marks" },
      { "<Space>h;", function() Snacks.picker.command_history() end,       desc = "Command History" },
      { "<Space>h/", function() Snacks.picker.search_history() end,        desc = "Search History" },
      { "<Space>H",  function() Snacks.picker.help() end,                  desc = "Help" },
      { "<Space>R",  function() Snacks.picker.registers() end,             desc = "Registers" },
      { "<Space>l",  function() Snacks.picker.loclist() end,               desc = "Diagnostic Loclist" },
      { "<Space>qf", function() Snacks.picker.qflist() end,                desc = "Quickfix list" },
      { "<Space>w",  function() Snacks.picker.grep_word() end,             desc = "Grep current word", mode = { "n", "x" } },
      { "<Space>J",  function() Snacks.picker.jump() end,                  desc = "Jumplist" },
      { "<Space>b",  function() Snacks.picker.buffers() end,               desc = "Buffers" },
      { "<Space>da", function() Snacks.picker.diagnostics() end,           desc = "LSP diagnostics (all)" },
      { "<Space>df", function() Snacks.picker.diagnostics_buffer() end,    desc = "LSP diagnostics (all)" },
      { "<Space>sd", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols (document)" },
      { "<Space>sw", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Symbols (workspace)" },
      { "<Space>/",  function() Snacks.picker.lines({ layout = "ivy" }) end, desc = "Grep current buffer" },
      { "<Space>;",  function() Snacks.picker.commands({ layout = 'select' }) end, desc = "Commands" },
      { "<space>ss", function() Snacks.picker.spelling({ layout = { preset = "select", layout = { relative = "cursor" } } }) end, desc = "Spell suggest" },
      { "<Space>de", function() Snacks.picker.diagnostics({ severity = vim.diagnostic.severity.ERROR }) end,   desc = "LSP errors" },
      { "<Space>dw", function() Snacks.picker.diagnostics({ severity = vim.diagnostic.severity.WARN }) end, desc = "LSP warnings" },
      { "<Space>W",  function() Snacks.picker.grep({ search = vim.fn.expand("%:t"), args = { "--fixed-strings" } }) end, desc = "Grep current file name" },
      { "<Space><Space>", function() Snacks.picker.smart() end, desc = "Smart File Picker" },
      {
        "<Space>sf", function()
          Snacks.picker.lsp_symbols({ filter = { default = { "Constructor", "Function", "Interface", "Method" } } })
        end, desc = "LSP Functions (document)"
      },
      {
        "<Space>sF", function()
          Snacks.picker.lsp_workspace_symbols({ filter = { default = { "Constructor", "Function", "Interface", "Method" } } })
        end, desc = "LSP Functions (workspace)",
      },
      { "gr",  function() Snacks.picker.lsp_references() end,        desc = "Go to References" },
      { "gdd", function() Snacks.picker.lsp_definitions() end,       desc = "Go to Definition" },
      { "gdT", function() Snacks.picker.lsp_type_definitions() end,  desc = "Go to Type Definition" },
      { "gdh", function() require("config.utils").split("h", Snacks.picker.lsp_definitions, { zz = true }) end, desc = "Go to Definition (split left)" },
      { "gdj", function() require("config.utils").split("j", Snacks.picker.lsp_definitions, { zz = true }) end, desc = "Go to Definition (split down)" },
      { "gdk", function() require("config.utils").split("k", Snacks.picker.lsp_definitions, { zz = true }) end, desc = "Go to Definition (split up)" },
      { "gdl", function() require("config.utils").split("l", Snacks.picker.lsp_definitions, { zz = true }) end, desc = "Go to Definition (split right)" },
      { "gR",  function() require("config.utils").fntab(Snacks.picker.lsp_references) end,                      desc = "Go to References (new tab)" },
      { "gdt", function() require("config.utils").fntab(Snacks.picker.lsp_definitions, { zz = true }) end,      desc = "Go to Definition (new tab)" },
      { ",z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    }, ---@format enable
    opts = {
      styles = {
        input = {
          position = "float",
          relative = "cursor",
        },
      },
      bufdelete = { enabled = true },
      git = { enabled = true },
      gitbrowse = { enabled = true },
      image = { enabled = true },
      input = {
        prompt_pos = "title",
        enabled = true,
      },
      lazygit = { enabled = true },
      picker = {
        enabled = true,
        layout = {
          preset = "ivy",
          position = "bottom"
        },
        matcher = {
          cwd_bonus = true,
          history_bonus = true,
          frecency = false,
        },
        actions = {
          trouble_open = {
            action = function(...) require('trouble.sources.snacks').open(..., { type = "smart" }) end,
            desc = "smart-open-with-trouble"
          },
          -- trouble_open_selected = {
          --   action = function(...) require('trouble.sources.snacks').open(..., { type = "selected" }) end,
          --   desc = "open-with-trouble",
          -- },
          -- trouble_open_all = {
          --   action = function(...) require('trouble.sources.snacks').open(..., { type = "all" }) end,
          --   desc = "open-all-with-trouble",
          -- },
          -- trouble_add = {
          --   action = function(...) require('trouble.sources.snacks').open(..., { type = "smart", add = true }) end,
          --   desc = "smart-add-to-trouble",
          -- },
          -- trouble_add_selected = {
          --   action = function(...) require('trouble.sources.snacks').open(..., { type = "selected", add = true }) end,
          --   desc = "add-to-trouble",
          -- },
          -- trouble_add_all = {
          --   action = function(...) require('trouble.sources.snacks').open(..., { type = "all" }) end,
          --   desc = "add-all-to-trouble",
          -- },
        },
        win = {
          input = {
            keys = {
              ["<M-t>"] = { "trouble_open", mode = { "i", "n" } },
              ["<A-q>"] = { "qflist", mode = { "i", "n" } },
              ["<M-q>"] = { "qflist_all", mode = { "i", "n" } },
            }
          }
        }
      },
      rename = { enabled = true },
      notifier = {
        enabled = true,
        top_down = false,
      },
      toggle = {
        enabled = true,
        which_key = true,
        notify = true,
      },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          {
            action = ":ene",
            key = "e",
            desc = "New File",
            icon = " ",
            padding = 1,
          },
          {
            action = ":ene | Neotree focus filesystem position=left",
            key = "t",
            desc = "File Tree",
            icon = "󱏒 ",
            padding = 1,
          },
          {
            action = function() Snacks.picker.files() end,
            key = "f",
            desc = "Find File",
            icon = " ",
            padding = 1,
          },
          {
            action = function() Snacks.picker.grep() end,
            key = "g",
            desc = "Find Text",
            icon = "󰧭 ",
            padding = 1,
          },
          {
            action = ":SessionManager load_session",
            key = "s",
            desc = "Select Session",
            icon = "󰥨 ",
            padding = 1,
          },
          {
            action = ":SessionManager load_last_session",
            key = "l",
            desc = "Load Last Session",
            icon = "󰝉 ",
            padding = 1,
          },
          {
            action = ":Lazy sync",
            key = "u",
            desc = "Update Packages",
            icon = "󰅢 ",
            padding = 1,
          },
          {
            action = ":qa!",
            key = "q",
            desc = "Quit",
            icon = "󰿅 ",
            padding = 1,
          },
          { section = "startup" },
        },
      },
      zen = { enabled = true },
      bigfile = { enabled = false },
      explorer = { enabled = false },
      indent = { enabled = false },
      quickfile = { enabled = false },
      scope = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
    },
    init = function()
      vim.g.dashboard_shown = false
      vim.api.nvim_create_autocmd("User", {
        pattern = "SnacksDashboardOpened",
        once = true,
        callback = function()
          vim.g.dashboard_shown = true
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "SnacksDashboardClosed",
        once = true,
        callback = function()
          vim.api.nvim_exec_autocmds("User", { pattern = "VeryVeryLazy" })
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          if not vim.g.dashboard_shown then
            vim.api.nvim_exec_autocmds("User", { pattern = "VeryVeryLazy" })
          end
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader><leader>w")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader><leader>r")
          Snacks.toggle.diagnostics():map("<leader><leader>d")
          Snacks.toggle.line_number():map("<leader><leader>n")
          Snacks.toggle
              .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
              :map("<leader><leader>c")
          Snacks.toggle.treesitter():map("<leader><leader>t")
          Snacks.toggle.inlay_hints():map("<leader><leader>h")
          Snacks.toggle.dim():map("<leader><leader>D")
        end,
      })
    end,
  },
}
