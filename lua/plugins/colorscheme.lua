return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      -- "mocha" is just used as a custom colorscheme not related to
      -- catppuccin, instead of creating a new plugin
      local override = "_"
      if vim.g.catppuccin_flavour == "custom" then
        vim.g.catppuccin_flavour = "mocha"
        override = "mocha"
      end
      local transparent = vim.env["TERM_TRANSPARENT"] ~= nil
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
          [override] = {
            rosewater = "#f2d5cf",
            flamingo = "#eebebe",
            pink = "#f4b8e4",
            mauve = "#ca9ee6",
            red = "#de6e7c",
            maroon = "#ea999c",
            peach = "#ef9f76",
            yellow = "#d8be75",
            green = "#a6d189",
            teal = "#75bab0",
            sky = "#8cc4ce",
            sapphire = "#65b8c1",
            blue = "#8caaee",
            lavender = "#c0c1f9",
            text = "#d7d7d7",
            subtext1 = "#b3b8cc",
            subtext0 = "#a2a8bf",
            overlay2 = "#969cb5",
            overlay1 = "#8a91aa",
            overlay0 = "#737994",
            surface2 = "#777777", -- 󰥓
            surface1 = "#666666", -- 󰇴
            surface0 = "#2c2c2c",
            base = "#191919",
            mantle = "#141414",
            crust = "#101010",
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
            ["@lsp.typemod.function.defaultLibrary"] = { fg = C.sky },
            ["@constant.builtin"] = { style = { "bold" } },
            -- clear this one because it colors everything red??
            ["@lsp.type.unresolvedReference.rust"] = {},
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
            NoiceCmdline = {
              bg = C.crust
            }
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
