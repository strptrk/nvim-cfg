local api = vim.api

Utils = {}

Utils.file_too_big = function(size)
  return function(_, buf)            -- language, buffer
    local max_filesize = size * 1024 -- in KiB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
      return true
    end
    return false
  end
end

Utils.WinMove = function(key)
  local curwin = vim.fn.winnr()
  vim.cmd.wincmd(key)
  if curwin == vim.fn.winnr() then
    if os.getenv('TMUX') then
      local dir = {
        ['h'] = '-L',
        ['j'] = '-D',
        ['k'] = '-U',
        ['l'] = '-R',
      }
      if vim.fn.system([[tmux display-message -p '#{window_zoomed_flag}' | tr -d '\n']]) == '0' then
        vim.fn.system('tmux select-pane ' .. dir[key])
      end
    elseif os.getenv('TERM_PROGRAM') == 'WezTerm' then
      local dir = {
        ['h'] = 'Left',
        ['j'] = 'Down',
        ['k'] = 'Up',
        ['l'] = 'Right',
      }
      local function is_zoomed()
        local pane_info = vim.json.decode(vim.fn.system([[wezterm cli list --format json]]))
        local pane_id = tonumber(os.getenv("WEZTERM_PANE"))
        for _, pane in ipairs(pane_info) do
          if pane.pane_id == pane_id then
            return pane.is_zoomed
          end
        end
        return false
      end
      if not is_zoomed() then
        vim.fn.system('wezterm cli activate-pane-direction ' .. dir[key])
      end
    end
  end
end

Utils.SplitAndFocus = function(dir)
  if string.match(dir, '[jk]') then
    vim.cmd.wincmd('s')
  else
    vim.cmd.wincmd('v')
  end
  vim.cmd.wincmd(dir)
end

Utils.SplitInDirection = function(dir, fn, opts)
  opts = opts or {}
  local bufnr = api.nvim_win_get_buf(0)
  local pos = api.nvim_win_get_cursor(0)
  if opts.new or (vim.fn.winnr() == vim.fn.winnr(dir)) then
    if string.match(dir, '[jk]') then
      vim.cmd.wincmd('s')
    else
      vim.cmd.wincmd('v')
    end
  end
  Utils.WinMove(dir)
  api.nvim_win_set_buf(0, bufnr)
  api.nvim_win_set_cursor(0, pos)
  if type(fn) == 'function' then
    fn(opts.args)
  end
  if opts.zz then
    vim.api.nvim_exec([[norm zz]], false)
  end
end

Utils.SmartResize = function(direction, size)
  if string.match('jk', direction) and (vim.fn.winnr('j') == vim.fn.winnr('k')) then
    return -- prevent horizontally resizing the viewport
  end
  local to_dir = vim.fn.winnr(direction)
  local vertical = (direction == 'h' or direction == 'l') and 'vertical ' or ''
  if to_dir == vim.fn.winnr() then
    vim.cmd(vertical .. [[resize -]] .. size)
  else
    if to_dir == vim.fn.winnr('2' .. direction) then
      vim.cmd(vertical .. to_dir .. [[resize -]] .. size)
    else
      vim.cmd(vertical .. [[resize +]] .. size)
    end
  end
end

Utils.FnNewTab = function(fn, opts)
  opts = opts or {}
  vim.cmd('norm m1')
  if api.nvim_buf_get_name(0) == "" then
    vim.cmd('tabnew')
  else
    vim.cmd('tabedit %')
  end
  vim.cmd('norm `1')
  if type(fn) == 'function' then
    fn()
  end
  if opts.zz then
    vim.cmd('norm zz')
  end
end

-- to be updated
Utils.get_langserv = function()
  local ret = ""
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  local b = false
  for _, v in ipairs(clients) do
    if b then
      ret = ret .. ' | ' .. v.name
    else
    ret = ' ' .. v.name
    end
    b = false
  end
  return ret
end

Utils.get_treesitter = function()
  if vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil then
    return true
  else
    return false
  end
end

return Utils
