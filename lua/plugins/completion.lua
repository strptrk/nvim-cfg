return {
  {
    'saghen/blink.cmp',
    lazy = true,
    event = "InsertEnter",
    keys = {
      { ":", ":", mode = { "x", "n" } },
      { ";", ":", mode = { "x", "n" } },
      { "/", "/", mode = { "x", "n" } },
    },
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        lazy = true,
        config = function()
          require("luasnip.loaders.from_snipmate").lazy_load()
        end,
      }
    },
    version = '*',
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = {
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },

        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },

        ['<C-l>'] = { 'snippet_forward' },
        ['<C-h>'] = { 'snippet_backward' },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },

        cmdline = {
          ['<C-space>'] = { 'show', 'fallback' },
          ['<C-e>'] = { 'hide', 'fallback' },
          ['<CR>'] = {
            function(cmp)
              cmp.accept({
                callback = function()
                  vim.api.nvim_feedkeys('\n', 'n', true)
                end,
              })
            end,
            "fallback"
          },
          ['<Tab>'] = { 'select_next', 'fallback' },
          ['<S-Tab>'] = { 'select_prev', 'fallback' },
          ['<Up>'] = { 'select_prev', 'fallback' },
          ['<Down>'] = { 'select_next', 'fallback' },
        }
      },

      snippets = { preset = "luasnip" },

      completion = {
        list = {
          selection = {
            preselect = false
          }
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 50,
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
            -- kind_icon, kind, label, label_description, source_name
            columns = {
              {
                "kind_icon", gap = 1,
              },
              {
                "label", "label_description",
              },
              {
                "source_name"
              }
            },
          }
        },
      },

      signature = { enabled = false },

      appearance = {
        nerd_font_variant = "mono"
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = { name = " LSP" },
          path = { name = "PATH" },
          snippets = { name = "SNIP" },
          buffer = { name = " BUF" },
        }
      },
    },
    opts_extend = { "sources.default" }
  },
}
