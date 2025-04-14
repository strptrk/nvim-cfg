local M = {
  debug = {
    executable = nil,
    args = nil,
    host = nil,
  },
  findcmd = nil,
  findcmd_args = {
    fd   = { "--type", "x", "--color", "never", "--no-ignore-vcs" },
    find = { ".", "-executable", "-type", "f", "-not", "-path", "*/.git/*" },
  },
  dap = nil,
  picker = {}
}

---@param lhs table
---@param rhs any
local function table_extend(lhs, rhs)
  if type(rhs) ~= "table" then
    rhs = { rhs }
  end
  for _, v in ipairs(rhs) do
    table.insert(lhs, v)
  end
end

function M.get_dap()
  if not M.dap then
    M.dap = require("dap")
    local success, dap = pcall(require, "dap")
    if not success or not dap then
      vim.notify("nvim dap not available", vim.log.levels.ERROR)
    end
    M.dap = dap
  end
  return M.dap or {}
end

function M.picker.get_dap_commands()
  if not M.picker.dap_commands then
    M.picker.dap_commands = {}
    local dap = M.get_dap()
    for k, v in pairs(dap) do
      if type(v) == "function" then
        table.insert(M.picker.dap_commands, { text = k })
      end
    end
  end
  return M.picker.dap_commands
end

function M.pick_dap_commands(opts)
  opts = opts or {}
  opts.layout = opts.layout or {}
  if not opts.layout.preset then
    opts.layout.preset = "select"
  end

  local on_confirm = function(picker)
    picker:close()
    local item = picker:current()
    if not item then
      return
    end
    M.get_dap()[item.text]()
  end

  Snacks.picker.pick({
    source = "Commands",
    items = M.picker.get_dap_commands(),
    format = "text",
    confirm = on_confirm,
    preview = "none",
    layout = {
      preset = opts.layout.preset,
    },
  })
end

function M.set_target(target, force)
  if target then
    M.debug.executable = target
  elseif force or M.debug.executable == nil or M.debug.executable == "" then
    local placeholder = M.debug.executable or (vim.fn.getcwd() .. "/")
    local tmp = vim.fn.input("Path to executable: ", placeholder, "file")
    if tmp ~= nil and tmp ~= "" then
      M.debug.executable = tmp
    end
  end
  return M.debug.executable
end

function M.set_args(fargs, force)
  if fargs then
    M.debug.args = fargs
  elseif force or M.debug.args == nil then
    local placeholder = table.concat(M.debug.args or {}, " ")
    local split = vim.split(vim.fn.input("Arguments: ", placeholder), " ")
    if not split or (#split == 1 and split[1] == "") then
      M.debug.args = M.debug.args or {}
    else
      M.debug.args = split
    end
  end
  return M.debug.args
end

---@param opts?{ cwd?: string, full?: boolean }
function M.get_findcmd(opts)
  opts = opts or {}
  if M.findcmd == nil then
    if 1 == vim.fn.executable("fd") then
      M.findcmd = "fd"
    elseif 1 == vim.fn.executable("fdfind") then
      M.findcmd = "fdfind"
      M.findcmd_args.fdfind = M.findcmd_args.fd
    elseif 1 == vim.fn.executable("gfind") then
      M.findcmd = "gfind"
      M.findcmd_args.gfind = M.findcmd_args.find
    elseif 1 == vim.fn.executable("find") then
      M.findcmd = "find"
    else
      vim.notify("No `fd`, `fdfind` or `find` found.")
      return nil
    end
  end
  local args
  if not opts.cwd then
    args = M.findcmd_args[M.findcmd]
  else
    args = {}
    if M.findcmd == "fd" or M.findcmd == "fdfind" then
      table.insert(args, ".")
      table.insert(args, opts.cwd)
    end
    table_extend(args, M.findcmd_args[M.findcmd])
    if M.findcmd == "find" or M.findcmd == "gfind" then
      args[1] = opts.cwd -- replace "." with cwd
    end
  end
  if opts.full then
    local findcmd_full = { M.findcmd }
    table_extend(findcmd_full, args)
    return {
      cmd = findcmd_full,
    }
  end
  return {
    cmd = M.findcmd,
    args = args
  }
end

function M.set_host(arg, force)
  if arg then
    M.debug.host = arg
  elseif force or M.debug.host == nil then
    local placeholder = M.debug.host or "localhost:"
    local tmp = vim.fn.input("Hostname: ", placeholder)
    if tmp ~= nil and tmp ~= "" then
      M.debug.host = tmp
    end
  end
  return M.debug.host
end

function M.telescope_available()
  local success, result = pcall(require, "telescope.pickers")
  if success and result then
    return true
  end
  return false
end

function M.telescope_pick_executable(opts)
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  opts = opts or {}

  local findcmd = M.get_findcmd({ full = true, cwd = opts.cwd })
  if not findcmd then
    return
  end
  pickers
      .new(opts, {
        prompt_title = "Executable to debug",
        finder = finders.new_oneshot_job(findcmd.cmd, opts),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, _)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            M.debug.executable = vim.fn.getcwd() .. "/" .. action_state.get_selected_entry()[1]
            if opts.callback then
              opts.callback()
            end
          end)
          return true
        end,
      })
      :find()
end

function M.snacks_available()
  local success, result = pcall(require, "snacks.picker.source.proc")
  if success and result then
    return true
  end
  return false
end

function M.snacks_pick_executable(opts)
  opts = opts or {}
  opts.layout = opts.layout or {}
  if not opts.layout.preset then
    opts.layout.preset = "select"
  end
  local findcmd = M.get_findcmd({ cwd = opts.cwd })
  if not findcmd then
    return
  end

  local on_confirm = function(picker)
    if opts.callback then
      picker:close()
      local item = picker:current()
      if not item then
        return
      end
      M.debug.executable = vim.fn.getcwd() .. "/" .. item.text
      opts.callback(M.debug.executable)
    end
  end

  local find_executables = function(opts_, ctx)
    return require("snacks.picker.source.proc").proc({
      opts_,
      {
        cmd = findcmd.cmd,
        args = findcmd.args,
        transform = function(item)
          item.file = item.text
        end,
      },
    }, ctx)
  end

  Snacks.picker.pick({
    source = "Executables",
    finder = find_executables,
    format = "file",
    confirm = on_confirm,
    preview = "none",
    filter = { cwd = opts.cwd },
    layout = {
      preset = opts.layout.preset,
    },
  })
end

function M.pick_target(opts)
  opts = opts or {}
  if opts.force or M.debug.executable == nil or M.debug.executable == "" then
    if M.snacks_available() then
      M.snacks_pick_executable(opts)
    elseif M.telescope_available() then
      M.telescope_pick_executable(opts)
    end
  end
  return M.debug.executable
end

function M.get_first_path(executables, fallback)
  if type(executables) ~= "table" then
    executables = { executables }
  end
  for _, pr in ipairs(executables) do
    local path = vim.fn.exepath(pr)
    if path ~= "" then
      return path
    end
  end
  return fallback
end

return M
