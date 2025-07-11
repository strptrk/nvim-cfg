return {
  {
    "EdenEast/nightfox.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      local custom_palette = {
        red = "#f72044",
        orange = "#f7a156",
      }
      require("nightfox").setup({
        options = {
          transparent = vim.g.transparent,
          terminal_colors = true,
          dim_inactive = not vim.g.transparent,
          module_default = true,
          styles = {
            comments = "NONE",
            conditionals = "bold",
            constants = "NONE",
            functions = "bold",
            keywords = "NONE",
            numbers = "bold",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
            variables = "NONE",
          },
        },
        palettes = {},
        specs = {},
        groups = {
          all = {
            HopNextKey = { fg = custom_palette.red, style = "bold" },
            HopNextKey1 = { fg = custom_palette.red, style = "bold" },
            HopNextKey2 = { fg = custom_palette.orange },
            NormalFloat = {
              fg = "palette.fg1",
              bg = vim.g.transparent and "" or "palette.bg1",
            },
            MatchParen = {
              fg = "palette.orange.bright",
              style = "underline",
            },
            LualineCustom = {
              fg = "palette.fg2",
              bg = vim.g.transparent and "" or "palette.bg0",
            },
            IblIndent = { fg = "palette.bg2" },
            IblScope = { fg = "palette.black.bright" },
            MiniHippaterns_trail_virtualtext = { fg = "palette.red.base" },
            ["@lsp.typemod.function.defaultLibrary"] = { fg = "palette.cyan.bright" },
            ["@lsp.typemod.enum.globalScope.c"] = { fg = "palette.orange.bright" },
            ["@lsp.typemod.type.fileScope.c"] = { style = "italic" },
            ["@type.builtin"] = { fg = "palette.yellow", style = "italic" },
            ["@constant.builtin"] = { style = "bold" },
            ["@lsp.type.unresolvedReference.rust"] = {},
            ["@parameter"] = { fg = "palette.red.bright" },
            DapBreakpoint = { fg = "palette.red.base" },
            DapBreakpointCondition = { fg = "palette.orange.bright" },
            DapLogPoint = { fg = "palette.green.base" },
            DapStopped = { fg = "palette.yellow.base" },
            DapBreakpointRejected = { fg = "palette.cyan.bright" },
            debugPC = { bg = "palette.bg2" }
          },
        },
      })
      vim.cmd.colorscheme(vim.g.nightfox_flavour)
    end,
  },
}
