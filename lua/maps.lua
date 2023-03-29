local map = vim.keymap.set
local defcommand = vim.api.nvim_create_user_command
local exec = function(s)
  vim.api.nvim_exec(s, false)
end
local dmap = function(mode, key, func, desc, opt)
  opt = opt or {}
  opt.desc = desc
  map(mode, key, func, opt)
end

local exp = { expr = true, noremap = true }

defcommand('SaveSession', 'SessionManager save_current_session', { force = true })
defcommand('LoadSession', 'SessionManager load_session', { force = true })
defcommand('DelSession', 'SessionManager delete_session', { force = true })
defcommand('Banner', function(args)
  require('utils').Banner(args)
end, {
  force = true,
  nargs = '?',
})

defcommand('Diff', function(args)
  local a = args.fargs[1]
  local b = args.fargs[2]
  if a == nil or b == nil then
    print("error: 2 files needed")
    return
  end
  vim.cmd.tabedit(a)
  vim.cmd.vsplit(b)
  vim.cmd.windo('diffthis')
end, {
  force = true,
  nargs = "+",
  complete = 'file'
})

map({ 'x', 'n' }, 'gA', 'ga')
map({ 'x', 'n' }, 'g<Space>', ':EasyAlign<CR>*<Space>')

for k, _ in string.gmatch('\'"[](){}<>`', '.') do
  map('n', [[<Space>]] .. k, [[<Plug>(sandwich-add)iW]] .. k)
  map('x', [[<Space>]] .. k, [[<Plug>(sandwich-add)]] .. k)
end

map('i', '<A-s>', '<Plug>luasnip-expand-or-jump')
map('i', '<A-a>', function()
  require('luasnip').jump(-1)
end)

----------------------------------------------------
-- tabs, buffers
----------------------------------------------------

map('n', '<A-a>', '<cmd>tabprevious<cr>')
map('n', '<A-d>', '<cmd>tabnext<cr>')
map('n', '<A-t>', '<cmd>tabnew<CR>')
map('n', '<A-C>', '<cmd>tabclose<CR>')
dmap('n', '<Space>u', '<C-^>', 'Last Used Buffer')
map('t', '<A-n>', [[<C-\><C-n>]])

map({ 'n', 'x' }, '<leader>m', ':Norm ')
map('n', 'Q', '@q')

map({ 'n', 'x' }, '<Space><CR>', function()
  require('hop').hint_words()
end)
map({ 'n', 'x' }, '<Space><BS>', function()
  require('hop').hint_lines()
end)
map({ 'n', 'x', 'o' }, 'f', function()
  require('hop').hint_char1({
    direction = require('hop.hint').HintDirection.AFTER_CURSOR,
    current_line_only = true,
  })
end)
map({ 'n', 'x', 'o' }, 'F', function()
  require('hop').hint_char1({
    direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
    current_line_only = true,
  })
end)
map({ 'n', 'x', 'o' }, 't', function()
  require('hop').hint_char1({
    direction = require('hop.hint').HintDirection.AFTER_CURSOR,
    current_line_only = true,
    hint_offset = -1,
  })
end)
map({ 'n', 'x', 'o' }, 'T', function()
  require('hop').hint_char1({
    direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
    current_line_only = true,
    hint_offset = -1,
  })
end)

map('n', '<C-M-h>', function()
  require('utils').SmartResize('h', 1)
end)
map('n', '<C-M-j>', function()
  require('utils').SmartResize('j', 1)
end)
map('n', '<C-M-k>', function()
  require('utils').SmartResize('k', 1)
end)
map('n', '<C-M-l>', function()
  require('utils').SmartResize('l', 1)
end)

map('n', '<C-s>', '<cmd>update<CR>')
map('n', '<A-c>', '<cmd>q<CR>')
map({ 'n', 't' }, '<A-Esc>', function()
  if vim.bo.buftype == 'terminal' then
    exec([[stopinsert]])
  else
    exec([[qa!]])
  end
end)
map('n', '<Up>', '<C-Y>k')
map('n', '<Down>', '<C-E>j')
map('x', '<Up>', '<C-Y>k')
map('x', '<Down>', '<C-E>j')
map('n', '<C-j>', '<Plug>MoveLineDown')
map('n', '<C-k>', '<Plug>MoveLineUp')
-- map('n', '<C-H>', '<Plug>MoveCharLeft', {})
-- map('n', '<C-L>', '<Plug>MoveCharRight', {})
map('v', '<C-j>', '<Plug>MoveBlockDown', {})
map('v', '<C-k>', '<Plug>MoveBlockUp', {})
-- map('v', '<C-H>', '<Plug>MoveBlockLeft' , {})
-- map('v', '<C-L>', '<Plug>MoveBlockRight', {})

map('n', 'sE', '<cmd>g/^$/d<CR>')
map('n', 'sbc', '<cmd>.!bc -l<CR>')
map('n', 'sbq', '<cmd>.!qalc | grep "=" | cut -d"=" -f2 | xargs<CR>')
map('n', 'sbp', '<cmd>.!python<CR>')
map('x', 'sbc', '!bc -l<CR>')
map('x', 'sbp', '!python<CR>')
map('n', 'se', '<cmd>.!$SHELL<CR>')
map('x', 'se', '!$SHELL<CR>')
dmap('n', 'sx', function()
  require('expand_expr').expand()
end, 'Expand lua expression')
dmap({ 'n', 'x' }, 'sF', '<cmd>Format<CR>', 'Format document (Formatter)')
dmap({ 'n', 'x' }, 'sf', vim.lsp.buf.format, 'Format document (lsp)')
dmap('n', 'sj', ':a<CR><CR>.<CR>', 'Append newline under', { silent = true })
dmap('n', 'sk', ':i<CR><CR>.<CR>', 'Append newline above', { silent = true })

map('n', ']b', '<cmd>bnext<CR>')
map('n', '[b', '<cmd>bprevious<CR>')
map('n', '<Space><Space>', '<C-^>')

----------------------------------------------------
-- make life a bit easier
----------------------------------------------------

map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')
map('n', 'Y', 'y$')
map('v', ';', ':')
map('n', ';', ':')
map('x', '.', ':norm.<CR>')
-- map('x', 'Q', ":'<,'>:normal @q<CR>")
map({ 'n', 'v' }, 'c', '"_c')
map({ 'n', 'v' }, 'C', '"_C')
map('i', '<C-v>', '<C-r>+')
map('n', '<M-=>', '<cmd>wincmd =<CR>')
map('n', 'J', 'mzJ`z')

local CC = true
map('n', '<A-i>', function()
  -- exec([[IndentBlanklineToggle]])
  -- exec([[TSContextToggle]])
  if CC then
    vim.wo.colorcolumn = '80,120'
    vim.wo.cursorline = true
  else
    vim.wo.colorcolumn = '0'
    vim.wo.cursorline = false
  end
  CC = not CC
end)
map('i', '<A-e>', '<C-o>e<Right>')
map('i', '<A-w>', '<C-o>w')
map('i', '<A-b>', '<C-o>b')
map({ 'x', 'n' }, '<Left>', '^')
map({ 'x', 'n' }, '<Right>', '$')

map('i', '<C-h>', '<Left>')
map('i', '<C-l>', '<Right>')
map('i', '<A-[>', '<C-o>A{}<Left>')
map('n', '<A-[>', 'A{}<Left>')

map('i', '<A-;>', '<C-o>mz<C-o>:norm A;<CR><C-o>`z')
map('n', '<A-;>', 'mz:norm A;<CR>`z')

-- paste last yanked thing, not deleted
dmap('n', 'sp', '"0P', 'Paste before cursor', { silent = true })
dmap('n', 'sP', 'viw"0P', 'Paste after cursor', { silent = true })
dmap('x', 'sp', '"0P', 'Paste', { silent = true })

----------------------------------------------------
-- EasyAlign
----------------------------------------------------

dmap({ 'n', 'x' }, 'ga', '<Plug>(EasyAlign)', 'EasyAlign')

----------------------------------------------------
-- Window splits
----------------------------------------------------

map({ 'n', 'i', 't', 'v' }, '<A-h>', function()
  require('utils').WinMove('h')
end)
map({ 'n', 'i', 't', 'v' }, '<A-j>', function()
  require('utils').WinMove('j')
end)
map({ 'n', 'i', 't', 'v' }, '<A-k>', function()
  require('utils').WinMove('k')
end)
map({ 'n', 'i', 't', 'v' }, '<A-l>', function()
  require('utils').WinMove('l')
end)

map({ 'n', 'i', 't', 'v' }, '<A-H>', function()
  require('utils').SplitAndFocus('h')
end)
map({ 'n', 'i', 't', 'v' }, '<A-J>', function()
  require('utils').SplitAndFocus('j')
end)
map({ 'n', 'i', 't', 'v' }, '<A-K>', function()
  require('utils').SplitAndFocus('k')
end)
map({ 'n', 'i', 't', 'v' }, '<A-L>', function()
  require('utils').SplitAndFocus('l')
end)

----------------------------------------------------
-- autopairs behaviour
----------------------------------------------------
-- these mappings are coq recommended mappings unrelated to smart-pairs
map('i', '<esc>', [[pumvisible() ? "<c-e><esc>" : "<esc>"]], exp)
map('i', '<c-c>', [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], exp)
map('i', '<tab>', [[pumvisible() ? "<c-n>" : "<tab>"]], exp)
map('i', '<s-tab>', [[pumvisible() ? "<c-p>" : "<bs>"]], exp)

CR = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
      return '<c-y>'
    else
      return '<c-e>' .. [[<cmd>lua require'pairs.enter'.type()<CR>]]
    end
  else
    return [[<cmd>lua require'pairs.enter'.type()<CR>]]
  end
end
map('i', '<cr>', 'v:lua.CR()', exp)

dmap('n', '<space>T', function()
  require('utils').FnNewTab(nil, { zz = true })
end, 'Open New Tab')

dmap('n', '<A-I>', '<cmd>IndentBlanklineToggle<cr>', 'Toggle Indent Lines')

----------------------------------------------------
-- Telescope, lsp
----------------------------------------------------

dmap('n', '<Space>hv', ':vert help ', ':vert help')
dmap('n', '<Space>ht', ':tab help ', ':tab help')
dmap('n', '<Space>ho', ':help  | only' .. string.rep("<Left>", 7), ':vert help')
dmap('n', 'gi', function() require('telescope.builtin').lsp_implementations() end, 'Go to Implementation')
dmap('n', '<Space>f', function() require('telescope.builtin').find_files() end, 'Find Files')
dmap('n', '<Space>,', function() require('telescope.builtin').resume() end, 'Resume previous telescope')
dmap('n', '<Space>F', function() require('telescope.builtin').git_files() end, 'Find Files (Git)')
dmap('n', '<Space>g', function() require('telescope.builtin').live_grep() end, 'Grep')
dmap('n', '<Space>b', function() require('telescope.builtin').buffers() end, 'Buffers')
dmap('n', '<Space>m', function() require('telescope.builtin').marks() end, 'Marks')
dmap('n', '<Space>h;', function() require('telescope.builtin').command_history() end, 'Command History')
dmap('n', '<Space>h:', function() require('telescope.builtin').command_history() end, 'Command History')
dmap('n', '<Space>h/', function() require('telescope.builtin').search_history() end, 'Search History')
dmap('n', '<Space>H', function() require('telescope.builtin').help_tags() end, 'Help tags')
dmap('n', '<Space>r', function() require('telescope.builtin').registers() end, 'Registers')
dmap('n', '<Space>N', "<cmd>Notifications<cr>", 'Notifications')
dmap('n', '<Space>ts', function() require('telescope.builtin').treesitter() end, 'Treesitter Symbols')
dmap('n', '<Space>th', '<cmd>TSHighlightCapturesUnderCursor<cr>', 'Treesitter Highlight Captures')
dmap('n', '<Space>L', vim.diagnostic.setloclist, 'Diagnostic Set Loclist')
dmap('n', '<Space>l', function() require('telescope.builtin').loclist() end, 'Diagnostic Loclist')
dmap('n', '<Space>a', vim.lsp.buf.code_action, "Code Action")
dmap('n', 'gr', function() require('telescope.builtin').lsp_references() end, 'Go to References')
dmap('n', 'gdd', function() require('telescope.builtin').lsp_definitions() end, 'Go to Definition')
dmap('n', 'gs', vim.lsp.buf.declaration, 'Go to Declaration')
dmap('n', 'gdt', function() require('utils').FnNewTab(require('telescope.builtin').lsp_definitions, { zz = true }) end, 'Go to Definition (new tab)')
dmap('n', 'gdT', function() require('telescope.builtin').lsp_type_definitions() end, 'Go to Type Definition')

for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
  dmap('n', 'gd' .. key, function()
    require('utils').SplitInDirection(key, require('telescope.builtin').lsp_definitions, { zz = true })
  end, 'Go to Definition (split ' .. key .. ')')
end

local smart_rename = function()
  if vim.g.Get_langserv() ~= '' then
    return [[<cmd>lua vim.lsp.buf.rename()<cr>]]
  elseif vim.g.Get_treesitter() ~= '' then
    return [[<cmd>lua require('nvim-treesitter-refactor.smart_rename').smart_rename(vim.api.nvim_win_get_buf(0))<cr>]]
  else
    return [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
  end
end
map('n', 'ss', smart_rename, {expr = true, desc = "Rename"})
dmap('n', 's.', [[:.s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Substitute (line)")
dmap('n', 's,', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Substitute (file)")

map('n', '<Space>qp', '<cmd>cprev<CR>')
map('n', '<Space>qn', '<cmd>cnext<CR>')
map('n', '<Space>qc', '<cmd>cclose<CR>')
map('n', '<Space>qo', '<cmd>copen<CR>')
dmap('n', '<Space>qf', function() require('telescope.builtin').quickfix() end, 'Quickfix list')
dmap('n', '<Space>D', function() vim.diagnostic.setqflist() end, 'Diagnostics to qflist')
dmap('n', '<Space>/', function() require('telescope.builtin').current_buffer_fuzzy_find() end, 'Grep current buffer')
dmap('n', '<Space>#', function() require('telescope.builtin').grep_string() end, 'Grep current word')
dmap('n', '<Space>vo', function() require('telescope.builtin').vim_options() end, 'Vim options')
dmap('n', '<Space>km', function() require('telescope.builtin').keymaps() end, 'Keymaps')
dmap('n', '<Space>J', function() require('telescope.builtin').jumplist() end, 'Jumplist')
dmap('n', '<space>ss', function() require('telescope.builtin').spell_suggest() end, "Spell suggest")
dmap('n', '<Space>d', function() require('telescope.builtin').diagnostics() end, 'Treesitter diagnostics')
dmap('n', 'g[', function() vim.diagnostic.goto_prev() end, 'Go to previous diagnostic')
dmap('n', 'g]', function() vim.diagnostic.goto_next() end, 'Go to next diagnostic')
dmap('n', 'sh', function() vim.lsp.buf.hover() end, 'Symbol hover information')
dmap('n', 'sM', function() require('telescope.builtin').man_pages({ sections = { '1', '3' } }) end, 'Man pages (1,3)')
dmap('n', 'sbm', function() require('telescope.builtin').find_files({ cwd = '~/.dotfiles' }) end, 'Dotfiles')
dmap('n', '<Space>sh', '<cmd>ClangdSwitchSourceHeader<cr>', 'Switch source and header')

-- harpoon
dmap('n', '<Space>ha', function() require("harpoon.mark").add_file() end, 'Harpoon Add File')
dmap('n', '<Space>hM', function() require("harpoon.ui").toggle_quick_menu() end, 'Harpoon Menu')
dmap('n', '<Space>hm', "<cmd>Telescope harpoon marks theme=ivy<cr>", 'Harpoon Telescope')

map('n', '<BS>;', function()
  require('telescope').extensions.dap.commands(require('telescope.themes').get_ivy({}))
end, { desc = 'Telescope DAP Commands' })
map('n', '<BS>C', function()
  require('telescope').extensions.dap.configurations(require('telescope.themes').get_ivy({}))
end, { desc = 'Telescope DAP Configurations' })
map('n', '<BS>B', function()
  require('telescope').extensions.dap.list_breakpoints(require('telescope.themes').get_ivy({}))
end, { desc = 'Telescope DAP Breakpoints' })
map('n', '<BS>v', function()
  require('telescope').extensions.dap.variables(require('telescope.themes').get_ivy({}))
end, { desc = 'Telescope DAP Variables' })
map('n', '<BS>f', function()
  require('telescope').extensions.dap.frames(require('telescope.themes').get_ivy({}))
end, { desc = "Telescope DAP Frames" })

map('n', '<BS>E', function() require('dapui').close() end, { desc = 'Debug: Close DAP UI' })
map('n', '<BS>b', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
map('n', '<BS>c', function() require('dap').continue() end, { desc = 'Debug: Continue' })
map('n', '<BS>i', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
map('n', '<BS>o', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
map('n', '<BS>r', function() require('dap').repl.open() end, { desc = 'Debug: Open REPL' })
map('n', '<BS>u', function() require('dapui').toggle() end, { desc = 'Debug: Toggle UI' })
map('n', '<BS>h', function() require('dap.ui.widgets').hover() end, { desc = 'Debug: Hover Symbol' })
map({ 'n', 'v' }, '<BS>e', function() require('dapui').eval() end, { desc = 'Debug: Eval Expression' })
