return {
  {
    'ms-jpq/coq_nvim',
    branch = 'coq',
    cmd = {
      "COQdeps",
      "COQnow",
    },
    event = 'InsertEnter',
    init = function()
      vim.g.coq_settings = {
        auto_start = false,
        keymap = { recommended = false, jump_to_mark = '<A-Tab>' },
        ['display.ghost_text.context'] = { ' < ', ' >' },
        ['display.pum.source_context'] = { '[', ']' }
      }
    end,
    config = function()
      vim.api.nvim_exec([[COQnow --shut-up]], false)
    end,
    dependencies = {
      {
        'ms-jpq/coq.thirdparty',
        branch = '3p',
        lazy = true,
        config = function()
          require('coq_3p')({
            { src = 'nvimlua', short_name = 'nLUA' },
            { src = 'vimtex',  short_name = 'vTEX' },
            -- { src = 'dap' },
          })
        end,
      },
      {
        'ms-jpq/coq.artifacts',
        branch = 'artifacts',
        lazy = true
      },
    }
  },
}
