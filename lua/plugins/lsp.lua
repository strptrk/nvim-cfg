return {
  {
    "neovim/nvim-lspconfig",
    ft = {
      "python",
      "lua",
      "go",
      "c",
      "cpp",
      "cmake",
      "tex",
    },
    lazy = true,
    config = function()
      local lsp = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      if 1 == vim.fn.executable("gopls") then
        lsp.gopls.setup({ capabilities = capabilities })
      end
      if 1 == vim.fn.executable("cmake-language-server") then
        lsp.cmake.setup({ capabilities = capabilities })
      end
      if 1 == vim.fn.executable("pylsp") then
        lsp.pylsp.setup({
          capabilities = capabilities,
          settings = {
            pylsp = {}
          }
        })
      end
      if 1 == vim.fn.executable("ruff") then
        lsp.ruff.setup({
          capabilities = capabilities,
          init_options = {
            settings = {
              logLevel = "debug"
            }
          }
        })
      end
      if 1 == vim.fn.executable("clangd") then
        lsp.clangd.setup({
          capabilities = capabilities,
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        })
      end
      if 1 == vim.fn.executable("texlab") then
        lsp.texlab.setup({
          capabilities = capabilities,
          settings = {
            texlab = {
              diagnostics = {
                ignoredPatterns = {
                  "^Underfull \\\\[vh]box.*", -- lua escape + regex escape
                  "^Overfull \\\\[vh]box.*",
                  "^Unused global option\\(s\\):$",
                },
              },
            },
          },
        })
      end
      if 1 == vim.fn.executable("lua-language-server") then
        lsp.lua_ls.setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = {
                globals = {
                  "vim",
                },
              },
              workspace = {
                library = {
                  vim.env.VIMRUNTIME,
                  vim.fn.stdpath("config") .. "/lua",
                },
              },
            },
            telemetry = {
              enable = false,
            },
          },
        })
      end
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.keymap.set("n", "sh", vim.lsp.buf.hover, { desc = "Symbol hover information" })
          vim.keymap.set("n", "<Space>a", vim.lsp.buf.code_action, { desc = "Code Actions" })
          vim.keymap.set({ "n", "x" }, "sf", vim.lsp.buf.format, { desc = "Format document (lsp)" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
          vim.keymap.set("n", "<Space>sh", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "Switch source and header" })
          local methods = vim.lsp.protocol.Methods
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.supports_method(methods.textDocument_inlayHint) then
            vim.keymap.set("n", "si", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ buf = ev.buf }), { buf = ev.buf })
            end, { desc = "Toggle inlay hints" })
            vim.lsp.inlay_hint.enable(false, { buf = ev.buf })
          end
          if client and client.supports_method(methods.textDocument_rename) then
            vim.keymap.set("n", "ss", function()
              require("cfg.utils").smart_rename_lsp(client, ev.buf)
            end, { desc = "LSP rename", buffer = ev.buf })
          end
        end,
      })
    end,
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    ft = { "c", "cpp" },
    opts = {
      inlay_hints = {
        inline = vim.fn.has("nvim-0.10") == 1,
        only_current_line = false,
        only_current_line_autocmd = { "CursorHold" },
        show_parameter_hints = true,
        parameter_hints_prefix = "<- ",
        other_hints_prefix = "=> ",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
        priority = 100,
      },
      ast = {
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },

        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
        highlights = {
          detail = "Comment",
        },
      },
      memory_usage = {
        border = "rounded",
      },
      symbol_info = {
        border = "rounded",
      },
    },
  },
  {
    "simrat39/rust-tools.nvim",
    lazy = true,
    ft = { "rust" },
    config = function()
      local rt = require("rust-tools")
      rt.setup({
        server = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set("n", "sH", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "sA", rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
        tools = {
          inlay_hints = {
            auto = false,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
            highlight = "InlayHint",
          },
        },
      })
    end,
  },
  {
    "folke/trouble.nvim",
    lazy = true,
    event = { "LspAttach" },
    keys = { ---@format disable
      { "<Space>dd", "<cmd>Trouble diagnostics focus filter.buf=0 win.position=bottom<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "sl",        "<cmd>Trouble lsp focus win.position=right<cr>",                       desc = "LSP (Trouble)" },
      { "sL",        "<cmd>Trouble loclist toggle focus=true win.position=bottom<cr>",      desc = "Location List (Trouble)" },
      { "sq",        "<cmd>Trouble qflist toggle focus=true win.position=bottom<cr>",       desc = "Quickfix List (Trouble)" },
      { "so",        "<cmd>Trouble lsp_document_symbols focus win.position=right<cr>",      desc = "LSP Symbols Outline (Trouble)" },
      { "<Space>t",  "<cmd>Trouble telescope toggle focus=true win.position=bottom<cr>",    desc = "Trouble Telescope" },
    }, ---@format enable
    opts = {
      win = {
        border = "rounded",
      },
      keys = {
        i = "inspect",
        p = "preview",
        P = "toggle_preview",
        zo = "fold_open",
        zO = "fold_open_recursive",
        c = "fold_close",
        C = "fold_close_recursive",
        f = "fold_toggle",
        F = "fold_toggle_recursive",
        zm = "fold_more",
        zM = "fold_close_all",
        zr = "fold_reduce",
        ze = "fold_open_all",
        zx = "fold_update",
        zX = "fold_update_all",
        zn = "fold_disable",
        zN = "fold_enable",
        t = "fold_toggle_enable",
        b = {
          action = function(view)
            view:filter({ buf = 0 }, { toggle = true })
          end,
          desc = "Toggle Current Buffer Filter",
        },
        s = {
          action = function(view)
            local f = view:get_filter("severity")
            local severity = ((f and f.filter.severity or 0) + 1) % 5
            view:filter({ severity = severity }, {
              id = "severity",
              template = "{hl:Title}Filter:{hl} {severity}",
              del = severity == 0,
            })
          end,
          desc = "Toggle Severity Filter",
        },
      },
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    lazy = true,
    event = { "LspAttach" },
    keys = {
      { "sco", "<cmd>Lspsaga outgoing_calls<cr>",  desc = "LSP Outgoing calls" },
      { "sci", "<cmd>Lspsaga incoming_calls<cr>",  desc = "LSP Incoming calls" },
      { "sw",  "<cmd>Lspsaga finder<cr>",          desc = "LSP Finder" },
      { "sp",  "<cmd>Lspsaga peek_definition<cr>", desc = "LSP Peek Definition" },
    },
    opts = {
      finder = {
        max_height = 0.75,
        left_width = 0.35,
        right_width = 0.35,
        default = "tyd+def+imp+ref",
        methods = {
          ["tyd"] = "textDocument/typeDefinition",
        },
        layout = "float",
        keys = {
          ["shuttle"] = "S",
          ["split"] = "s",
          ["vsplit"] = "v",
          ["toggle_or_open"] = "<cr>",
          ["tabe"] = "t",
          ["tabnew"] = "n",
          ["quit"] = { "q", "<esc>" },
          ["clone"] = "<C-c><C-c>",
        },
      },
      symbol_in_winbar = {
        enable = false,
      },
      callhierarchy = {
        keys = {
          ["toggle_or_req"] = "u",
          ["edit"] = "<CR>",
          ["split"] = "s",
          ["vsplit"] = "v",
          ["tabe"] = "t",
          ["quit"] = { "q", "<esc>" },
          ["shuttle"] = "S",
          ["close"] = "<C-c><C-c>",
        },
      },
      outline = {
        auto_preview = false,
        keys = {
          ["toggle_or_jump"] = "<CR>",
          ["edit"] = "e",
        },
      },
      lightbulb = {
        virtual_text = false,
      },
      ui = {
        devicon = false,
        code_action = "",
        kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
      },
    },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter", lazy = true },
      { "nvim-tree/nvim-web-devicons", lazy = true }
    },
  },
}
