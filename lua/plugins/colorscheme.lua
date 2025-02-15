return {
  {
    "EdenEast/nightfox.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      local transparent = vim.env["TERM_TRANSPARENT"] ~= nil
      require('nightfox').setup({
        options = {
          transparent = transparent,
          terminal_colors = true,
          dim_inactive = true,
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
            HopNextKey = { fg = "#F72044", style = "bold" },
            HopNextKey1 = { fg = "#F72044", style = "bold" },
            HopNextKey2 = { fg = "#F7A156" },
            ["@lsp.typemod.function.defaultLibrary"] = { fg = "palette.cyan" },
            ["@type.builtin"] = { fg = "palette.yellow", style = "italic" },
            ["@constant.builtin"] = { style = "bold" },
            ["@lsp.type.unresolvedReference.rust"] = {},
            -- TabLinexxx guifg=#abb1bb guibg=#39404f
            -- TabLineSelxxx guifg=#2e3440 guibg=#7e8188
            -- TabLineFillxxx guibg=#232831
            TelescopeBorder = {
              fg = "palette.blue",
              bg = transparent and "" or "palette.bg1",
            },
            LualineCustom = {
              fg = "palette.fg2",
              bg = transparent and "" or "palette.bg0",
            },
          }
        },
      })
      vim.cmd.colorscheme(vim.g.nightfox_flavour)
    end,
  }
}
