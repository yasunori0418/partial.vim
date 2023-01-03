" partial.vim
" Author: yasunori-kirin0418
" License: MIT

let g:partial#search_head_pattern = '^\S <% partial_path: '
let g:partial#search_tail_pattern = '^\S %>'
let g:partial#match_except_path = '^\W*\w*: '

" Name: partial#_get_range
" Description:  Get the line number of the range you want to partial file.
" Return: list[partial_start_line, partial_end_line]
function! partial#_get_range() abort
  let origin_startline = search(g:partial#search_head_pattern, 'bcW')
  let origin_endline = search(g:partial#search_tail_pattern, 'nW')

  if origin_startline == 0 || origin_endline == 0
    echohl WarningMsg
    echomsg 'Not found partial tag.'
    echohl None
    return v:false
  endif

  return [origin_startline, origin_endline]
endfunction

" Name: partial#_get_file_path
" Description: Extract the file path specified in the startline.
function! partial#_get_file_path(startline) abort
  let head_string = getline(a:startline)
  let path_string = substitute(head_string, g:partial#match_except_path, '', '')
  return path_string
endfunction
