return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      local transparent = (vim.env["W_TRANSPARENT"] or vim.env["TRANSPARENT"]) and true or false
      vim.o.termguicolors = true
      require("catppuccin").setup({
        flavour = vim.g.catppuccin_flavour,
        transparent_background = transparent,
        show_end_of_buffer = true,
        term_colors = false,
        dim_inactive = {
          enabled = not transparent,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        styles = {
          comments = {},
          conditionals = { "bold" },
          loops = { "bold" },
          functions = { "bold" },
          keywords = {},
          strings = {},
          variables = {},
          numbers = { "bold" },
          booleans = { "bold" },
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {
          all = {
            -- TODO: finish
            -- surface2 = "#6d6d6d",
            -- surface1 = "#4f4f4f",
            -- surface0 = "#3a3a3a",
            -- base = "#242424",
            -- mantle = "#1f1f1f",
            -- crust = "#1b1b1b",
          }
        },
        custom_highlights = function(C)
          return {
            CmpItemKindSnippet = { fg = C.base, bg = C.mauve },
            CmpItemKindKeyword = { fg = C.base, bg = C.red },
            CmpItemKindText = { fg = C.base, bg = C.teal },
            CmpItemKindMethod = { fg = C.base, bg = C.blue },
            CmpItemKindConstructor = { fg = C.base, bg = C.blue },
            CmpItemKindFunction = { fg = C.base, bg = C.blue },
            CmpItemKindFolder = { fg = C.base, bg = C.blue },
            CmpItemKindModule = { fg = C.base, bg = C.blue },
            CmpItemKindConstant = { fg = C.base, bg = C.peach },
            CmpItemKindField = { fg = C.base, bg = C.green },
            CmpItemKindProperty = { fg = C.base, bg = C.green },
            CmpItemKindEnum = { fg = C.base, bg = C.green },
            CmpItemKindUnit = { fg = C.base, bg = C.green },
            CmpItemKindClass = { fg = C.base, bg = C.yellow },
            CmpItemKindVariable = { fg = C.base, bg = C.flamingo },
            CmpItemKindFile = { fg = C.base, bg = C.blue },
            CmpItemKindInterface = { fg = C.base, bg = C.yellow },
            CmpItemKindColor = { fg = C.base, bg = C.red },
            CmpItemKindReference = { fg = C.base, bg = C.red },
            CmpItemKindEnumMember = { fg = C.base, bg = C.red },
            CmpItemKindStruct = { fg = C.base, bg = C.blue },
            CmpItemKindValue = { fg = C.base, bg = C.peach },
            CmpItemKindEvent = { fg = C.base, bg = C.blue },
            CmpItemKindOperator = { fg = C.base, bg = C.blue },
            CmpItemKindTypeParameter = { fg = C.base, bg = C.blue },
            HopNextKey = { fg = "#F72044", style = { "bold" } },
            HopNextKey1 = { fg = "#F72044", style = { "bold" } },
            HopNextKey2 = { fg = "#F7A156" },
            ["@lsp.typemod.function.defaultLibrary"] = { fg = C.sapphire },
            ["@constant.builtin"] = { style = { "bold" } },
            FloatBorder = { style = { "bold" } },
            TelescopeBorder = {
              fg = C.blue,
              bg = transparent and "none" or C.base,
              style = { "bold" },
            },
            LualineCustom = {
              fg = C.text,
              bg = transparent and "" or C.crust,
            },
            NoiceCmdlineIcon = {
              fg = C.rosewater,
            },
          }
        end,
        integrations = {
          cmp = true,
          gitsigns = true,
          neotree = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          notify = true,
          harpoon = true,
          dap = true,
          dap_ui = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
            inlay_hints = {
              background = true,
            },
          },
          sandwich = true,
          which_key = true,
          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
