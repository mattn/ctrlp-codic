if exists('g:loaded_ctrlp_codic') && g:loaded_ctrlp_codic
  finish
endif
let g:loaded_ctrlp_codic = 1

let s:codic_var = {
\  'init':   'ctrlp#codic#init()',
\  'exit':   'ctrlp#codic#exit()',
\  'accept': 'ctrlp#codic#accept',
\  'lname':  'codic',
\  'sname':  'codic',
\  'type':   'path',
\  'sort':   0,
\  'nolim':  1,
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:codic_var)
else
  let g:ctrlp_ext_vars = [s:codic_var]
endif

function! ctrlp#codic#start()
  let s:old_matcher = get(g:, 'ctrlp_match_func', 0)
  let g:ctrlp_match_func = {'match': 'ctrlp#codic#matcher'}
  let s:old_key_loop = get(g:, 'ctrlp_key_loop', 0) "note: default is 0, check github.com/ctrlpvim/ctrlp.vim/autoload/ctrlp.vim
  let g:ctrlp_key_loop = 1
  call ctrlp#init(ctrlp#codic#id())
endfunction

function! ctrlp#codic#init()
  return []
endfunc

function! ctrlp#codic#matcher(items, input, limit, mmode, ispath, crfile, regex)
  silent! let items = codic#search(a:input, 0)
  if type(items) == type(0)
    return []
  endif
  return map(items, 'v:val["label"] . ":\t" . join(map(copy(v:val["values"]), "v:val[\"word\"]"), ",")')
endfunction

function! ctrlp#codic#accept(mode, str)
  call ctrlp#exit()
  call codic#command(matchstr(a:str, '^.*\ze:\t'))
endfunction

function! ctrlp#codic#exit()
  call s:revert_settings()
endfunction

function! s:revert_settings()
  if type(s:old_matcher) == 0
    unlet! g:ctrlp_match_func
  else
    let g:ctrlp_match_func = s:old_matcher
  endif
  let g:ctrlp_key_loop = s:old_key_loop
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#codic#id()
  return s:id
endfunction

" vim:fen:fdl=0:ts=2:sw=2:sts=2
