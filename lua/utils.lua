local api = vim.api
local exec = function(s)
  api.nvim_exec(s, false)
end
local M = {}

M.WinMove = function(key)
  local curwin = vim.fn.winnr()
  vim.cmd.wincmd(key)
  if curwin == vim.fn.winnr() then
    if os.getenv('TERM_PROGRAM') == 'WezTerm' then
      local dir = {
        ['h'] = 'Left',
        ['j'] = 'Down',
        ['k'] = 'Up',
        ['l'] = 'Right',
      }
      vim.fn.system('wezterm cli activate-pane-direction ' .. dir[key])
    end
  end
end

M.SplitAndFocus = function(dir)
  if string.match(dir, '[jk]') then
    vim.cmd.wincmd('s')
  else
    vim.cmd.wincmd('v')
  end
  M.WinMove(dir)
end

M.SplitInDirection = function(dir, fn, opts)
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
  M.WinMove(dir)
  api.nvim_win_set_buf(0, bufnr)
  api.nvim_win_set_cursor(0, pos)
  if type(fn) == 'function' then
    fn(opts.args)
  end
  if opts.zz then
    exec([[norm zz]])
  end
end

M.SmartResize = function(direction, size)
  if string.match('jk', direction) and (vim.fn.winnr('j') == vim.fn.winnr('k')) then
    return -- prevent horizontally resizing the viewport
  end
  local to_dir = vim.fn.winnr(direction)
  local vertical = (direction == 'h' or direction == 'l') and 'vertical ' or ''
  if to_dir == vim.fn.winnr() then
    exec(vertical .. [[resize -]] .. size)
  else
    if to_dir == vim.fn.winnr('2' .. direction) then
      exec(vertical .. to_dir .. [[resize -]] .. size)
    else
      exec(vertical .. [[resize +]] .. size)
    end
  end
end

M.FnNewTab = function(fn, opts)
  opts = opts or {}
  exec('norm m1')
  exec('tabedit %')
  exec('norm `1')
  if type(fn) == 'function' then
    fn()
  end
  if opts.zz then
    exec('norm zz')
  end
end

return M
