local api = vim.api

local utils_local = {
  rename_cmd = [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  highlight_cmd_word = [[<cmd>let @/='\<' . expand('<cword>') . '\>'<bar>set hls<cr>]],
  highlight_cmd_all = [[<cmd>let @/=expand('<cword>')<bar>set hls<cr>]],
  clear_highlight_cmd = [[<cmd>nohls<cr>]],
  default_rename_handler = nil,
}

local M = {}

M.split_ignore_ft = {
  ["sagaoutline"] = true,
  ["neo-tree"] = true,
  ["lazy"] = true,
  ["qf"] = true,
  ["noice"] = true,
  ["toggleterm"] = true,
  ["terminal"] = true,
  ["trouble"] = true,
  ["TelescopePrompt"] = true,
  ["dap-repl"] = true,
  ["dapui_watches"] = true,
  ["dapui_stacks"] = true,
  ["dapui_breakpoints"] = true,
  ["dapui_scopes"] = true,
  ["dapui_console"] = true,
}

M.fntab_ignored_ft = {
  ["neo-tree"] = true,
  ["DiffviewFiles"] = true,
  ["toggleterm"] = true,
  ["terminal"] = true,
  ["help"] = true,
  ["alpha"] = true,
  ["dashboard"] = true,
  ["trouble"] = true,
  ["lazy"] = true,
  ["nofile"] = true,
  [""] = true,
  ["TelescopePrompt"] = true,
  ["dap-repl"] = true,
  ["dapui_watches"] = true,
  ["dapui_stacks"] = true,
  ["dapui_breakpoints"] = true,
  ["dapui_scopes"] = true,
  ["dapui_console"] = true,
}

local filesize_cache = {}
-- `size` is in `KiB`
M.file_too_big = function(size)
  -- treesitter's enable calls with (lang, buf)
  -- others call with (buf)
  return function(arg1, arg2)
    local bufnr = arg2 or arg1
    if filesize_cache[bufnr] == nil then
      local bufsize = 0
      -- normal case, the buffer is loaded from a file
      local ok1, fname = pcall(vim.api.nvim_buf_get_name, bufnr)
      ---@diagnostic disable-next-line: undefined-field
      local ok2, stats = pcall((vim.uv or vim.loop).fs_stat, fname)
      if ok1 and ok2 and stats ~= nil then
        bufsize = stats.size
      else
        -- buffer is not a file, but is loaded
        local linenum = vim.fn.getbufinfo(bufnr)[1].linecount
        bufsize = vim.api.nvim_buf_get_offset(bufnr, linenum)
        if bufsize == -1 then
          -- last hope
          bufsize = vim.fn.wordcount().bytes
        end
      end
      filesize_cache[bufnr] = bufsize
    end
    return filesize_cache[bufnr] > size * 1024
  end
end

local Nav = {
  direction = {
    tmux = {
      ["h"] = "-L",
      ["j"] = "-D",
      ["k"] = "-U",
      ["l"] = "-R",
    },
    wezterm = {
      ["h"] = "Left",
      ["j"] = "Down",
      ["k"] = "Up",
      ["l"] = "Right",
    },
    kitty = {
      ["h"] = "left",
      ["j"] = "bottom",
      ["k"] = "top",
      ["l"] = "right",
    }
  },
  multiplexer = {
    tmux = function(self, dir)
      if vim.fn.trim(vim.fn.system([[tmux display-message -p '#{window_zoomed_flag}']])) == "0" then
        vim.fn.system("tmux select-pane " .. self.direction.tmux[dir])
      end
    end,
    wezterm = function(self, dir)
      local pane_info = vim.json.decode(vim.fn.system([[wezterm cli list --format json]]))
      local pane_id = tonumber(vim.env["WEZTERM_PANE"])
      for _, pane in ipairs(pane_info) do
        if pane.pane_id == pane_id then
          if not pane.is_zoomed then
            vim.fn.system("wezterm cli activate-pane-direction " .. self.direction.wezterm[dir])
          end
          return
        end
      end
    end,
    kitty = function(self, dir)
      vim.fn.system("kitty @ kitten focus.py " .. self.direction.kitty[dir])
    end
  },
  configure_multiplexer = function(self)
    if self.configured then
      return
    end
    if vim.env["TMUX"] then
      setmetatable(self, { __call = self.multiplexer.tmux })
    elseif vim.env["KITTY_PID"] then
      setmetatable(self, { __call = self.multiplexer.kitty })
    elseif vim.env["TERM_PROGRAM"] == "WezTerm" then
      setmetatable(self, { __call = self.multiplexer.wezterm })
    else
      setmetatable(self, { __call = function() end })
    end
    self.configured = true
  end,
}

Nav:configure_multiplexer()


---@param dir "h" | "j" | "k" | "l"
M.winmove = function(dir)
  local current_win = vim.fn.winnr()
  vim.cmd.wincmd(dir)
  if current_win == vim.fn.winnr() then
    Nav(dir)
  end
end

M.split_focus = function(dir)
  if string.match(dir, "[jk]") then
    vim.cmd.wincmd("s")
    if dir == "k" then
      vim.cmd.wincmd("k")
    end
  else
    vim.cmd.wincmd("v")
    if dir == "h" then
      vim.cmd.wincmd("h")
    end
  end
end

M.split = function(dir, fn, opts)
  opts = opts or {}
  local bufnr = api.nvim_win_get_buf(0)
  local pos = api.nvim_win_get_cursor(0)
  local same = vim.fn.winnr() == vim.fn.winnr(dir)
  local ignored_ft = false
  if not same then
    local buf_in_dir = vim.api.nvim_win_get_buf(vim.fn.win_getid(vim.fn.winnr(dir)))
    local ft = api.nvim_get_option_value("filetype", { buf = buf_in_dir })
    ignored_ft = M.split_ignore_ft[ft]
  end
  if opts.new or same or ignored_ft then
    M.split_focus(dir)
  else
    vim.cmd.wincmd(dir)
  end
  api.nvim_win_set_buf(0, bufnr)
  api.nvim_win_set_cursor(0, pos)
  if type(fn) == "function" then
    fn(opts.args)
  end
  if opts.zz then
    vim.cmd.normal("zz")
  end
end

M.resize = function(direction, size)
  if string.match("jk", direction) and (vim.fn.winnr("j") == vim.fn.winnr("k")) then
    return -- prevent horizontally resizing the viewport
  end
  local to_dir = vim.fn.winnr(direction)
  local vertical = (direction == "h" or direction == "l") and "vertical " or ""
  if to_dir == vim.fn.winnr() then
    vim.cmd(vertical .. [[resize -]] .. size)
  else
    if to_dir == vim.fn.winnr("2" .. direction) then
      vim.cmd(vertical .. to_dir .. [[resize -]] .. size)
    else
      vim.cmd(vertical .. [[resize +]] .. size)
    end
  end
end

M.fntab = function(fn, opts)
  opts = opts or {}
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
  if not filetype or M.fntab_ignored_ft[filetype] then
    vim.cmd("tabnew")
  else
    vim.cmd.normal("mz")
    vim.cmd.tabedit("%")
    vim.cmd.normal("z")
  end
  if type(fn) == "function" then
    fn(opts.args)
  end
  if opts.zz then
    vim.cmd.normal("zz")
  end
end

M.treesitter_is_active = function(buf)
  return vim.treesitter.highlighter.active[buf or api.nvim_get_current_buf()] ~= nil and true or false
end

M.smart_rename_ts = function()
  if M.treesitter_is_active() then
    require("nvim-treesitter-refactor.smart_rename").smart_rename(api.nvim_win_get_buf(0))
  else
    api.nvim_feedkeys(api.nvim_replace_termcodes(utils_local.rename_cmd, true, true, true), "", true)
  end
end

M.highlight_usages = function()
  if M.treesitter_is_active() then
    require("nvim-treesitter-refactor.highlight_definitions").highlight_usages(api.nvim_win_get_buf(0))
  else
    api.nvim_feedkeys(api.nvim_replace_termcodes(utils_local.highlight_cmd_word, true, true, true), "", true)
  end
end

M.clear_highlight_usages = function()
  if M.treesitter_is_active() then
    require("nvim-treesitter-refactor.highlight_definitions").clear_usage_highlights(api.nvim_win_get_buf(0))
  end
  api.nvim_feedkeys(api.nvim_replace_termcodes(utils_local.clear_highlight_cmd, true, true, true), "", true)
end

M.highlight_cmd_all = function()
  return utils_local.highlight_cmd_all
end

M.highlight_cmd_word = function()
  return utils_local.highlight_cmd_word
end

M.smart_rename_lsp = function(client, bufnr)
  if not utils_local.default_rename_handler then
    utils_local.smart_rename_set_handler(M.smart_rename_ts)
  end
  local supported, supported_result = pcall(client.supports_method, "textDocument/prepareRename")
  if supported and supported_result then
    local win = api.nvim_get_current_win()
    local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
    client.request("textDocument/prepareRename", params, function(err, result)
      if err or (result == nil) then
        M.smart_rename_ts()
      else
        vim.lsp.buf.rename()
      end
    end, bufnr)
  else
    -- not all language servers support prepareRename
    -- that support rename
    vim.lsp.buf.rename()
  end
end

utils_local.smart_rename_set_handler = function(fallback)
  utils_local.default_rename_handler = vim.lsp.handlers["textDocument/rename"]
  vim.lsp.handlers["textDocument/rename"] = function(err, result, ctx, config)
    if err or not result then
      if type(fallback) == "function" then
        fallback()
      end
    else
      utils_local.default_rename_handler(err, result, ctx, config)
    end
  end
end

return M
