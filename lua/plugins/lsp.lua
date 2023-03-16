return {
  {
    'neovim/nvim-lspconfig',
    ft = {
      'c', 'cpp',
      'python',
      'rust',
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
              blend = 0
            },
            text = {
              spinner = 'dots',
            },
          })
        end,
      },
    },
    config = function()
      local coq = require('coq')
      local lsp = require('lspconfig')
      lsp.clangd.setup(coq.lsp_ensure_capabilities())
      lsp.pylsp.setup(coq.lsp_ensure_capabilities())
      lsp.gopls.setup(coq.lsp_ensure_capabilities())
      lsp.rust_analyzer.setup(coq.lsp_ensure_capabilities({
        settings = {
          ['rust-analyzer'] = {},
        },
      }))
      lsp.lua_ls.setup(coq.lsp_ensure_capabilities({
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
      }))
    end,
  },
}
