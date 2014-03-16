" Vim global plugin for binding custom indent file per project.
" Last Change:  2011 Feb 03
" Maintainer:   Konstantin Lepa <konstantin.lepa@gmail.com>
" License:      MIT
" Version:      1.0.0
"
" Changes {{{
" 1.0.0 2011-02-03
"   Initial upload.
"}}}
"

if exists("b:loaded_cscope_plus")
    finish
endif
let b:loaded_cscope_plus = 1

if !exists("g:cscope_plus_disable")
    let g:cscope_plus_disable = 0
endif

if !exists("s:cscope_plus_open_buf_map")
    let s:cscope_plus_open_buf_map = {}
endif

if !exists("*s:AddCscopeConnection")
    function s:AddCscopeConnection()
        setlocal nocsverb
        if filereadable(expand("%:p:h") . "/cscope.out")
            let b:CSCOPE_PLUS_connection = expand("%:p:h") . "/cscope.out"
            let s:cscope_plus_open_buf_map[expand("%:p")] = 1
            exec "cs add " . b:CSCOPE_PLUS_connection
        elseif filereadable("cscope.out")
            let b:CSCOPE_PLUS_connection = "cscope.out"
            let s:cscope_plus_open_buf_map[expand("%:p")] = 1
            exec "cs add " . b:CSCOPE_PLUS_connection
        elseif exists("$CSCOPE_DB") && filereadable("$CSCOPE_DB")
            let b:CSCOPE_PLUS_connection = $CSCOPE_DB
            let s:cscope_plus_open_buf_map[expand("%:p")] = 1
            exec "cs add " . b:CSCOPE_PLUS_connection
        endif
        setlocal csverb
    endfunction
endif

if !exists("*s:RemoveCscopeConnection")
    function s:RemoveCscopeConnection()
        unlet s:cscope_plus_open_buf_map[expand("%:p")]
        setlocal nocsverb
        if exists("b:CSCOPE_PLUS_connection") && empty(s:cscope_plus_open_buf_map)
            exec "cs kill " . b:CSCOPE_PLUS_connection
        endif
        setlocal csverb
    endfunction
endif

if !exists("*s:MapCscopeKeys")
    function s:MapCscopeKeys(l_key)
        exec 'nmap <buffer> ' . a:l_key . 's :cs find s <C-R>=expand("<cword>")<CR><CR>'
        exec 'nmap <buffer> ' . a:l_key . 'g :cs find g <C-R>=expand("<cword>")<CR><CR>'
        exec 'nmap <buffer> ' . a:l_key . 'c :cs find c <C-R>=expand("<cword>")<CR><CR>'
        exec 'nmap <buffer> ' . a:l_key . 't :cs find t <C-R>=expand("<cword>")<CR><CR>'
        exec 'nmap <buffer> ' . a:l_key . 'e :cs find e <C-R>=expand("<cword>")<CR><CR>'
        exec 'nmap <buffer> ' . a:l_key . 'f :cs find f <C-R>=expand("<cfile>")<CR><CR>'
        exec 'nmap <buffer> ' . a:l_key . 'i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>'
        exec 'nmap <buffer> ' . a:l_key . 'd :cs find d <C-R>=expand("<cword>")<CR><CR>'

        exec 'nmap <buffer> ' . a:l_key . a:l_key . 's :scs find s <C-R>=expand("<cword>")<CR><CR>'
        exec 'nmap <buffer> ' . a:l_key . a:l_key . 'g :scs find g <C-R>=expand("<cword>")<CR><CR>'
        exec 'nmap <buffer> ' . a:l_key . a:l_key . 'c :scs find c <C-R>=expand("<cword>")<CR><CR>'
        exec 'nmap <buffer> ' . a:l_key . a:l_key . 't :scs find t <C-R>=expand("<cword>")<CR><CR>'
        exec 'nmap <buffer> ' . a:l_key . a:l_key . 'e :scs find e <C-R>=expand("<cword>")<CR><CR>'
        exec 'nmap <buffer> ' . a:l_key . a:l_key . 'f :scs find f <C-R>=expand("<cfile>")<CR><CR>'
        exec 'nmap <buffer> ' . a:l_key . a:l_key . 'i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>'
        exec 'nmap <buffer> ' . a:l_key . a:l_key . 'd :scs find d <C-R>=expand("<cword>")<CR><CR>'

        "show help with h
        exec 'nmap <buffer> ' . a:l_key . 'h :cs<CR>'
    endfunction
endif

if has("cscope") && g:cscope_plus_disable == 0
    setlocal csto=0
    setlocal cst

    if !exists("g:cscope_plus_leader_key")
        let g:cscope_plus_leader_key = "<C-_>"
    endif
    call s:MapCscopeKeys(g:cscope_plus_leader_key)

    au BufWinEnter <buffer> call s:AddCscopeConnection()
    au BufWinLeave <buffer> call s:RemoveCscopeConnection()
endif

