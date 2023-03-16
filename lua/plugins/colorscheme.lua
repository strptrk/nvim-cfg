return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.termguicolors = true
      require('catppuccin').setup({
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        background = {
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = false,
        show_end_of_buffer = true, -- show the '~' characters after the end of buffers
        term_colors = false,
        dim_inactive = {
          enabled = true,
          shade = 'dark',
          percentage = 0.15,
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        styles = {
          comments = {},
          conditionals = { 'bold' },
          loops = { 'bold' },
          functions = { 'bold' },
          keywords = {},
          strings = {},
          variables = {},
          numbers = { 'bold' },
          booleans = { 'bold' },
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {
          mocha = {
            base = '#1c1c1c',
            mantle = '#181815',
            crust = '#111111',
            text = '#d6dff9',
          },
        },
        custom_highlights = {
          HopNextKey = { fg = '#F72044', style = {'bold'} },
          HopNextKey1 = { fg = '#F72044', style = {'bold'} },
          HopNextKey2 = { fg = '#f7a156' },
        },
        integrations = {
          -- cmp = true,
          gitsigns = true,
          neotree = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          notify = true,
          harpoon = true,
          dap = {
            enabled = true,
            enable_ui = true,
          },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { 'italic' },
              hints = { 'italic' },
              warnings = { 'italic' },
              information = { 'italic' },
            },
            underlines = {
              errors = { 'underline' },
              hints = { 'underline' },
              warnings = { 'underline' },
              information = { 'underline' },
            },
          },
          symbols_outline = true,
          sandwich = true,
          which_key = true,
          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },
        },
      })
      vim.cmd.colorscheme('catppuccin')
    end,
  },
}
