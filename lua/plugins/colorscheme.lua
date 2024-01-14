return {
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      local transparent = os.getenv('TRANSPARENT') == "1"
      require('onedark').setup {
        -- Main options --
        style = 'dark',               -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
        transparent = transparent,    -- Show/hide background
        term_colors = true,           -- Change terminal color as per the selected theme style
        ending_tildes = false,        -- Show the end-of-buffer tildes. By default they are hidden
        cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

        -- toggle theme style ---
        toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"

        -- Change code style ---
        -- Options are italic, bold, underline, none
        -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
        code_style = {
          comments = 'none',
          conditionals = 'bold',
          loops = 'bold',
          keywords = 'none',
          strings = 'none',
          variables = 'none',
          functions = 'none',
          numbers = 'bold',
          booleans = 'bold',
        },

        -- Lualine options --
        lualine = {
          transparent = false, -- lualine center bar transparency
        },
        colors = {},
        highlights = {
          CmpItemKindSnippet = { fg = "$bg0", bg = "$red" },
          CmpItemKindKeyword = { fg = "$bg0", bg = "$dark_red" },
          CmpItemKindText = { fg = "$bg0", bg = "$green" },
          CmpItemKindMethod = { fg = "$bg0", bg = "$blue" },
          CmpItemKindConstructor = { fg = "$bg0", bg = "$blue" },
          CmpItemKindFunction = { fg = "$bg0", bg = "$blue" },
          CmpItemKindFolder = { fg = "$bg0", bg = "$blue" },
          CmpItemKindModule = { fg = "$bg0", bg = "$blue" },
          CmpItemKindConstant = { fg = "$bg0", bg = "$yellow" },
          CmpItemKindField = { fg = "$bg0", bg = "$green" },
          CmpItemKindProperty = { fg = "$bg0", bg = "$green" },
          CmpItemKindEnum = { fg = "$bg0", bg = "$green" },
          CmpItemKindUnit = { fg = "$bg0", bg = "$green" },
          CmpItemKindClass = { fg = "$bg0", bg = "$yellow" },
          CmpItemKindVariable = { fg = "$bg0", bg = "$dark_purple" },
          CmpItemKindFile = { fg = "$bg0", bg = "$blue" },
          CmpItemKindInterface = { fg = "$bg0", bg = "$yellow" },
          CmpItemKindColor = { fg = "$bg0", bg = "$red" },
          CmpItemKindReference = { fg = "$bg0", bg = "$red" },
          CmpItemKindEnumMember = { fg = "$bg0", bg = "$red" },
          CmpItemKindStruct = { fg = "$bg0", bg = "$blue" },
          CmpItemKindValue = { fg = "$bg0", bg = "$yellow" },
          CmpItemKindEvent = { fg = "$bg0", bg = "$blue" },
          CmpItemKindOperator = { fg = "$bg0", bg = "$blue" },
          CmpItemKindTypeParameter = { fg = "$bg0", bg = "$blue" },
          HopNextKey = { fg = '#F72044', style = { 'bold' } },
          HopNextKey1 = { fg = '#F72044', style = { 'bold' } },
          HopNextKey2 = { fg = '#f7a156' },
          Pmenu = { fg = "$fg", bg = "$bg3" },
          InlayHint = { fg = "$bg_yellow", bg = "$bg1", style = { 'italic' } },
        },

        -- Plugins Config --
        diagnostics = {
          darker = false,    -- darker colors for diagnostic
          undercurl = true,  -- use undercurl instead of underline for diagnostics
          background = true, -- use background color for virtual text
        },
      }
      vim.cmd.colorscheme('onedark')
    end,
  }
}
