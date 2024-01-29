return {
  {
    'hrsh7th/nvim-cmp',
    lazy = true,
    version = false,
    event = 'VeryLazy',
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
      end
      cmp.setup({
        enabled = function()
          return vim.api.nvim_get_option_value('buftype', { buf = 0 }) ~= 'prompt' or
              require('cmp_dap').is_dap_buffer()
        end,
        view = {
          entries = 'custom',
        },
        -- sorting = { -- undecided whether or not to include, needs some testing
        --   comparators = {
        --     require("clangd_extensions.cmp_scores")
        --   }
        -- },
        performance = {
          max_view_entries = 12,
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            local kind = require('lspkind').cmp_format({
              mode = 'symbol_text',
              maxwidth = 50,
            })(entry, vim_item)
            local strings = vim.split(kind.kind, '%s', { trimempty = true })
            kind.kind = ' ' .. (strings[1] or '') .. ' '
            kind.menu = '    (' .. (strings[2] or '') .. ')'
            return kind
          end,
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        window = {
          completion = {
            winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
            col_offset = -3,
            side_padding = 0,
          },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<A-Tab>'] = cmp.mapping.abort(),
          ['<C-h>'] = function()
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            end
          end,
          ['<C-l>'] = function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end,
          ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
              -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
              -- they way you will only jump inside the snippet region
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
      })
      local default_cmp_sources = {
        { name = 'nvim_lsp',   priority = 1000 },
        { name = 'luasnip',    priority = 990 },
        { name = 'path',       priority = 700 },
      }
      vim.api.nvim_create_autocmd('BufReadPre', {
        callback = function(args)
          local too_big = require('helper_utils').file_too_big(96)
          local sources = default_cmp_sources
          if not too_big(args.buf) then
            table.insert(sources, {name = 'treesitter', priority = 800})
            table.insert(sources, {name = 'buffer',     priority = 600})
          end
          cmp.setup.buffer({
            sources = sources
          })
        end
      })

      cmp.setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, {
        sources = {
          { name = 'dap' },
        },
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        view = {
          entries = 'custom',
        },
        sources = {
          { name = 'buffer' },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        view = {
          entries = 'custom',
        },
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          { name = 'cmdline' },
        }),
      })
    end,
    dependencies = {
      {
        'strptrk/lspkinder.nvim',
        config = function()
          require('lspkind').setup({
            symbol_map = {},
          })
        end
      },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
      { 'rcarriga/cmp-dap' },
      { 'ray-x/cmp-treesitter' },
      {
        'saadparwaiz1/cmp_luasnip',
        config = function()
          require('luasnip.loaders.from_snipmate').lazy_load({ paths = './snippets' })
        end,
        dependencies = {
          {
            'L3MON4D3/LuaSnip',
          },
        },
      },
    },
  },
}
