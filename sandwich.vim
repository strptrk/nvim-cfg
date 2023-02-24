let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)

function! TexEnvCompl(argread, cmdline, cursorpos) abort
    let n = strlen(a:argread)
    let list = copy(g:TexEnvironments)
    if n > 0
        let list = filter(list, 'v:val[: n-1] ==# a:argread')
    endif
    return list
endfunction

function! TexEnvInput(is_head) abort
    if a:is_head
        let b:TexEnvLast = input('Environment-name: ', '', 'customlist,TexEnvCompl')
        let command = printf('\begin{%s}', b:TexEnvLast)
    else
        let command = printf('\end{%s}', b:TexEnvLast)
    endif
    return command
endfunction

function! TexCmdInput(is_head) abort
    if a:is_head
        let l:TexCmdLast = input('Command: ', '')
        let command = printf('\%s{', l:TexCmdLast)
    else
        let command = '}'
    endif
    return command
endfunction

let g:sandwich#recipes += [
            \   {
            \       'buns'    : ['\begingroup', '\endgroup'],
            \       'nesting' : 1,
            \       'input': [ '\gr' ],
            \       'filetype': ['tex', 'plaintex'],
            \       'linewise': 1
            \   },
            \   {
            \       'buns'    : ['\toprule', '\bottomrule'],
            \       'nesting' : 1,
            \       'input': [ '\tr', '\br' ],
            \       'filetype': ['tex', 'plaintex'],
            \       'linewise': 1
            \   },
            \   {
            \       'buns'    : ['TexCmdInput(1)', 'TexCmdInput(0)'],
            \       'filetype': ['tex', 'plaintex'],
            \       'kind'    : ['add', 'replace'],
            \       'action'  : ['add'],
            \       'expr'    : 1,
            \       'nesting' : 1,
            \       'input'   : ['c'],
            \       'indentkeys-' : '{,},0{,0}'
            \   },
            \   {
            \       'buns'    : ['TexEnvInput(1)', 'TexEnvInput(0)'],
            \       'filetype': ['tex', 'plaintex'],
            \       'kind'    : ['add', 'replace'],
            \       'action'  : ['add'],
            \       'expr'    : 1,
            \       'nesting' : 1,
            \       'linewise' : 1,
            \       'input'   : ['e'],
            \       'indentkeys-' : '{,},0{,0}',
            \       'autoindent' : 0
            \   },
            \   {
            \       'buns'    : ['\\\a\+\*\?{', '}'],
            \       'filetype': ['tex', 'plaintex'],
            \       'kind'    : ['delete', 'replace', 'auto', 'query'],
            \       'regex'   : 1,
            \       'nesting' : 1,
            \       'input'   : ['c'],
            \       'indentkeys-' : '{,},0{,0}'
            \   },
            \   {
            \       'buns'    : ['\\begin{[^}]*}\(\[.*\]\)\?', '\\end{[^}]*}'],
            \       'filetype': ['tex', 'plaintex'],
            \       'kind'    : ['delete', 'replace', 'auto', 'query'],
            \       'regex'   : 1,
            \       'nesting' : 1,
            \       'linewise' : 1,
            \       'input'   : ['e'],
            \       'indentkeys-' : '{,},0{,0}',
            \       'autoindent' : 0
            \   },
            \   {
            \       'buns'    : ['\(\\left\((\|\[\||\|\\{\|\\langle\|\\lvert\)\|\\left\.\)', '\(\\right\()\|]\||\|\\}\|\\rangle\|\\rvert\)\|\\right\.\)'],
            \       'filetype': ['tex', 'plaintex'],
            \       'kind'    : ['delete', 'replace', 'auto', 'query'],
            \       'regex'   : 1,
            \       'nesting' : 1,
            \       'input'   : ['ma'],
            \       'indentkeys-' : '{,},0{,0}',
            \       'autoindent' : 0
            \   },
            \ ]
