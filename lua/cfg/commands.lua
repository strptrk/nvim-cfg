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
