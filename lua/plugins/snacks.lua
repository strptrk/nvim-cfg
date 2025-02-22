return {
  {
    "folke/snacks.nvim",
    priority = 1001,
    lazy = false,
    keys = {
      { "<A-C-c>", function() Snacks.bufdelete() end,        desc = "Delete buffer" },
      { ",B",      function() Snacks.gitbrowse() end,        mode = { "n", "v" },                desc = "Git Browse" },
      { ",h",      function() Snacks.image.hover() end,      desc = "Show Image" },
      { ",l",      function() Snacks.lazygit() end,          desc = "Lazygit" },
      { ",L",      function() Snacks.lazygit.log_file() end, desc = "Lazygit (log current file)" },
    },
    opts = {
      styles = {
        input = {
          position = "float",
          relative = "cursor"
        }
      },
      bufdelete = { enabled = true },
      git = { enabled = true },
      gitbrowse = { enabled = true },
      image = { enabled = true },
      input = {
        prompt_pos = "title",
        enabled = true,
      },
      lazygit = { enabled = true },
      picker = { enabled = true },
      rename = { enabled = true },
      notifier = {
        enabled = true,
        top_down = false,
      },
      toggle = {
        enabled = true,
        which_key = true,
        notify = true,
      }
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader><leader>w")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader><leader>r")
          Snacks.toggle.diagnostics():map("<leader><leader>d")
          Snacks.toggle.line_number():map("<leader><leader>n")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader><leader>c")
          Snacks.toggle.treesitter():map("<leader><leader>t")
          Snacks.toggle.inlay_hints():map("<leader><leader>h")
          Snacks.toggle.dim():map("<leader><leader>D")
        end,
      })
    end
  }
}
