return {
  {
    "folke/which-key.nvim",
    lazy = true,
    event = "VeryLazy",
    opts = {
      ---@type false | "classic" | "modern" | "helix"
      preset = "modern",
      ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
      delay = function(ctx)
        local delays = {
          ['"'] = 0,
          ["'"] = 0,
          ["`"] = 0,
          default = 350,
        }
        return delays[ctx.keys] or delays.default
      end,
      triggers = {
        { "<auto>",   mode = "nixsotc" },
        { "<leader>", mode = { "n", "v" } },
        { "<BS>",     mode = { "n", "v" } },
        { "]",        mode = { "n", "v" } },
        { "[",        mode = { "n", "v" } },
        { ",",        mode = { "n", "v" } },
        { "s",        mode = { "n", "v" } },
      },
      -- what could go into `wk.add(...)`
      spec = {
        { "<Space>d", group = "LSP Diagnostics" },
        { "<Space>h", group = "Help & History" },
        { "<Space>q", group = "Quickfix" },
        { "<Space>s", group = "LSP Symbols" },
        { "<Space>v", group = "Vim Options" },
        { "<BS>s",    group = "Debug: Modify Properties" },
        { ",",        group = "Comma Prefix" },
        { "sc",       group = "LSP Call Hierarchy" },
        { "su",       group = "Surround" },
      },
      notify = {},
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true, -- z= to select spelling suggestions
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      keys = {
        scroll_down = "<c-j>",
        scroll_up = "<c-k>",
      },
      win = {
        border = vim.g.float_border_style,
      },
      disable = {
        buftypes = {},
        filetypes = { "TelescopePrompt" },
      },
    },
  },
}
