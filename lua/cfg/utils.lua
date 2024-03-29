local api = vim.api

Utils = {}

Utils.__filesize_cache = {} -- pitfall: if the filesize is around the limit, it will not change
-- file_too_big(size, lang)
--
-- size: size limit in kibibytes (1024 bytes)
-- ts: return a (lang, bufnr) kind of function to use in treesitter's disable field
Utils.file_too_big = function(size, ts)
  local too_big = function(bufnr)         -- lang, bufnr
    local ok, filename
    ok, filename = pcall(vim.api.nvim_buf_get_name, bufnr)
    if not ok then return false end
    if Utils.__filesize_cache[filename] == nil then
      local fstats
      ok, fstats = pcall((vim.loop or vim.uv).fs_stat, filename)
      if not ok or not fstats then -- buffer does not represent a file on disk
        local byte_size = vim.api.nvim_buf_get_offset(bufnr, vim.api.nvim_buf_line_count(bufnr))
        filename = "buf_" .. bufnr
        Utils.__filesize_cache[filename] = byte_size
      else
        Utils.__filesize_cache[filename] = fstats.size
      end
    end
    return Utils.__filesize_cache[filename] > size * 1024
  end
  if ts then
    return function(_, bufnr) return too_big(bufnr) end
  else
    return too_big
  end
end

Utils.winmove = function(key)
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
      if vim.fn.system([[tmux display-message -p '#{window_zoomed_flag}']]) == '0' .. string.char(10) then
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

Utils.split_focus = function(dir)
  if string.match(dir, '[jk]') then
    vim.cmd.wincmd('s')
  else
    vim.cmd.wincmd('v')
  end
  vim.cmd.wincmd(dir)
end

Utils.split = function(dir, fn, opts)
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
  Utils.winmove(dir)
  api.nvim_win_set_buf(0, bufnr)
  api.nvim_win_set_cursor(0, pos)
  if type(fn) == 'function' then
    fn(opts.args)
  end
  if opts.zz then
    vim.cmd([[norm zz]])
  end
end

Utils.resize = function(direction, size)
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

Utils.fntab_ignored_ft = {
  ["neo-tree"] = true,
  ["toggleterm"] = true,
  ["terminal"] = true,
  ["help"] = true,
  ["alpha"] = true,
  ["dashboard"] = true,
  ["Trouble"] = true,
  ["lazy"] = true,
  ["nofile"] = true,
  [""] = true,
}

Utils.fntab = function(fn, opts)
  opts = opts or {}
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
  if not filetype or Utils.fntab_ignored_ft[filetype] then
    vim.cmd('tabnew')
  else
    vim.cmd('norm mz')
    vim.cmd('tabedit %')
    vim.cmd('norm `z')
  end
  if type(fn) == 'function' then
    fn(opts.args)
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
  for _, name in ipairs(clients) do
    if b then
      ret = ret .. ' | ' .. name.name
    else
    ret = ' ' .. name.name
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
