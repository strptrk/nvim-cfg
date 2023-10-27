return {
  {
    'neovim/nvim-lspconfig',
    ft = {
      'python',
      'lua',
      'go',
      'c', 'cpp',
      'cmake',
      'tex'
    },
    lazy = true,
    dependencies = {
      {
        'j-hui/fidget.nvim',
        tag = 'legacy',
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
      lsp.cmake.setup({ capabilities = capabilities })
      lsp.clangd.setup({ capabilities = capabilities })
      lsp.texlab.setup({
        capabilities = capabilities,
        settings = {
          texlab = {
            diagnostics = {
              ignoredPatterns = {
                "^Underfull \\\\[vh]box.*", -- lua escape + regex escape
                "^Overfull \\\\[vh]box.*",
                "^Unused global option\\(s\\):$",
              }
            }
          },
        }
      })
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
                -- [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                -- [vim.fn.stdpath('config') .. '/lua'] = true,
                vim.fn.expand('$VIMRUNTIME/lua'),
                vim.fn.stdpath('config') .. '/lua',
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
  {
    'nvimdev/lspsaga.nvim',
    lazy = true,
    event = { 'LspAttach' },
    keys = {
      {
        '<Space>w',
        '<cmd>Lspsaga finder<cr>',
        desc = 'LSP Finder',
      },
      {
        '<Space>ic',
        '<cmd>Lspsaga incoming_calls<cr>',
        desc = 'LSP Incoming Calls',
      },
      {
        '<Space>oc',
        '<cmd>Lspsaga outgoing_calls<cr>',
        desc = 'LSP Outgoing Calls',
      },
      {
        '<Space>a',
        '<cmd>Lspsaga code_action<cr>',
        desc = 'LSP Code Action',
      },
      {
        '<Space>p',
        '<cmd>Lspsaga peek_definition<cr>',
        desc = 'LSP Peek Definition',
      },
      {
        '<Space>k',
        '<cmd>Lspsaga hover_doc<cr>',
        desc = 'LSP Hover',
      },
      {
        'so',
        '<cmd>Lspsaga outline<cr>',
        desc = 'LSP Outline',
      },
    },
    config = function()
      require('lspsaga').setup({
        finder = {
          max_height = 0.75,
          left_width = 0.35,
          right_width = 0.35,
          default = 'tyd+def+imp+ref',
          methods = {
            ['tyd'] = 'textDocument/typeDefinition'
          },
          layout = 'float',
          keys = {
            ['shuttle'] = 'S',
            ['split'] = 's',
            ['vsplit'] = 'v',
            ['toggle_or_open'] = '<cr>',
            ['tabe'] = 't',
            ['tabnew'] = 'n',
            ['quit'] = 'q',
            ['clone'] = '<C-c><C-c>',
          }
        },
        symbol_in_winbar = {
          enable = false
        },
        callhierarchy = {
          keys = {
            ['toggle_or_req'] = 'u',
            ['edit'] = '<CR>',
            ['split'] = 's',
            ['vsplit'] = 'v',
            ['tabe'] = 't',
            ['quit'] = 'q',
            ['shuttle'] = 'S',
            ['close'] = '<C-c><C-c>',
          }
        },
        outline = {
          auto_preview = false,
          keys = {
            ['toggle_or_jump'] = '<CR>',
            ['edit'] = 'e'
          },
        },
        ui = {
          devicon = false,
          code_action = ' '
        }
      })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons'
    }
  }
}
