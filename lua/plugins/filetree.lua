return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = true,
    keys = {
      {
        "<leader>a",
        function()
          vim.cmd([[Neotree show filesystem position=left]])
          vim.cmd([[Neotree show buffers position=top]])
          vim.cmd([[Neotree show git_status position=right]])
        end,
        desc = "Neotree Files, Git, Buffers",
      },
      {
        "<leader>g",
        function()
          vim.cmd([[Neotree focus git_status position=right]])
        end,
        desc = "Neotree Focus Git",
      },
      {
        "<leader>b",
        function()
          vim.cmd([[Neotree focus buffers position=top]])
        end,
        desc = "Neotree Focus Buffers",
      },
      {
        "<leader>f",
        function()
          vim.cmd([[Neotree focus filesystem position=left]])
        end,
        desc = "Neotree Focus Files",
      },
    },
    dependencies = {
      {
        "MunifTanjim/nui.nvim",
        lazy = true,
      },
      {
        "s1n7ax/nvim-window-picker",
        main = "window-picker",
        lazy = true,
        opts = {
          autoselect_one = true,
          include_current = false,
          filter_rules = {
            -- filter using buffer options
            bo = {
              filetype = { "neo-tree", "neo-tree-popup", "notify" },
              buftype = { "terminal", "quickfix" },
            },
          },
          other_win_hl_color = "#e35e4f",
        },
      },
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
    config = function()
      vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
      vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
      require("neo-tree").setup({
        source_selector = {
          winbar = false,
          statusline = false,
          show_scrolled_off_parent_node = false,
          sources = {
            {
              source = "filesystem",
              display_name = " 󱏒 Files ",
            },
            {
              source = "buffers",
              display_name = "  Buffers",
            },
            {
              source = "git_status",
              display_name = "  Git ",
            },
          },
          content_layout = "start",
          tabs_layout = "equal",
          truncation_character = "…",
          tabs_min_width = nil,
          tabs_max_width = nil,
          padding = 0,
          separator = { left = "▏", right = "▕" },
          separator_active = nil,
          show_separator_on_edge = false,
          highlight_tab = "NeoTreeTabInactive",
          highlight_tab_active = "NeoTreeTabActive",
          highlight_background = "NeoTreeTabInactive",
          highlight_separator = "NeoTreeTabSeparatorInactive",
          highlight_separator_active = "NeoTreeTabSeparatorActive",
        },
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = false,
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
        sort_case_insensitive = false,
        sort_function = nil,
        default_component_configs = {
          container = {
            enable_character_fade = true,
          },
          indent = {
            indent_size = 2,
            padding = 1, -- extra padding on left hand side
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            with_expanders = nil,
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
            -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
            -- then these will never be used.
            default = "*",
            highlight = "NeoTreeFileIcon",
          },
          modified = {
            symbol = "",
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              -- Change type
              added = "✚",
              -- modified = "",
              modified = "",
              deleted = "✖",
              renamed = "",
              -- Status type
              untracked = "",
              ignored = "",
              unstaged = "󰛲",
              staged = "󰱒",
              conflict = "",
            },
          },
        },
        window = {
          position = "left",
          width = 34,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ["<cr>"] = "open",
            ["gp"] = { "toggle_preview", config = { use_float = true } },
            ["<esc>"] = "revert_preview",
            ["l"] = "focus_preview",
            ["s"] = "open_split",
            ["v"] = "open_vsplit",
            ["S"] = "split_with_window_picker",
            ["V"] = "vsplit_with_window_picker",
            ["t"] = "open_tabnew",
            ["o"] = false,
            ["O"] = "open_tab_drop",
            ["w"] = "open_with_window_picker",
            ["z"] = false,
            ["zc"] = "close_all_nodes",
            ["ze"] = "expand_all_nodes",
            ["a"] = { "add", config = { show_path = "relative" } },
            ["A"] = { "add_directory", config = { show_path = "relative" } },
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = { "copy", config = { show_path = "relative" } },
            ["m"] = { "move", config = { show_path = "relative" } },
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
            ["<Tab>"] = "next_source",
            ["<S-Tab>"] = "prev_source",
          },
        },
        nesting_rules = {},
        filesystem = {
          filtered_items = {
            visible = true, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_hidden = true, -- only works on Windows for hidden files/directories
            hide_by_name = {
              --"node_modules"
            },
            -- uses glob style patterns
            hide_by_pattern = {
              --"*.meta",
              --"*/src/*/tsconfig.json",
            },
            -- remains visible even if other settings would normally hide it
            always_show = {},
            -- remains hidden even if visible is toggled to true, this overrides always_show
            never_show = {
              ".DS_Store",
              "thumbs.db",
            },
            never_show_by_pattern = {}, -- uses glob style patterns
          },
          follow_current_file = { enabled = false },
          group_empty_dirs = false,
          hijack_netrw_behavior = "open_current",
          use_libuv_file_watcher = true,
          window = {
            mappings = {
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["H"] = "toggle_hidden",
              ["<C-/>"] = "fuzzy_finder",
              ["/"] = false,
              ["D"] = "fuzzy_finder_directory",
              ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
              -- ["D"] = "fuzzy_sorter_directory",
              ["f"] = "filter_on_submit",
              ["<c-x>"] = "clear_filter",
              ["[v"] = "prev_git_modified",
              ["]v"] = "next_git_modified",
            },
          },
        },
        buffers = {
          follow_current_file = { enabled = false },
          group_empty_dirs = true,
          show_unloaded = true,
          window = {
            mappings = {
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
            },
          },
        },
        git_status = {
          window = {
            position = "float",
            mappings = {
              ["S"] = "git_add_all",
              ["u"] = "git_unstage_file",
              ["s"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
            },
          },
        },
      })
    end,
  },
  {
    "stevearc/oil.nvim",
    lazy = true,
    cmd = {
      "Oil",
    },
    keys = {
      { ",o", "<cmd>Oil<cr>" },
    },
    opts = {
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-\\>"] = "actions.select_vsplit",
        ["<C-->"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["gr"] = "actions.refresh",
        ["<bs>"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["<C-h>"] = "actions.toggle_hidden",
        ["H"] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
