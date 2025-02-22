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
      "sh",
      "bash",
      "zsh",
    },
    lazy = true,
    config = function()
      local lsp = require("lspconfig")
      local capabilities = require('blink.cmp').get_lsp_capabilities()
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
            pylsp = {
              plugins = {
                mccabe   = { enabled = true },
                pyflakes = { enabled = true },
                pylint   = { enabled = true },
                yapf     = { enabled = false },
              }
            }
          }
        })
      end
      if 1 == vim.fn.executable("ruff") then
        lsp.ruff.setup({
          capabilities = capabilities,
          trace = 'messages',
          init_options = {
            settings = {
              logLevel = "debug"
            }
          }
        })
      end
      if 1 == vim.fn.executable("bash-language-server") then
        lsp.bashls.setup({
          filetypes = { "sh", "bash", "zsh" }
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
      local progress = vim.defaulttable()
      vim.api.nvim_create_autocmd("LspProgress", {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local value = ev.data.params.value
          if not client or type(value) ~= "table" then
            return
          end
          local p = progress[client.id]

          for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
              p[i] = {
                token = ev.data.params.token,
                msg = ("[%3d%%] %s%s"):format(
                  value.kind == "end" and 100 or value.percentage or 100,
                  value.title or "",
                  value.message and (" **%s**"):format(value.message) or ""
                ),
                done = value.kind == "end",
              }
              break
            end
          end

          local msg = {}
          progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
          end, p)

          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
              notif.icon = #progress[client.id] == 0 and " "
                  or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
        end,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          --- handler-based border config will be deprecated in 0.11, but in 0.10 luals gives warnings
          --- TODO: remove in 0.11
          ---@diagnostic disable-next-line: redundant-parameter
          vim.keymap.set("n", "sh", function() vim.lsp.buf.hover({ border = { style = 'single' } }) end,
            { desc = "Symbol hover information" })
          vim.keymap.set("n", "<Space>a", vim.lsp.buf.code_action, { desc = "Code Actions" })
          vim.keymap.set({ "n", "x" }, "sf", vim.lsp.buf.format, { desc = "Format document (lsp)" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
          local methods = vim.lsp.protocol.Methods
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then
            return
          end
          if client.supports_method(methods.textDocument_inlayHint) then
            vim.keymap.set("n", "si", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ buf = ev.buf }), { buf = ev.buf })
            end, { desc = "Toggle inlay hints" })
            vim.lsp.inlay_hint.enable(false, { buf = ev.buf })
          end
          if client.supports_method(methods.textDocument_rename) then
            vim.keymap.set("n", "ss", function()
              require("cfg.utils").smart_rename_lsp(client, ev.buf)
            end, { desc = "LSP rename", buffer = ev.buf })
          end
          if client.name == "clangd" then
            vim.keymap.set("n", "<Space>sh", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "Switch source and header" })
          end
          if client.name == "ruff" then -- disable ruff hover
            client.server_capabilities.hoverProvider = false
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
        border = vim.g.float_border_style,
      },
      symbol_info = {
        border = vim.g.float_border_style,
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
          capabilities = require('blink.cmp').get_lsp_capabilities(),
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
        border = vim.g.float_border_style,
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
        enabled = true,
        virtual_text = false,
        sign = true,
      },
      ui = {
        devicon = false,
        code_action = vim.g.signs.Hint,
      },
    },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter", lazy = true },
      { "nvim-tree/nvim-web-devicons",     lazy = true }
    },
  },
}
