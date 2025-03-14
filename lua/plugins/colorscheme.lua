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
            TelescopeBorder = {
              fg = "palette.blue",
              bg = vim.g.transparent and "" or "palette.bg1",
            },
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
            ["@type.builtin"] = { fg = "palette.yellow", style = "italic" },
            ["@constant.builtin"] = { style = "bold" },
            ["@lsp.type.unresolvedReference.rust"] = {},
            ["@parameter"] = { fg = "palette.red.bright" },
          },
        },
      })
      for type, icon in pairs(vim.g.signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
      vim.cmd.colorscheme(vim.g.nightfox_flavour)
    end,
  },
}
