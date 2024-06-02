return {
  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    version = false,
    event = "VeryLazy",
    config = function()
      local cmp = require("cmp")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local luasnip = require("luasnip")
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local too_big = require("cfg.utils").file_too_big(128)
      local get_bufnrs = function()
        local bufs = vim.api.nvim_list_bufs()
        local result = {}
        for _, bufnr in ipairs(bufs) do
          if not too_big(bufnr) then
            result[#result + 1] = bufnr
          end
        end

        return result
      end

      cmp.setup({
        enabled = function()
          if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
            return false
          end
          if require("cmp_dap").is_dap_buffer() then
            return true
          end

          local context = require("cmp.config.context")
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          else
            return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
          end
        end,
        view = {
          entries = "custom",
        },
        performance = {
          max_view_entries = 12,
        },
        sources = cmp.config.sources({
          { name = "luasnip", priority = 1000 },
          { name = "nvim_lsp", priority = 900 },
          { name = "path", priority = 700 },
          {
            name = "treesitter",
            priority = 800,
            option = {
              indexing_interval = 1000,
              max_indexed_line_length = 512,
              get_bufnrs = get_bufnrs,
            },
          },
          {
            name = "buffer",
            priority = 600,
            option = {
              indexing_interval = 1000,
              max_indexed_line_length = 512,
              get_bufnrs = get_bufnrs,
            },
          },
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({
              mode = "symbol_text",
              maxwidth = 50,
            })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "    (" .. (strings[2] or "") .. ")"
            return kind
          end,
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          documentation = cmp.config.window.bordered(),
          completion = {
            side_padding = 0,
          },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<A-Tab>"] = cmp.mapping.abort(),
          ["<C-h>"] = function()
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            end
          end,
          ["<C-l>"] = function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end,
          ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
      })

      cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
          { name = "dap" },
        },
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        view = {
          entries = "custom",
        },
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        view = {
          entries = "custom",
        },
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
    dependencies = {
      {
        "strptrk/lspkinder.nvim",
        config = function()
          require("lspkind").setup({
            symbol_map = {},
          })
        end,
      },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "rcarriga/cmp-dap" },
      { "ray-x/cmp-treesitter" },
      {
        "saadparwaiz1/cmp_luasnip",
        config = function()
          require("luasnip.loaders.from_snipmate").lazy_load({ paths = "./snippets" })
        end,
        dependencies = {
          {
            "L3MON4D3/LuaSnip",
          },
        },
      },
    },
  },
}
