return { {
  'EdenEast/nightfox.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    local transparent = true
    require('nightfox').setup({
      options = {
        transparent = transparent,
        dim_inactive = not transparent,
        module_default = true,
        styles = {
          comments = 'NONE',
          conditionals = 'bold',
          constants = 'bold',
          functions = 'nocombine,bold',
          keywords = 'NONE',
          numbers = 'bold',
          operators = 'NONE',
          strings = 'NONE',
          types = 'NONE',
          variables = 'NONE',
        },
        inverse = {
          match_paren = false,
          visual = false,
          search = false,
        },
        modules = {},
      },
      palettes = {
        nordfox = {
          bg1 = "#343438",
          bg0 = "#0f0f10",
        }
      },
      specs = {},
      groups = {
        all = {
          HopNextKey = { fg = '#F72044', style = 'bold' },
          HopNextKey1 = { fg = '#F72044', style = 'bold' },
          HopNextKey2 = { fg = '#f7a156' },
          TreesitterContext = { bg = '#3a3a3c' },
          TabLine = { bg = "#212121", fg = "#dedede" },
          TabLineFill = { bg = "NONE" },
          TabLineSel = { bg = "#4c4c4c", fg = "#ffffff" }
        },
      },
    })
    vim.cmd.colorscheme("nordfox")
    vim.o.laststatus = 3
  end,
} }
