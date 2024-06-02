local resize_edgy = function(edgy_win, direction, size)
  local dimension = (direction == "h" or direction == "l") and "width" or "height"
  local on_edge = (vim.fn.winnr(direction) == vim.fn.winnr()) and -1 or 1
  edgy_win:resize(dimension, on_edge * size)
end

local colors = {
  blue = "#61afef",
  green = "#98c379",
  purple = "#c678dd",
  cyan = "#56b6c2",
  red1 = "#ea7272",
  red2 = "#be5046",
  yellow = "#e5c07b",
  fg = "#abb2bf",
  bg = "#232323",
  gray1 = "#302f2f",
  gray2 = "#302f2f",
  gray3 = "#444444",
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
        keys = {
          ["<A-C-h>"] = function(win)
            resize_edgy(win, "h", 2)
          end,
          ["<A-C-j>"] = function(win)
            resize_edgy(win, "j", 2)
          end,
          ["<A-C-k>"] = function(win)
            resize_edgy(win, "k", 2)
          end,
          ["<A-C-l>"] = function(win)
            resize_edgy(win, "l", 2)
          end,
        },
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
    event = "VeryLazy",
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
    "norcalli/nvim-colorizer.lua",
    lazy = true,
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer" },
    config = function()
      require("colorizer").setup({
        "css",
        "html",
        "lua",
        "md",
        "neorg",
      })
    end,
  },
  {
    "Pocco81/true-zen.nvim",
    lazy = true,
    config = function()
      require("true-zen").setup({})
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "lsp_document_symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })
      local opts = {
        options = {
          icons_enabled = true,
          theme = "catppuccin",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {},
          always_divide_middle = false,
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            "diff",
            { "diagnostics", sources = { "nvim_diagnostic" } },
          },
          lualine_c = {
            "filename",
            {
              symbols.get,
              cond = symbols.has,
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
            "filetype",
          },
          lualine_y = { "fileformat", "encoding", "filesize" },
          lualine_z = { "progress", "location" },
        },
        inactive_sections = {},
        tabline = {},
        extensions = { "toggleterm", "quickfix" },
      }
      require("lualine").setup(opts)
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    event = "VeryLazy",
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
          position = {
            row = -2,
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
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
    keys = {
      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = { "i", "n", "s" },
      },
      {
        ",n",
        function()
          require("noice").cmd("dismiss")
        end,
        silent = true,
        desc = "Clear Noice",
        mode = "n",
      },
    },
  },
}
