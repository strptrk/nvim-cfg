return {
  {
    'b0o/incline.nvim',
    lazy = true,
    event = 'VeryLazy',
    config = function()
      local get_diagnostic_label = function(props)
        local icons = {
          Error = '',
          Warn = '',
          Info = '',
          Hint = '',
        }
        local label = {}
        for severity, icon in pairs(icons) do
          local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
          if n > 0 then
            table.insert(label, { icon .. ' ' .. n .. ' ', group = 'DiagnosticSign' .. severity })
          end
        end
        return label
      end
      require('incline').setup({
        debounce_threshold = { falling = 500, rising = 250 },
        hide = {
          cursorline = false,
          focused_win = false,
          only_win = false,
        },
        highlight = {
          groups = {
            InclineNormal = {
              default = true,
              group = 'NormalFloat',
            },
            InclineNormalNC = {
              default = true,
              group = 'NormalFloat',
            },
          },
        },
        ignore = {
          buftypes = 'special',
          filetypes = {},
          floating_wins = true,
          unlisted_buffers = true,
          wintypes = 'special',
        },
        render = function(props)
          local bufname = vim.api.nvim_buf_get_name(props.buf)
          local filename = vim.fn.fnamemodify(bufname, ':t')
          if not filename or (filename == '') then
            filename = '[No Name]'
          end
          local diagnostics = get_diagnostic_label(props)
          local modified = vim.api.nvim_buf_get_option(props.buf, 'modified') and 'bold,italic' or 'None'
          local filetype_icon, color = require('nvim-web-devicons').get_icon_color(filename)
          local buffer = {
            { filetype_icon, guifg = color },
            { ' ' },
            { filename, gui = modified },
          }
          if #diagnostics > 0 then
            table.insert(diagnostics, { '| ', guifg = 'grey' })
          end
          for _, buffer_ in ipairs(buffer) do
            table.insert(diagnostics, buffer_)
          end
          return diagnostics
        end,
        window = {
          margin = {
            horizontal = 1,
            vertical = 1,
          },
          options = {
            signcolumn = 'no',
            wrap = false,
          },
          padding = 1,
          padding_char = ' ',
          placement = {
            horizontal = 'right',
            vertical = 'top',
          },
          width = 'fit',
          winhighlight = {
            active = {
              EndOfBuffer = 'None',
              Normal = 'InclineNormal',
              Search = 'None',
            },
            inactive = {
              EndOfBuffer = 'None',
              Normal = 'InclineNormalNC',
              Search = 'None',
            },
          },
          zindex = 50,
        },
      })
    end,
  },
  {
    'norcalli/nvim-colorizer.lua',
    lazy = true,
    cmd = { 'ColorizerToggle', 'ColorizerAttachToBuffer' },
    config = function()
      require('colorizer').setup({
        'css', 'html', 'lua', 'md', 'neorg'
      })
    end,
  },
  {
    'Pocco81/true-zen.nvim',
    lazy = true,
    config = function()
      require('true-zen').setup({})
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    lazy = true,
    event = {
      'BufNewFile', 'BufReadPost'
    },
    dependencies = {
      { 'kyazdani42/nvim-web-devicons' },
    },
    config = function()
      vim.g.Get_langserv = function()
        return (vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })[1] or { name = '' })['name']
      end
      vim.g.Get_treesitter = function()
        if vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil then
          return ' TS'
        else
          return ''
        end
      end

      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'catppuccin',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {},
          always_divide_middle = false,
          globalstatus = true
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            'branch',
            'diff',
            { 'diagnostics', sources = { 'nvim_diagnostic' } },
          },
          lualine_c = { 'filename' },
          lualine_x = { 'vim.g.Get_langserv()', 'vim.g.Get_treesitter()', 'filetype' },
          lualine_y = { 'fileformat', 'encoding', 'filesize' },
          lualine_z = { 'progress', 'location' },
        },
        inactive_sections = {},
        tabline = {},
        -- extensions = {'fzf', 'toggleterm', 'quickfix'}
        extensions = { 'chadtree', 'fzf', 'toggleterm', 'quickfix', 'symbols-outline' },
      })
    end,
  },
  {
    'kyazdani42/nvim-web-devicons',
    lazy = true,
    event = 'VeryLazy',
    config = function()
      require('nvim-web-devicons').setup({
        override = { zsh = { icon = '', color = '#428850', name = 'Zsh' } },
        default = true,
      })
    end,
  },
  {
    'akinsho/bufferline.nvim',
    lazy = true,
    event = {
      'BufNewFile', 'BufReadPost'
    },
    config = function()
      require('bufferline').setup({
        highlights = require("catppuccin.groups.integrations.bufferline").get(),
        options = {
          mode = 'tabs',
          themable = true,
          offsets = {
            {
              filetype = 'neo-tree',
              text = 'File Explorer',
              separator = true
            },
          },
          show_duplicate_prefix = false,
          hover = {
            enabled = false,
          },
          separator_style = {'|', '|'}
        },
      })
    end,
  },
  {
    'stevearc/dressing.nvim',
    lazy = true,
    event = 'VeryLazy',
    config = function()
      require('dressing').setup()
    end,
    dependencies = {
      {
        'rcarriga/nvim-notify',
        lazy = true,
        config = function()
          require('notify').setup({
            background_colour = '#2e3440',
            top_down = false,
          })
          vim.notify = require('notify')
        end,
      },
    },
  },
}
