return {
  {
    'neovim/nvim-lspconfig',
    ft = {
      'python',
      'lua',
      'go',
    },
    lazy = true,
    dependencies = {
      {
        'ray-x/lsp_signature.nvim',
        lazy = true,
        config = function()
          require('lsp_signature').setup({
            floating_window = false,
            hint_prefix = ' ',
          })
        end,
      },
      {
        'j-hui/fidget.nvim',
        lazy = true,
        config = function()
          require('fidget').setup({
            window = {
              blend = 0,
            },
            text = {
              spinner = 'dots',
            },
          })
        end,
      },
    },
    config = function()
      local lsp = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      lsp.pylsp.setup({ capabilities = capabilities })
      lsp.gopls.setup({ capabilities = capabilities })
      lsp.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = {
                'vim',
              },
            },
            workspace = {
              library = {
                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                [vim.fn.stdpath('config') .. '/lua'] = true,
              },
            },
          },
          telemetry = {
            enable = false,
          },
        },
      })
    end,
  },
  {
    'p00f/clangd_extensions.nvim',
    lazy = true,
    ft = { 'c', 'cpp' },
    config = function()
      require('clangd_extensions').setup({
        server = {
          capabilities = require('cmp_nvim_lsp').default_capabilities(),
        }, -- options to pass to nvim-lspconfig
        extensions = {
          -- defaults:
          -- Automatically set inlay hints (type hints)
          autoSetHints = true,
          -- These apply to the default ClangdSetInlayHints command
          inlay_hints = {
            -- Only show inlay hints for the current line
            only_current_line = false,
            -- Event which triggers a refersh of the inlay hints.
            -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
            -- not that this may cause  higher CPU usage.
            -- This option is only respected when only_current_line and
            -- autoSetHints both are true.
            only_current_line_autocmd = 'CursorHold',
            -- whether to show parameter hints with the inlay hints or not
            show_parameter_hints = true,
            -- prefix for parameter hints
            parameter_hints_prefix = '<- ',
            -- prefix for all the other hints (type, chaining)
            other_hints_prefix = '=> ',
            -- whether to align to the length of the longest line in the file
            max_len_align = false,
            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,
            -- whether to align to the extreme right or not
            right_align = false,
            -- padding from the right if right_align is true
            right_align_padding = 7,
            -- The color of the hints
            highlight = 'InlayHint',
            -- The highlight group priority for extmark
            priority = 100,
          },
          ast = {
            role_icons = {
              type = '',
              declaration = '',
              expression = '',
              specifier = '',
              statement = '',
              ['template argument'] = '',
            },
            kind_icons = {
              Compound = '',
              Recovery = '',
              TranslationUnit = '',
              PackExpansion = '',
              TemplateTypeParm = '',
              TemplateTemplateParm = '',
              TemplateParamObject = '',
            },
            highlights = {
              detail = 'Comment',
            },
          },
          memory_usage = {
            border = 'rounded',
          },
          symbol_info = {
            border = 'rounded',
          },
        },
      })
    end,
  },
  {
    'simrat39/rust-tools.nvim',
    lazy = true,
    ft = { 'rust' },
    config = function()
      local rt = require('rust-tools')
      rt.setup({
        server = {
          capabilities = require('cmp_nvim_lsp').default_capabilities(),
          on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set('n', 'sH', rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set('n', '<Space>A', rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
        tools = {
          inlay_hints = {
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
            highlight = "InlayHint"
          }
        }
      })
    end,
  },
}
