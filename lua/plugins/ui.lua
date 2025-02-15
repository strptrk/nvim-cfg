local resize_edgy = function(edgy_win, direction, size)
  local dimension = (direction == "h" or direction == "l") and "width" or "height"
  local on_edge = (vim.fn.winnr(direction) == vim.fn.winnr()) and -1 or 1
  edgy_win:resize(dimension, on_edge * size)
end

local symbols = {
  left_five_eights_block = "▋",
  right_five_eights_block = "🮉",
  full_block = "█"
}

return {
  {
    "folke/edgy.nvim",
    event = "User VeryVeryLazy",
    opts = function()
      local opts = {
        options = {
          right = { size = 35 },
          left = { size = 28 },
        },
        animate = {
          fps = 60,
          cps = 120,
        },
        keys = { ---@format disable
          ["<A-C-h>"] = function(win) resize_edgy(win, "h", 2) end,
          ["<A-C-j>"] = function(win) resize_edgy(win, "j", 2) end,
          ["<A-C-k>"] = function(win) resize_edgy(win, "k", 2) end,
          ["<A-C-l>"] = function(win) resize_edgy(win, "l", 2) end,
        }, ---@format enable
        left = {
          {
            title = "Files",
            ft = "neo-tree",
            filter = function(buf)
              return vim.b[buf].neo_tree_source == "filesystem"
            end,
            size = { height = 0.4 },
          },
          {
            title = "Git",
            ft = "neo-tree",
            filter = function(buf)
              return vim.b[buf].neo_tree_source == "git_status"
            end,
            open = "Neotree position=right git_status",
            size = { height = 0.32 },
          },
          {
            title = "Buffers",
            ft = "neo-tree",
            filter = function(buf)
              return vim.b[buf].neo_tree_source == "buffers"
            end,
            open = "Neotree position=top buffers",
            size = { height = 0.28 },
          },
        },
        bottom = {
          { ft = "qf", title = "QuickFix List" },
        },
      }
      --   ({ "top", "bottom", "left", "right" })
      for _, pos in ipairs({ "bottom", "right" }) do
        opts[pos] = opts[pos] or {}
        for mode, title in pairs({
          ["diagnostics"]          = "Diagnostics",
          ["lsp"]                  = "LSP",
          ["lsp_declarations"]     = "LSP Declarations",
          ["lsp_definitions"]      = "LSP Definitions",
          ["lsp_document_symbols"] = "LSP Document Symbols",
          ["lsp_implementations"]  = "LSP Implementations",
          ["lsp_incoming_calls"]   = "LSP Incoming Calls",
          ["lsp_outgoing_calls"]   = "LSP Outgoing Calls",
          ["lsp_references"]       = "LSP References",
          ["lsp_type_definitions"] = "LSP Type Definitions",
          ["loclist"]              = "Location List",
          ["qflist"]               = "Quickfix List",
          ["quickfix"]             = "Quickfix List",
          ["symbols"]              = "LSP Document Symbols",
          ["telescope"]            = "Telescope",
        }) do
          table.insert(opts[pos], {
            title = title,
            ft = "trouble",

            filter = function(_, win)
              return vim.w[win].trouble
                  and vim.w[win].trouble.position == pos
                  and vim.w[win].trouble.mode == mode
                  and vim.w[win].trouble.type == "split"
                  and vim.w[win].trouble.relative == "editor"
                  and not vim.w[win].trouble_preview
            end,
          })
        end
      end
      return opts
    end,
  },
  {
    "b0o/incline.nvim",
    lazy = true,
    event = "User VeryVeryLazy",
    config = function()
      require("incline").setup({
        debounce_threshold = {
          falling = 500,
          rising = 250,
        },
        hide = {
          cursorline = false,
          focused_win = false,
          only_win = true,
        },
        highlight = {
          groups = {
            InclineNormal = {
              default = true,
              group = "NormalFloat",
            },
            InclineNormalNC = {
              default = true,
              group = "NormalFloat",
            },
          },
        },
        ignore = {
          buftypes = "special",
          filetypes = {},
          floating_wins = true,
          unlisted_buffers = true,
          wintypes = "special",
        },
        render = function(props)
          local bufname = vim.api.nvim_buf_get_name(props.buf)
          local filename = vim.fn.fnamemodify(bufname, ":t")
          if not filename or (filename == "") then
            filename = "[No Name]"
          end
          local modified = vim.api.nvim_get_option_value("modified", { buf = props.buf }) and "bold,italic" or "None"
          local filetype_icon, color = require("nvim-web-devicons").get_icon_color(filename)
          local buffer = {
            { filetype_icon, guifg = color },
            { " " },
            { filename,      gui = modified },
          }
          return buffer
        end,
        window = {
          margin = {
            horizontal = 1,
            vertical = 1,
          },
          options = {
            signcolumn = "no",
            wrap = false,
          },
          padding = 1,
          padding_char = " ",
          placement = {
            horizontal = "right",
            vertical = "top",
          },
          width = "fit",
          winhighlight = {
            active = {
              EndOfBuffer = "None",
              Normal = "InclineNormal",
              Search = "None",
            },
            inactive = {
              EndOfBuffer = "None",
              Normal = "InclineNormalNC",
              Search = "None",
            },
          },
          zindex = 50,
        },
      })
    end,
  },
  {
    'echasnovski/mini.hipatterns',
    version = false,
    lazy    = true,
    cmd     = { "Hi" },
    keys    = {
      { "<Space>hi", "<cmd>Hi<cr>", desc = "Toggle Highlight Patterns" }
    },
    config  = function()
      local hipatterns = require('mini.hipatterns')
      local default = {
        delay = { text_change = 200 },
        highlighters = {}
      }
      hipatterns.setup(default)

      vim.api.nvim_set_hl(0, "MiniHippaterns_trail_virtualtext", { fg = "#fc2d2d" })

      local hi_commands = {}

      hi_commands[""] = function() hipatterns.toggle(0) end
      hi_commands["toggle"] = function() hipatterns.toggle(0) end
      hi_commands["enable"] = function() hipatterns.enable(0) end
      hi_commands["disable"] = function() hipatterns.disable(0) end
      hi_commands["clear"] = function()
        vim.b.minihipatterns_config = nil
        hipatterns.disable(0)
      end
      hi_commands["config"] = function() print(vim.inspect(vim.b.minihipatterns_config)) end
      hi_commands["todo"] = function()
        if not vim.b.minihipatterns_config.highlighters.fixme then
          vim.b.minihipatterns_config = vim.tbl_deep_extend("force", vim.b.minihipatterns_config, {
            highlighters = {
              -- more or less emulates treesitter-comment's behaviour, but is activated
              -- everywhere, not just in comments
              ---@format disable
                fixme  = { pattern = '%f[%w]()FIXME()%f[%W]', group = '@comment.error' },
                fixme_ = { pattern = 'FIXME%(()[^)]*()%)',    group = 'Number' },
                fix    = { pattern = '%f[%w]()FIX()%f[%W]',   group = '@comment.warning' },
                fix_   = { pattern = 'FIX%(()[^)]*()%',       group = 'Number' },
                hack   = { pattern = '%f[%w]()HACK()%f[%W]',  group = '@comment.warning' },
                hack_  = { pattern = 'HACK%(()[^)]*()%)',     group = 'Number' },
                todo   = { pattern = '%f[%w]()TODO()%f[%W]',  group = '@comment.todo' },
                todo_  = { pattern = 'TODO%(()[^)]*()%)',     group = 'Number' },
                note   = { pattern = '%f[%w]()NOTE()%f[%W]',  group = '@comment.note' },
                note_  = { pattern = 'NOTE%(()[^)]*()%)',     group = 'Number' },
                xxx    = { pattern = '%f[%w]()XXX()%f[%W]',   group = '@comment.note' },
                xxx_   = { pattern = 'XXX%(()[^)]*()%)',      group = 'Number' },
                error  = { pattern = '%f[%w]()ERROR()%f[%W]', group = '@comment.error' },
                error_ = { pattern = 'ERROR%(()[^)]*()%)',    group = 'Number' },
                ---@format enable
            }
          })
        end
        hipatterns.disable(0)
        hipatterns.enable(0)
      end

      hi_commands["color"] = function()
        if not vim.b.minihipatterns_config.highlighters.hex_color then
          vim.b.minihipatterns_config = vim.tbl_deep_extend("force", vim.b.minihipatterns_config, {
            highlighters = {
              hex_color = hipatterns.gen_highlighter.hex_color()
            }
          })
        end
        hipatterns.disable(0)
        hipatterns.enable(0)
      end

      hi_commands["trail"] = function()
        if not vim.b.minihipatterns_config.highlighters.trail then
          vim.b.minihipatterns_config = vim.tbl_deep_extend("force", vim.b.minihipatterns_config, {
            highlighters = {
              trail = {
                pattern = "%f[%s]()%s*()$",
                group = "",
                extmark_opts = function(_, match, _)
                  local mask = ""
                  for char in string.gmatch(match, ".") do
                    if char == string.char(9) then -- TAB
                      mask = mask ..
                          string.rep(
                            symbols.full_block,
                            vim.api.nvim_get_option_value("tabstop", { scope = "local" }) or 4)
                    else
                      mask = mask .. symbols.full_block
                    end
                  end
                  return {
                    virt_text = { { mask, 'Error' } },
                    virt_text_pos = 'overlay',
                    priority = 100,
                    right_gravity = false,
                  }
                end,
              }
            }
          })
        end
        hipatterns.disable(0)
        hipatterns.enable(0)
      end

      local hi_completion = vim.tbl_keys(hi_commands)

      vim.api.nvim_create_user_command("Hi", function(args)
        vim.b.minihipatterns_config = vim.b.minihipatterns_config or default
        local hi_cmd = hi_commands[args.args]
        if hi_cmd == nil then
          vim.notify("No such argument: " .. args.args, vim.log.levels.WARN, { title = "Highlight Pattern" })
        else
          hi_cmd()
        end
      end, {
        force = true,
        nargs = "?",
        complete = function()
          return hi_completion
        end,
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    lazy = true,
    event = "User VeryVeryLazy",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    config = function()
      local lsps = {}

      local trouble = {
        loaded = false,
        symbols = {
          get = function() return "" end,
          has = function() return false end,
        }
      }
      local get_lsp = function(bufnr)
        bufnr = bufnr or vim.api.nvim_win_get_buf(0)
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        if #clients == 0 then return "" end
        return table.concat(vim.tbl_map(function(client) return client.name end, clients), ",")
      end
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          lsps[args.buf] = get_lsp(args.buf)
          if not trouble.loaded then
            trouble.symbols = require("trouble").statusline({
              mode = "lsp_document_symbols",
              groups = {},
              title = false,
              filter = { range = true },
              format = "{kind_icon}{symbol.name:Normal}",
              hl_group = "lualine_c_normal",
            })
            trouble.loaded = true
          end
        end
      })
      vim.api.nvim_create_autocmd("LspDetach", {
        callback = function(args)
          lsps[args.buf] = nil
        end
      })

      local conditions = {
        has_filename = function()
          return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
        end,
        window_width_over = function(w)
          return function()
            return vim.fn.winwidth(0) > w
          end
        end,
        editor_width_over = function(w)
          return function()
            return vim.api.nvim_get_option_value("columns", {}) > w
          end
        end,
      }

      local sources = {
        gs_diff = function()
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then
            return {
              added = gitsigns.added,
              modified = gitsigns.changed,
              removed = gitsigns.removed
            }
          end
        end
      }
      local palette = require('nightfox.palette').load(vim.g.nightfox_flavour)
      local colors = {
        blue = palette.blue.base,
        green = palette.green.base,
        purple = palette.magenta.base,
        cyan = palette.cyan.base,
        red = palette.red.base,
        orange = palette.orange.base,
        yellow = palette.yellow.base,
        teal = palette.cyan.dim,
        fg = palette.fg2,
        bg = palette.bg0,
      }

      local mode_color = {
        n = colors.blue,
        i = colors.green,
        v = colors.purple,
        [''] = colors.purple,
        V = colors.purple,
        c = colors.yellow,
        no = colors.blue,
        s = colors.red,
        S = colors.red,
        [''] = colors.red,
        ic = colors.yellow,
        R = colors.red,
        Rv = colors.red,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ['r?'] = colors.cyan,
        ['!'] = colors.orange,
        t = colors.yellow,
      }

      local opts = {
        options = {
          icons_enabled = true,
          theme = {
            normal = { c = "LualineCustom" },
            inactive = { c = "LualineCustom" },
          },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {},
          always_divide_middle = false,
          globalstatus = true,
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              function()
                return symbols.left_five_eights_block .. ' '
              end,
              color = function()
                return { fg = mode_color[vim.fn.mode()], }
              end,
              padding = { right = 1 },
            },
            {
              "filename",
              cond = conditions.has_filename,
              color = function()
                return {
                  fg = mode_color[vim.fn.mode()],
                  gui = "bold",
                }
              end,
              padding = { left = 1, right = 1 }
            },
            {
              "b:gitsigns_head",
              icon = "",
              color = { fg = colors.fg },
              cond = conditions.editor_width_over(70),
            },
            {
              "diff",
              cond = conditions.editor_width_over(80),
              padding = { left = 0 },
              source = sources.gs_diff,
            },
            {
              function()
                return '%='
              end
            },
            {
              function()
                return trouble.symbols.get()
              end,
              cond = function()
                return conditions.has_filename()
                    and conditions.editor_width_over(110)()
                    and trouble.symbols.has()
              end,
            },
          },
          lualine_x = {
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return require("noice").api.status.mode.has()
              end,
              color = {
                fg = colors.yellow,
                bg = colors.bg,
              },
            },
            {
              function()
                return require("noice").api.status.search.get()
              end,
              cond = function()
                return require("noice").api.status.search.has()
              end,
              color = {
                fg = colors.cyan,
                bg = colors.bg,
              },
            },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              padding = { right = 0 },
              cond = conditions.editor_width_over(100),
            },
            {
              function()
                return lsps[vim.api.nvim_get_current_buf()] or ""
              end,
              icon = '',
              color = { fg = colors.green, gui = 'bold' },
            },
            {
              "filetype",
              color = { gui = 'bold' },
              padding = { left = 1, right = 0 }
            },
            {
              "location",
              color = function()
                return {
                  fg = mode_color[vim.fn.mode()],
                  gui = "bold",
                }
              end,
              padding = { left = 1, right = 1 }
            },
            {
              "selectioncount",
              color = { fg = colors.teal },
              icon = "~",
              padding = { left = 0, right = 1 },
            },
            {
              'fileformat',
              icons_enabled = false,
              color = function()
                return { fg = mode_color[vim.fn.mode()], }
              end,
              cond = conditions.has_filename,
              padding = { left = 0, right = 0 }
            },
            {
              "encoding",
              color = function()
                return { fg = mode_color[vim.fn.mode()], }
              end,
              padding = { left = 1, right = 0 },
            },
            {
              "filesize",
              color = function()
                return { fg = mode_color[vim.fn.mode()], }
              end,
              padding = { left = 1, right = 0 }
            },
            {
              function()
                return symbols.right_five_eights_block
              end,
              color = function()
                return { fg = mode_color[vim.fn.mode()], }
              end,
              padding = { left = 1 },
            },
          },
          lualine_y = {},
          lualine_z = {},
        },
        inactive_sections = {},
        tabline = {},
        extensions = { "quickfix", "nvim-dap-ui", "trouble", "oil" },
      }
      require("lualine").setup(opts)
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      override = { zsh = { icon = "", color = "#428850", name = "Zsh" } },
      default = true,
    },
  },
  {
    "akinsho/bufferline.nvim",
    lazy = true,
    event = "User VeryVeryLazy",
    opts = {
      -- highlights = require("catppuccin.groups.integrations.bufferline").get(),
      options = {
        mode = "tabs",
        themable = true,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            separator = true,
          },
        },
        show_duplicate_prefix = false,
        hover = {
          enabled = false,
        },
        always_show_bufferline = false,
        separator_style = { "|", "|" },
      },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    lazy = true,
    init = function()
      vim.api.nvim_create_user_command("Redir", function(args)
        require("noice").redirect(args.args)
      end, { nargs = "+" })
      vim.api.nvim_create_user_command("Hls", function()
        require("noice").redirect("hi")
        vim.cmd([[Hi color]])
      end, {})
      vim.api.nvim_create_user_command("Ins", function()
        require("noice").redirect("Inspect")
        vim.cmd([[Hi color]])
      end, {})
    end,
    keys = { ---@format disable
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<c-f>",     function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, mode = { "i", "n", "s" }, desc = "Scroll forward" },
      { "<c-b>",     function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, mode = { "i", "n", "s" }, desc = "Scroll backward" },
      { ",n",        function() require("noice").cmd("dismiss") end, silent = true, mode = "n", desc = "Clear Noice" },
      { "<Space>I", "<cmd>Ins<cr>", desc = "Inspect Highlight for Token"}
    }, ---@format enable
    opts = {
      cmdline = {
        view = "cmdline",
        format = {
          -- integrate into lualine
          cmdline     = { icon = symbols.left_five_eights_block .. "   " },
          search_down = { icon = symbols.left_five_eights_block .. "    " },
          search_up   = { icon = symbols.left_five_eights_block .. "    " },
          filter      = { icon = symbols.left_five_eights_block .. "   󰈲 " },
          lua         = { icon = symbols.left_five_eights_block .. "    " },
          help        = { icon = symbols.left_five_eights_block .. "    " },
          input       = { icon = "󰥻 " },
        }
      },
      popupmenu = {
        enabled = false, -- enables the Noice popupmenu UI
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
        signature = {
          enabled = true
        },
        hover = {
          enabled = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
        {
          view = "split",
          filter = { event = "msg_show", min_height = 20 },
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = {
          views = {
            hover = {
              border = {
                style = vim.g.float_border_style,
              },
              position = { row = 2, col = 2 },
            },
          },
        },
      },
      views = {
        cmdline_popup = {
          border = {
            style = "none",
            padding = { 0, 1 },
          },
          position = {
            row = -1,
            col = "50%",
          },
          filter_options = {},
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
        popupmenu = {
          relative = "editor",
          position = {
            row = 8,
            col = "50%",
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = vim.g.float_border_style,
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          },
        },
      },
    },
    dependencies = {
      {
        "rcarriga/nvim-notify",
        lazy = true,
        init = function()
          ---@diagnostic disable-next-line: duplicate-set-field
          vim.notify = function(...) require("notify")(...) end
        end,
        config = function()
          require("notify").setup({
            top_down = false,
            render = "wrapped-compact",
          })
        end,
      },
      {
        "stevearc/dressing.nvim",
        lazy = true,
        event = "User VeryVeryLazy",
        init = function()
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "DressingSelect",
            callback = function(ev)
              vim.api.nvim_win_set_cursor(0, { 1, 1 })
              vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = ev.buf })
            end
          })
        end,
        opts = {
          input = { enabled = false },
          select = {
            backend = { "builtin", "telescope", "nui" },
            builtin = {
              relative = "cursor",
              min_width = { 50, 0.25 },
              min_height = { 12, 0.25 },
            }
          }
        },
      }
    },
  },
}
