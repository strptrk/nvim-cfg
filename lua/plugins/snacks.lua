return {
  {
    "folke/snacks.nvim",
    priority = 1001,
    lazy = false,
    keys = { ---@format disable
      { "<A-C-c>", function() Snacks.bufdelete() end,        desc = "Delete buffer" },
      { ",B",      function() Snacks.gitbrowse() end,        desc = "Git Browse", mode = { "n", "v" } },
      { ",h",      function() Snacks.image.hover() end,      desc = "Show Image" },
      { ",l",      function() Snacks.lazygit() end,          desc = "Lazygit" },
      { ",L",      function() Snacks.lazygit.log_file() end, desc = "Lazygit (log current file)" },
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
      picker = { enabled = true },
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
            action = ":Telescope find_files",
            key = "f",
            desc = "Find File",
            icon = " ",
            padding = 1,
          },
          {
            action = ":Telescope live_grep",
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
    },
    init = function()
      vim.g.dashboard_shown = false
      vim.api.nvim_create_autocmd("User", {
        pattern = "SnacksDashboardOpened",
        callback = function()
          vim.g.dashboard_shown = true
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "SnacksDashboardClosed",
        callback = function()
          vim.api.nvim_exec_autocmds("User", { pattern = "VeryVeryLazy" })
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
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
