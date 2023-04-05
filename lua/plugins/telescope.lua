return {
  {
    'nvim-telescope/telescope.nvim',
    lazy = true,
    cmd = 'Telescope',
    keys = {
      { 'gi', function() require('telescope.builtin').lsp_implementations() end, desc = 'Go to Implementation' },
      { '<Space>f', function() require('telescope.builtin').find_files() end, desc = 'Find Files' },
      { '<Space>,', function() require('telescope.builtin').resume() end, desc = 'Resume previous telescope' },
      { '<Space>F', function() require('telescope.builtin').git_files() end, desc = 'Find Files (Git)' },
      { '<Space>g', function() require('telescope.builtin').live_grep() end, desc = 'Grep' },
      { '<Space>b', function() require('telescope.builtin').buffers() end, desc = 'Buffers' },
      { '<Space>m', function() require('telescope.builtin').marks() end, desc = 'Marks' },
      { '<Space>h;', function() require('telescope.builtin').command_history() end, desc = 'Command History' },
      { '<Space>h:', function() require('telescope.builtin').command_history() end, desc = 'Command History' },
      { '<Space>h/', function() require('telescope.builtin').search_history() end, desc = 'Search History' },
      { '<Space>H', function() require('telescope.builtin').help_tags() end, desc = 'Help tags' },
      { '<Space>r', function() require('telescope.builtin').registers() end, desc = 'Registers' },
      { '<Space>ts', function() require('telescope.builtin').treesitter() end, desc = 'Treesitter Symbols' },
      { '<Space>th', '<cmd>TSHighlightCapturesUnderCursor<cr>', desc = 'Treesitter Highlight Captures' },
      { '<Space>l', function() require('telescope.builtin').loclist() end, desc = 'Diagnostic Loclist' },
      { 'gr', function() require('telescope.builtin').lsp_references() end, desc = 'Go to References' },
      { 'gdd', function() require('telescope.builtin').lsp_definitions() end, desc = 'Go to Definition' },
      { 'gdt', function() vim.g.FnNewTab(require('telescope.builtin').lsp_definitions, { zz = true }) end, desc = 'Go to Definition (new tab)' },
      { 'gdT', function() require('telescope.builtin').lsp_type_definitions() end, desc = 'Go to Type Definition' },
      { '<Space>qf', function() require('telescope.builtin').quickfix() end, desc = 'Quickfix list' },
      { '<Space>D', function() vim.diagnostic.setqflist() end, desc = 'Diagnostics to qflist' },
      { '<Space>/', function() require('telescope.builtin').current_buffer_fuzzy_find() end, desc = 'Grep current buffer' },
      { '<Space>#', function() require('telescope.builtin').grep_string() end, desc = 'Grep current word' },
      { '<Space>vo', function() require('telescope.builtin').vim_options() end, desc = 'Vim options' },
      { '<Space>km', function() require('telescope.builtin').keymaps() end, desc = 'Keymaps' },
      { '<Space>J', function() require('telescope.builtin').jumplist() end, desc = 'Jumplist' },
      { '<space>ss', function() require('telescope.builtin').spell_suggest() end, desc = 'Spell suggest' },
      { '<Space>d', function() require('telescope.builtin').diagnostics() end, desc = 'Treesitter diagnostics' },
      { 'sM', function() require('telescope.builtin').man_pages({ sections = { '1', '3' } }) end, desc = 'Man pages (1,3)' },
      { 'gdh', function () vim.g.SplitInDirection('h', require('telescope.builtin').lsp_definitions, { zz = true }) end, desc = 'Go to Definition (split left)' },
      { 'gdj', function () vim.g.SplitInDirection('j', require('telescope.builtin').lsp_definitions, { zz = true }) end, desc = 'Go to Definition (split down)' },
      { 'gdk', function () vim.g.SplitInDirection('k', require('telescope.builtin').lsp_definitions, { zz = true }) end, desc = 'Go to Definition (split up)' },
      { 'gdl', function () vim.g.SplitInDirection('l', require('telescope.builtin').lsp_definitions, { zz = true }) end, desc = 'Go to Definition (split right)' },
      { '<BS>;', function() require('telescope').extensions.dap.commands(require('telescope.themes').get_ivy({ })) end, desc = 'Telescope DAP Commands' },
      { '<BS>C', function() require('telescope').extensions.dap.configurations(require('telescope.themes').get_ivy({ })) end, desc = 'Telescope DAP Configurations' },
      { '<BS>B', function() require('telescope').extensions.dap.list_breakpoints(require('telescope.themes').get_ivy({ })) end, desc = 'Telescope DAP Breakpoints' },
      { '<BS>v', function() require('telescope').extensions.dap.variables(require('telescope.themes').get_ivy({ })) end, desc = 'Telescope DAP Variables' },
      { '<BS>f', function() require('telescope').extensions.dap.frames(require('telescope.themes').get_ivy({ })) end, desc = "Telescope DAP Frames" },
    },
    dependencies = {
      { 'nvim-lua/plenary.nvim', lazy = true },
      {
        'ThePrimeagen/harpoon',
        lazy = true,
        keys = {
          { '<Space>hm', "<cmd>Telescope harpoon marks theme=ivy<cr>", 'Harpoon Telescope' },
          { '<Space>ha', function() require("harpoon.mark").add_file() end, 'Harpoon Add File' },
          { '<Space>hM', function() require("harpoon.ui").toggle_quick_menu() end, 'Harpoon Menu' },
        }
      },
    },
    config = function()
      local telescope = require('telescope')
      telescope.load_extension('harpoon')
      telescope.setup({
        pickers = {
          find_files = { theme = 'ivy' },
          git_files = { theme = 'ivy' },
          grep_string = { theme = 'ivy' },
          live_grep = { theme = 'ivy' },
          buffers = { theme = 'ivy' },
          oldfiles = { theme = 'ivy' },
          commands = { theme = 'ivy' },
          tags = { theme = 'ivy' },
          command_history = { theme = 'ivy' },
          search_history = { theme = 'ivy' },
          help_tags = { theme = 'ivy' },
          man_pages = { theme = 'ivy' },
          marks = { theme = 'ivy' },
          colorscheme = { theme = 'ivy' },
          quickfix = { theme = 'ivy' },
          quickfixhistory = { theme = 'ivy' },
          loclist = { theme = 'ivy' },
          jumplist = { theme = 'ivy' },
          vim_options = { theme = 'ivy' },
          registers = { theme = 'ivy' },
          autocommands = { theme = 'ivy' },
          spell_suggest = { theme = 'ivy' },
          keymaps = { theme = 'ivy' },
          filetypes = { theme = 'ivy' },
          highlights = { theme = 'ivy' },
          current_buffer_fuzzy_find = { theme = 'ivy' },
          current_buffer_tags = { theme = 'ivy' },
          resume = { theme = 'ivy' },
          pickers = { theme = 'ivy' },
          lsp_references = { theme = 'ivy' },
          lsp_incoming_calls = { theme = 'ivy' },
          lsp_outgoing_calls = { theme = 'ivy' },
          lsp_document_symbols = { theme = 'ivy' },
          lsp_workspace_symbols = { theme = 'ivy' },
          lsp_dynamic_workspace_symbols = { theme = 'ivy' },
          diagnostics = { theme = 'ivy' },
          lsp_implementations = { theme = 'ivy' },
          lsp_definitions = { theme = 'ivy' },
          lsp_type_definitions = { theme = 'ivy' },
          git_commits = { theme = 'ivy' },
          git_bcommits = { theme = 'ivy' },
          git_branches = { theme = 'ivy' },
          git_status = { theme = 'ivy' },
          git_stash = { theme = 'ivy' },
          treesitter = { theme = 'ivy' },
          planets = { theme = 'ivy' },
          builtin = { theme = 'ivy' },
          reloader = { theme = 'ivy' },
          symbols = { theme = 'ivy' },
        },
      })
    end,
  },
}
