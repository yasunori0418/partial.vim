" partial.vim
" Author: yasunori-kirin0418
" License: MIT

let g:partial#search_head_pattern = '^\S <% partial_path: '
let g:partial#search_tail_pattern = '^\S %>'

" Name: partial#_get_range
" Return: list[partial_start_line, partial_end_line]
function! partial#_get_range() abort
  let b:origin_head_line = search(g:partial#search_head_pattern, 'bcW')
  let b:origin_tail_line = search(g:partial#search_tail_pattern, 'nW')

  if b:origin_head_line == 0 || b:origin_tail_line == 0
    echohl WarningMsg
    echomsg 'Not found partial tag.'
    echohl None
    return
  endif

  return [b:origin_head_line, b:origin_tail_line]
endfunction
