return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    cmd = "Telescope",
    keys = { ---@format disable
      { "gI",        function() require("telescope.builtin").lsp_implementations() end,                 desc = "Go to Implementation" },
      { "<Space>f",  function() require("telescope.builtin").find_files() end,                          desc = "Find Files" },
      { "<Space>,",  function() require("telescope.builtin").resume() end,                              desc = "Resume previous telescope" },
      { "<Space>F",  function() require("telescope.builtin").git_files() end,                           desc = "Find Files (Git)" },
      { "<Space>g",  function() require("telescope.builtin").live_grep() end,                           desc = "Grep" },
      { "<Space>m",  function() require("telescope.builtin").marks() end,                               desc = "Marks" },
      { "<Space>h;", function() require("telescope.builtin").command_history() end,                     desc = "Command History" },
      { "<Space>h:", function() require("telescope.builtin").command_history() end,                     desc = "Command History" },
      { "<Space>h/", function() require("telescope.builtin").search_history() end,                      desc = "Search History" },
      { "<Space>H",  function() require("telescope.builtin").help_tags() end,                           desc = "Help tags" },
      { "<Space>r",  function() require("telescope.builtin").registers() end,                           desc = "Registers" },
      { "<Space>st", function() require("telescope.builtin").treesitter() end,                          desc = "Treesitter Symbols" },
      { "<Space>l",  function() require("telescope.builtin").loclist() end,                             desc = "Diagnostic Loclist" },
      { "gr",        function() require("telescope.builtin").lsp_references() end,                      desc = "Go to References" },
      { "gdd",       function() require("telescope.builtin").lsp_definitions() end,                     desc = "Go to Definition" },
      { "gdT",       function() require("telescope.builtin").lsp_type_definitions() end,                desc = "Go to Type Definition" },
      { "<Space>qf", function() require("telescope.builtin").quickfix() end,                            desc = "Quickfix list" },
      { "<Space>/",  function() require("telescope.builtin").current_buffer_fuzzy_find() end,           desc = "Grep current buffer" },
      { "<Space>#",  function() require("telescope.builtin").grep_string() end,                         desc = "Grep current word" },
      { "<Space>n",  function() require("telescope.builtin").grep_string() end,                         desc = "Grep current word" },
      { "<Space>vo", function() require("telescope.builtin").vim_options() end,                         desc = "Vim options" },
      { "<Space>K",  function() require("telescope.builtin").keymaps() end,                             desc = "Keymaps" },
      { "<Space>J",  function() require("telescope.builtin").jumplist() end,                            desc = "Jumplist" },
      { "<space>ss", function() require("telescope.builtin").spell_suggest() end,                       desc = "Spell suggest" },
      { "<Space>b",  function() require("telescope.builtin").buffers({ sort_mru = true }) end,          desc = "Buffers" },
      { "<Space>da", function() require("telescope.builtin").diagnostics() end,                         desc = "LSP diagnostics (all)" },
      { "<Space>df", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end,            desc = "LSP diagnostics (file)" },
      { "<Space>de", function() require("telescope.builtin").diagnostics({ severity = "error" }) end,   desc = "LSP errors" },
      { "<Space>dw", function() require("telescope.builtin").diagnostics({ severity = "warning" }) end, desc = "LSP warnings" },
      { "<Space>sd", function() require("telescope.builtin").lsp_document_symbols({ symbol_width = 50 }) end,   desc = "LSP Symbols (document)" },
      { "<Space>sw", function() require("telescope.builtin").lsp_workspace_symbols({ symbol_width = 50 }) end,  desc = "LSP Symbols (workspace)" },
      { "<Space>sf", function() require("telescope.builtin").lsp_document_symbols({ symbols = { "function", "method" }, symbol_width = 50 }) end, desc = "LSP Functions (document)" },
      { "<Space>sF", function() require("telescope.builtin").lsp_workspace_symbols({ symbols = { "function", "method" }, symbol_width = 50 }) end, desc = "LSP Functions (workspace)" },
      { "gdh",       function() require("cfg.utils").split("h", require("telescope.builtin").lsp_definitions, { zz = true }) end, desc = "Go to Definition (split left)" },
      { "gdj",       function() require("cfg.utils").split("j", require("telescope.builtin").lsp_definitions, { zz = true }) end, desc = "Go to Definition (split down)" },
      { "gdk",       function() require("cfg.utils").split("k", require("telescope.builtin").lsp_definitions, { zz = true }) end, desc = "Go to Definition (split up)" },
      { "gdl",       function() require("cfg.utils").split("l", require("telescope.builtin").lsp_definitions, { zz = true }) end, desc = "Go to Definition (split right)" },
      { "gR",        function() require("cfg.utils").fntab(require("telescope.builtin").lsp_references) end,    desc = "Go to References (new tab)" },
      { "gdt",       function() require("cfg.utils").fntab(require("telescope.builtin").lsp_definitions, { zz = true }) end, desc = "Go to Definition (new tab)" },
    }, ---@format enable
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    config = function()
      local open_with_trouble = require("trouble.sources.telescope").open
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<M-t>"] = open_with_trouble,
            },
            n = {
              ["<M-t>"] = open_with_trouble,
            },
          },
        },
        pickers = {
          find_files = { theme = "ivy" },
          git_files = { theme = "ivy" },
          grep_string = { theme = "ivy" },
          live_grep = { theme = "ivy" },
          buffers = { theme = "ivy" },
          oldfiles = { theme = "ivy" },
          commands = { theme = "ivy" },
          tags = { theme = "ivy" },
          command_history = { theme = "ivy" },
          search_history = { theme = "ivy" },
          help_tags = { theme = "ivy" },
          man_pages = { theme = "ivy" },
          marks = { theme = "ivy" },
          colorscheme = { theme = "ivy" },
          quickfix = { theme = "ivy" },
          quickfixhistory = { theme = "ivy" },
          loclist = { theme = "ivy" },
          jumplist = { theme = "ivy" },
          vim_options = { theme = "ivy" },
          registers = { theme = "ivy" },
          autocommands = { theme = "ivy" },
          spell_suggest = { theme = "ivy" },
          keymaps = { theme = "ivy" },
          filetypes = { theme = "ivy" },
          highlights = { theme = "ivy" },
          current_buffer_fuzzy_find = { theme = "ivy" },
          current_buffer_tags = { theme = "ivy" },
          resume = { theme = "ivy" },
          pickers = { theme = "ivy" },
          lsp_references = { theme = "ivy" },
          lsp_incoming_calls = { theme = "ivy" },
          lsp_outgoing_calls = { theme = "ivy" },
          lsp_document_symbols = { theme = "ivy" },
          lsp_workspace_symbols = { theme = "ivy" },
          lsp_dynamic_workspace_symbols = { theme = "ivy" },
          diagnostics = { theme = "ivy" },
          lsp_implementations = { theme = "ivy" },
          lsp_definitions = { theme = "ivy" },
          lsp_type_definitions = { theme = "ivy" },
          git_commits = { theme = "ivy" },
          git_bcommits = { theme = "ivy" },
          git_branches = { theme = "ivy" },
          git_status = { theme = "ivy" },
          git_stash = { theme = "ivy" },
          treesitter = { theme = "ivy" },
          planets = { theme = "ivy" },
          builtin = { theme = "ivy" },
          reloader = { theme = "ivy" },
          symbols = { theme = "ivy" },
        },
      })
    end,
  },
}
