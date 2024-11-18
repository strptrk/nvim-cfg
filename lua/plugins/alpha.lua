return {
  {
    "goolord/alpha-nvim",
    lazy = false,
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      local fortune = require("alpha.fortune")
      local cfgdir = vim.fn.stdpath("config")
      dashboard.section.buttons.val = { ---@format disable
        dashboard.button("e", "  New file", [[<cmd>ene<CR>]]),
        dashboard.button("t", "󱏒  File tree", [[<cmd>ene<bar>Neotree focus filesystem position=left<CR>]]),
        dashboard.button("f", "󰈞  Find file", [[<cmd>lua require('telescope.builtin').find_files()<CR>]]),
        dashboard.button("g", "  Find word", [[<cmd>lua require('telescope.builtin').live_grep()<CR>]]),
        dashboard.button("s", "󰥨  Load Session", "<cmd>SessionManager load_session<CR>"),
        dashboard.button("l", "󰝉  Load Last Session", "<cmd>SessionManager load_last_session<CR>"),
        dashboard.button("c", "  Config", [[<cmd>cd ]] .. cfgdir .. [[<bar>lua require('telescope.builtin').find_files({ cwd = ']] .. cfgdir .. [[' })<CR>]]),
        dashboard.button("u", "󰅢  Update Packages", "<cmd>Lazy sync<CR>"),
        dashboard.button("q", "󰿅  Quit NVIM", "<cmd>qa<CR>"),
      } ---@format enable

      local header = {
        [[  ███       ███  ]],
        [[  ████      ████ ]],
        [[  ████     █████ ]],
        [[ █ ████    █████ ]],
        [[ ██ ████   █████ ]],
        [[ ███ ████  █████ ]],
        [[ ████ ████ ████ ]],
        [[ █████  ████████ ]],
        [[ █████   ███████ █████ ██████ █    █ █ █    █ ]],
        [[ █████    ██████ ██      ██    ██ ██    ██ ██ ███  ███ ]],
        [[ █████     █████ █████   ██    ██ ██    ██ ██ ██████ ]],
        [[ ████      ████ ██      ██    ██ █  █ ██ ██ ██ ██ ]],
        [[  ███       ███  █████ ██████  ████  █ █      █ ]],
      }
      local header_colors = {
        [[  kkkka       gggg  ]],
        [[  kkkkaa      ggggg ]],
        [[ b kkkaaa     ggggg ]],
        [[ bb kkaaaa    ggggg ]],
        [[ bbb kaaaaa   ggggg ]],
        [[ bbbb aaaaaa  ggggg ]],
        [[ bbbbb aaaaaa igggg ]],
        [[ bbbbb  aaaaaahiggg ]],
        [[ bbbbb   aaaaajhigg bbbbbbb bbbbbbbb bb    bb bb bbb    bbb ]],
        [[ bbbbb    aaaaajhig bb      bb    bb bb    bb bb bbbb  bbbb ]],
        [[ bbbbb     aaaaajhi bbbbb   bb    bb bb    bb bb bbbbbbbbbb ]],
        [[ bbbbb      aaaaajh bb      bb    bb bbb  bbb bb bb bbbb bb ]],
        [[  bbbb       aaaaa  bbbbbbb bbbbbbbb  bbbbbb  bb bb      bb ]],
        -- [[ bbbbb   aaaaajhigg █████ ██████ █    █ █ █    █ ]],
        -- [[ bbbbb    aaaaajhig ██      ██    ██ ██    ██ ██ ███  ███ ]],
        -- [[ bbbbb     aaaaajhi █████   ██    ██ ██    ██ ██ ██████ ]],
        -- [[ bbbbb      aaaaajh ██      ██    ██ █  █ ██ ██ ██ ██ ]],
        -- [[  bbbb       aaaaa  █████ ██████  ████  █ █      █ ]],
      }
      local header_color_defs = {
        ["b"] = { fg = "#3399ff", ctermfg = 33 },
        ["a"] = { fg = "#53C670", ctermfg = 35 },
        ["g"] = { fg = "#39ac56", ctermfg = 29 },
        ["h"] = { fg = "#33994d", ctermfg = 23 },
        ["i"] = { fg = "#33994d", bg = "#39ac56", ctermfg = 23, ctermbg = 29 },
        ["j"] = { fg = "#53C670", bg = "#33994d", ctermfg = 35, ctermbg = 23 },
        ["k"] = { fg = "#30A572", ctermfg = 36 },
      }

      local function char_len(s, pos)
        local byte = string.byte(s, pos)
        if not byte then
          return nil
        end
        return (byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or (byte < 0xF8 and 4) or 1
      end

      dashboard.section.header.val = header
      local hls = {}
      for key, hl in pairs(header_color_defs) do
        local name = "Alpha_" .. key
        vim.api.nvim_set_hl(0, name, hl)
        hls[key] = name
      end

      dashboard.section.header.opts.hl = {}
      for i, line in ipairs(header_colors) do
        local highlights = {}
        local pos = 0

        for j = 1, #line do
          local opos = pos
          pos = pos + char_len(header[i], opos + 1)

          local color_name = hls[line:sub(j, j)]
          if color_name then
            table.insert(highlights, { color_name, opos, pos })
          end
        end

        table.insert(dashboard.section.header.opts.hl, highlights)
      end

      dashboard.section.footer.val = fortune()
      local group = vim.api.nvim_create_augroup("CleanDashboard", {})
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "AlphaReady",
        callback = function()
          vim.opt.showtabline = 0
          vim.opt.laststatus = 0
          vim.opt.ruler = false
        end,
      })
      vim.api.nvim_create_autocmd("BufUnload", {
        group = group,
        pattern = "<buffer>",
        callback = function()
          vim.opt.showtabline = 2
          vim.opt.ruler = true
          vim.opt.laststatus = 3
        end,
      })
      alpha.setup({
        layout = {
          { type = "padding", val = 4 },
          dashboard.section.header,
          { type = "padding", val = 2 },
          dashboard.section.buttons,
          dashboard.section.footer,
        },
        opts = { margin = 5 },
      })
    end,
  },
}
