local resize_edgy = function(edgy_win, direction, size)
  local dimension = (direction == "h" or direction == "l") and "width" or "height"
  local on_edge = (vim.fn.winnr(direction) == vim.fn.winnr()) and -1 or 1
  edgy_win:resize(dimension, on_edge * size)
end

local symbols = {
  left_five_eights_block = "▋",
  right_five_eights_block = "🮉",
}

local colors = {
  blue = "#61afef",
  green = "#98c379",
  purple = "#c678dd",
  cyan = "#56b6c2",
  red1 = "#ea7272",
  red2 = "#be5046",
  yellow = "#e5c07b",
  fg = "#abb2bf",
  teal = "#81c8be",
  bg = "#232323",
  gray1 = "#302f2f",
  gray2 = "#302f2f",
  gray3 = "#444444",
}

local mode_color = {
  n = colors.blue,
  i = colors.green,
  v = colors.purple,
  [''] = colors.purple,
  V = colors.purple,
  c = colors.yellow,
  no = colors.blue,
  s = colors.red1,
  S = colors.red1,
  [''] = colors.red1,
  ic = colors.yellow,
  R = colors.red1,
  Rv = colors.red1,
  cv = colors.red1,
  ce = colors.red1,
  r = colors.cyan,
  rm = colors.cyan,
  ['r?'] = colors.cyan,
  ['!'] = colors.red2,
  t = colors.yellow,
}

---@diagnostic disable-next-line: unused-local
local colorscheme = {
  normal = {
    a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
    b = { fg = colors.fg, bg = colors.gray3 },
    c = { fg = colors.fg, bg = colors.gray2 },
  },
  command = { a = { fg = colors.bg, bg = colors.purple, gui = "bold" } },
  insert = { a = { fg = colors.bg, bg = colors.green, gui = "bold" } },
  visual = { a = { fg = colors.bg, bg = colors.yellow, gui = "bold" } },
  terminal = { a = { fg = colors.bg, bg = colors.green, gui = "bold" } },
  replace = { a = { fg = colors.bg, bg = colors.red1, gui = "bold" } },
  inactive = {
    a = { fg = colors.gray1, bg = colors.bg, gui = "bold" },
    b = { fg = colors.gray1, bg = colors.bg },
    c = { fg = colors.gray1, bg = colors.gray2 },
  },
}

return {
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
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
    event = { "BufNewFile", "BufReadPost" },
    config = function()
      require("incline").setup({
        debounce_threshold = {
          falling = 500,
          rising = 250,
        },
        hide = {
          cursorline = false,
          focused_win = false,
          only_win = false,
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
    event = { "BufAdd", "BufNewFile", "BufReadPost" },
    config = function()
      local hipatterns = require('mini.hipatterns')
      hipatterns.setup({
        delay = {
          text_change = 500
        },
        highlighters = {
          -- _ = { pattern = function(buf_id) return nil|string|[string] end, group = "..." },
          -- fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          -- hack  = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
          -- todo  = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
          -- note  = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
          trailing_space = { pattern = '%f[%s]%s*$', group = 'MiniHipatternsFixme' },
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
      vim.api.nvim_create_user_command("HipatToggle", function()
        hipatterns.toggle(0)
      end, { force = true })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
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
              "location",
              color = function()
                return {
                  fg = mode_color[vim.fn.mode()],
                  gui = "bold",
                }
              end,
              padding = { left = 0, right = 0 }
            },
            {
              "selectioncount",
              color = { fg = colors.teal },
              icon = "~",
              padding = { left = 0, right = 1 },
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
              color = { fg = colors.yellow },
            },
            {
              function()
                return require("noice").api.status.search.get()
              end,
              cond = function()
                return require("noice").api.status.search.has()
              end,
              color = { fg = colors.cyan },
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
    lazy = false,
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
    "stevearc/dressing.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
      {
        "rcarriga/nvim-notify",
        lazy = true,
        config = function()
          require("notify").setup({
            background_colour = "#2e3440",
            top_down = false,
          })
          vim.notify = require("notify")
        end,
      },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    lazy = true,
    opts = {
      cmdline = {
        view = "cmdline",
        format = {
          -- integrate into lualine
          cmdline     = { icon = symbols.left_five_eights_block .. "   " },
          search_down = { icon = symbols.left_five_eights_block .. "     " },
          search_up   = { icon = symbols.left_five_eights_block .. "     " },
          filter      = { icon = symbols.left_five_eights_block .. "   󰈲 " },
          lua         = { icon = symbols.left_five_eights_block .. "    " },
          help        = { icon = symbols.left_five_eights_block .. "    " },
          input       = { icon = "󰥻 " },
        }
      },
      messages = {
        view_search = false, -- view for search count messages. Set to `false` to disable
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
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
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
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
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          },
        },
      },
    },
    keys = { ---@format disable
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",    desc = "Redirect Cmdline" },
      { "<c-f>",     function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true, expr = true, mode = { "i", "n", "s" }, desc = "Scroll forward" },
      { "<c-b>",     function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, mode = { "i", "n", "s" }, desc = "Scroll backward" },
      { ",n",        function() require("noice").cmd("dismiss") end,                                silent = true, mode = "n",  desc = "Clear Noice" },
    }, ---@format enable
  },
}
