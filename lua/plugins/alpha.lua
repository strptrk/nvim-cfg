return {
  {
    "goolord/alpha-nvim",
    lazy = false,
    init = function()
      vim.g.dashboard_shown = false
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          if not vim.g.dashboard_shown then
            vim.api.nvim_exec_autocmds("User", { pattern = "VeryVeryLazy" })
          end
        end,
      })
    end,
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      local fortune = require("alpha.fortune")
      local cfgdir = vim.fn.stdpath("config")
      dashboard.section.buttons.val = { ---@format disable
        dashboard.button("e", "  New file", [[<cmd>ene<CR>]]),
        dashboard.button("t", "󱏒  File tree", [[<cmd>ene<bar>Neotree focus filesystem position=left<CR>]]),
        dashboard.button("f", "󰈞  Find file", [[<cmd>lua require('telescope.builtin').find_files()<CR>]]),
        dashboard.button("w", "  Find word", [[<cmd>lua require('telescope.builtin').live_grep()<CR>]]),
        dashboard.button("s", "󰥨  Load Session", "<cmd>SessionManager load_session<CR>"),
        dashboard.button("l", "󰝉  Load Last Session", "<cmd>SessionManager load_last_session<CR>"),
        dashboard.button("c", "  Config", [[<cmd>cd ]] .. cfgdir .. [[ | lua require('telescope.builtin').find_files({ cwd = ']] .. cfgdir .. [[' })<CR>]]),
        dashboard.button("u", "󰅢  Update Packages", "<cmd>Lazy sync<CR>"),
        dashboard.button("q", "󰿅  Quit NVIM", "<cmd>qa<CR>"),
      } ---@format enable
      vim.api.nvim_set_hl(0, "StartLogo1", { fg = "#51D8FF" })
      vim.api.nvim_set_hl(0, "StartLogo2", { fg = "#51D8FF" })
      vim.api.nvim_set_hl(0, "StartLogo3", { fg = "#46C7FF" })
      vim.api.nvim_set_hl(0, "StartLogo4", { fg = "#3DB5FF" })
      vim.api.nvim_set_hl(0, "StartLogo5", { fg = "#239BFE" })
      vim.api.nvim_set_hl(0, "StartLogo6", { fg = "#1672F9" })
      vim.api.nvim_set_hl(0, "StartLogo7", { fg = "#044EE3" })
      vim.api.nvim_set_hl(0, "StartLogo8", { fg = "#044EE3" })
      local header = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
      }
      local function colorize_header()
        local lines = {}
        for i, chars in pairs(header) do
          local line = {
            type = "text",
            val = chars,
            opts = { hl = "StartLogo" .. i, shrink_margin = false, position = "center" },
          }
          table.insert(lines, line)
        end
        return lines
      end
      dashboard.section.footer.val = fortune()
      local group = vim.api.nvim_create_augroup("CleanDashboard", {})
      -- fired upon entering the dashboard
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "AlphaReady",
        callback = function()
          vim.opt.showtabline = 0
          vim.opt.laststatus = 0
          vim.opt.ruler = false
          vim.g.dashboard_shown = true
        end,
      })
      -- fired upon exiting the dashboard
      vim.api.nvim_create_autocmd("BufUnload", {
        group = group,
        pattern = "<buffer>",
        callback = function()
          vim.opt.showtabline = 2
          vim.opt.ruler = true
          vim.opt.laststatus = 3
          vim.api.nvim_exec_autocmds("User", { pattern = "VeryVeryLazy" })
        end,
      })
      alpha.setup({
        layout = {
          { type = "padding", val = 4 },
          { type = "group",   val = colorize_header() },
          { type = "padding", val = 2 },
          dashboard.section.buttons,
          dashboard.section.footer,
        },
        opts = { margin = 5 },
      })
    end,
  },
}
