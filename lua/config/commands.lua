vim.api.nvim_create_user_command("Diff", function(args)
  local a_file = args.fargs[1]
  local b_file = args.fargs[2]
  if a_file == nil or b_file == nil then
    print("error: 2 files needed")
    return
  end
  vim.cmd.tabedit(a_file)
  vim.cmd.vsplit(b_file)
  vim.cmd.windo("diffthis")
end, {
  force = true,
  nargs = "+",
  complete = "file",
})

vim.api.nvim_create_user_command("Mktmpf", function(args)
  math.randomseed(os.time())
  local dname = "/tmp/tmpdir_nvim_" .. vim.env["USER"] .. tostring(math.random(100000, 999999))
  local fname = "main." .. args.fargs[1]
  os.execute("mkdir -p " .. dname)
  vim.cmd("cd " .. dname)
  vim.cmd("e " .. fname)
end, { nargs = 1 })

-- remove trailing whitespaces from the whole file, or range
vim.api.nvim_create_user_command("Trim", function(opts)
  local range_start = tostring(opts.line1)
  local range_end = tostring(opts.line2)
  local success, _ = pcall(function()
    vim.cmd(range_start .. "," .. range_end .. [[s/\s\+$//]])
  end)
  vim.cmd("nohls")
  if success then
    vim.notify("Trailing whitespaces removed!", vim.log.levels.INFO)
  else
    vim.notify("No trailing whitespace found!", vim.log.levels.INFO)
  end
end, { nargs = 0, range = "%" })


vim.api.nvim_create_user_command("Right", function(args)
  require("config.utils").split('l', args.args)
end, { force = true, nargs = '+', complete = "command" })

vim.api.nvim_create_user_command("Left", function(args)
  require("config.utils").split('h', args.args)
end, { force = true, nargs = '+', complete = "command" })

vim.api.nvim_create_user_command("Up", function(args)
  require("config.utils").split('k', args.args)
end, { force = true, nargs = '+', complete = "command" })

vim.api.nvim_create_user_command("Down", function(args)
  require("config.utils").split('j', args.args)
end, { force = true, nargs = '+', complete = "command" })

vim.api.nvim_create_user_command('Help', function(args)
  require("config.utils").mkscratch()
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_set_option_value("buftype", "help", { buf = buf })
  vim.api.nvim_set_option_value("filetype", "help", { buf = buf })
  vim.cmd("help " .. args.args)
end, { desc = 'Open help in current window', nargs = "*", complete = "help" })

vim.api.nvim_create_user_command('Scratch', function()
  require("config.utils").mkscratch()
end, { desc = 'Open a scratch buffer', nargs = 0 })
