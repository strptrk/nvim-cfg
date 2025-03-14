return {
  {
    "saghen/blink.cmp",
    lazy = true,
    event = "InsertEnter",
    keys = {
      { ":", ":", mode = { "x", "n" } },
      { ";", ":", mode = { "x", "n" } },
      { "/", "/", mode = { "x", "n" } },
    },
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        lazy = true,
        config = function()
          require("luasnip.loaders.from_snipmate").lazy_load()
        end,
      },
    },
    version = "*",
    opts = {
      keymap = {
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },

        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

        ["<C-l>"] = { "snippet_forward" },
        ["<C-h>"] = { "snippet_backward" },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },

        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },

        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
      },

      cmdline = {
        completion = {
          ghost_text = { enabled = false },
          menu = {
            auto_show = function(_)
              return vim.fn.getcmdtype() == ":"
            end,
          },
          list = { selection = { preselect = false } },
        },
        keymap = {
          ["<C-space>"] = { "show", "fallback" },
          ["<C-e>"] = { "hide", "fallback" },
          ["<CR>"] = {
            function()
              -- <C-]> to expand abbreviations
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-]><CR>", true, false, true), "n", false)
            end,
          },
          ["<Tab>"] = { "select_next", "fallback" },
          ["<S-Tab>"] = { "select_prev", "fallback" },
          ["<Up>"] = { "select_prev", "fallback" },
          ["<Down>"] = { "select_next", "fallback" },
          ["<Left>"] = { "fallback" },
          ["<Right>"] = { "fallback" },
        },
      },

      snippets = { preset = "luasnip" },

      completion = {
        list = {
          selection = {
            preselect = false,
          },
          max_items = 100,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 50,
        },
        ghost_text = {
          enabled = true,
          show_with_selection = true,
          show_without_selection = false,
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
            -- kind_icon, kind, label, label_description, source_name
            columns = {
              {
                "kind_icon",
                gap = 1,
              },
              {
                "label",
                "label_description",
              },
              {
                "source_name",
              },
            },
          },
        },
      },

      signature = { enabled = false },

      appearance = {
        nerd_font_variant = "mono",
      },

      sources = {
        default = function()
          local success, node = pcall(vim.treesitter.get_node)
          if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
            return { "buffer", "path", "snippets" }
          else
            return { "lsp", "path", "snippets", "buffer" }
          end
        end,
        providers = {
          lsp = { name = " LSP" },
          path = { name = "PATH" },
          snippets = { name = "SNIP" },
          buffer = { name = " BUF" },
          cmdline = { name = "" },
        },
      },
    },
    opts_extend = { "sources.default" },
  },
}
