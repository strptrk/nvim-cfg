return {
  {
    'mhartington/formatter.nvim',
    lazy = true,
    cmd = { 'Format' },
    config = function()
      require('formatter').setup({
        logging = false,
        filetype = {
          json = {
            function()
              return {
                exe = 'prettier',
                args = {
                  '--stdin-filepath',
                  vim.api.nvim_buf_get_name(0),
                  '--single-quote',
                },
                stdin = true,
              }
            end,
          },
          css = {
            function()
              return {
                exe = 'prettier',
                args = {
                  '--stdin-filepath',
                  vim.api.nvim_buf_get_name(0),
                  '--single-quote',
                },
                stdin = true,
              }
            end,
          },
          javascript = {
            -- prettier
            function()
              return {
                exe = 'prettier',
                args = {
                  '--stdin-filepath',
                  vim.api.nvim_buf_get_name(0),
                  '--single-quote',
                },
                stdin = true,
              }
            end,
          },
          lua = {
            -- lua-format
            function()
              return {
                exe = 'stylua',
                args = {
                  vim.api.nvim_buf_get_name(0),
                },
                stdin = false,
              }
            end,
          },
          rust = {
            function()
              return {
                exe = 'rustfmt',
                args = { vim.api.nvim_buf_get_name(0) },
                stdin = false,
                cwd = vim.fn.expand('%:p:h'),
              }
            end,
          },
          cpp = {
            -- clang-format
            function()
              return {
                exe = 'clang-format',
                args = { '--assume-filename', vim.api.nvim_buf_get_name(0) },
                stdin = true,
                cwd = vim.fn.expand('%:p:h'), -- Run clang-format in cwd of the file.
              }
            end,
          },
          c = {
            -- clang-format
            function()
              return {
                exe = 'clang-format',
                args = { '--assume-filename', vim.api.nvim_buf_get_name(0) },
                stdin = true,
                cwd = vim.fn.expand('%:p:h'), -- Run clang-format in cwd of the file.
              }
            end,
          },
          java = {
            -- clang-format
            function()
              return {
                exe = 'astyle',
                args = { '--mode=java', '--style=java' },
                stdin = true,
                -- cwd = vim.fn.expand('%:p:h') -- Run clang-format in cwd of the file.
              }
            end,
          },
          sh = {
            -- Shell Script Formatter
            function()
              return {
                exe = 'shfmt',
                args = { '-i', 4 },
                stdin = true, --
              }
            end,
          },
          python = {
            function()
              return {
                exe = 'autopep8',
                args = { vim.api.nvim_buf_get_name(0) },
                stdin = true, --
              }
            end,
          },
        },
      })
    end,
  },
}
