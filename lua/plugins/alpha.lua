return {
  {
    'goolord/alpha-nvim',
    config = function()
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')
      local fortune = require('alpha.fortune')
      local cfgdir = vim.fn.stdpath('config')
      dashboard.section.buttons.val = {
        dashboard.button('e', '  New file', [[:ene<CR>]]),
        dashboard.button('f', '  Find file', [[<cmd>lua require('telescope.builtin').find_files()<CR>]]),
        dashboard.button('g', '  Find word', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]]),
        dashboard.button('s', '  Load Session', ':SessionManager load_session<CR>'),
        dashboard.button('l', '  Load Last Session', ':SessionManager load_last_session<CR>'),
        dashboard.button('c', '  Config', [[<cmd>cd ]] .. cfgdir .. [[ | lua require('telescope.builtin').find_files({ cwd = ']] .. cfgdir .. [[' })<CR>]]),
        dashboard.button('u', '  Update Packages', ':Lazy sync<CR>'),
        dashboard.button('q', '  Quit NVIM', ':qa<CR>'),
      }
      vim.api.nvim_set_hl(0, 'StartLogo1', { fg = '#51D8FF' })
      vim.api.nvim_set_hl(0, 'StartLogo2', { fg = '#51D8FF' })
      vim.api.nvim_set_hl(0, 'StartLogo3', { fg = '#46C7FF' })
      vim.api.nvim_set_hl(0, 'StartLogo4', { fg = '#3DB5FF' })
      vim.api.nvim_set_hl(0, 'StartLogo5', { fg = '#239BFE' })
      vim.api.nvim_set_hl(0, 'StartLogo6', { fg = '#1672F9' })
      vim.api.nvim_set_hl(0, 'StartLogo7', { fg = '#044EE3' })
      vim.api.nvim_set_hl(0, 'StartLogo8', { fg = '#044EE3' })
      local header = {
        '                                                     ',
        '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
        '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
        '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
        '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
        '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
        '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
        '                                                     ',
      }
      local function colorize_header()
        local lines = {}
        for i, chars in pairs(header) do
          local line = {
            type = 'text',
            val = chars,
            opts = { hl = 'StartLogo' .. i, shrink_margin = false, position = 'center' },
          }
          table.insert(lines, line)
        end
        return lines
      end
      dashboard.section.footer.val = fortune()
      local group = vim.api.nvim_create_augroup('CleanDashboard', {})
      vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = 'AlphaReady',
        callback = function()
          vim.opt.showtabline = 0
          vim.opt.showmode = false
          vim.opt.laststatus = 0
          vim.opt.showcmd = false
          vim.opt.ruler = false
        end,
      })
      vim.api.nvim_create_autocmd('BufUnload', {
        group = group,
        pattern = '<buffer>',
        callback = function()
          vim.opt.showtabline = 2
          vim.opt.showmode = true
          vim.opt.showcmd = true
          vim.opt.ruler = true
          vim.cmd([[Lazy load lualine.nvim]])
          vim.cmd([[Lazy load bufferline.nvim]])
          vim.opt.laststatus = 3
        end,
      })
      alpha.setup({
        layout = {
          { type = 'padding', val = 4 },
          { type = 'group', val = colorize_header() },
          { type = 'padding', val = 2 },
          dashboard.section.buttons,
          dashboard.section.footer,
        },
        opts = { margin = 5 },
      })
    end,
  },
}
