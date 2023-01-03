" partial.vim
" Author: yasunori-kirin0418
" License: MIT

let g:partial#search_head_pattern = '^\S <% partial_path: '
let g:partial#search_tail_pattern = '^\S %>'
let g:partial#match_except_path = '^\W*\w*: '

" Name: partial#_get_range
" Description:  Get the line number of the range you want to partial file.
" Return: dict{ bufname
"               startline
"               endline }
function! partial#_get_range() abort
  let origin_startline = search(g:partial#search_head_pattern, 'bcW')
  let origin_endline = search(g:partial#search_tail_pattern, 'nW')
  let origin_bufname = bufname('%')

  if origin_startline == 0 || origin_endline == 0
    echohl WarningMsg
    echomsg 'Not found partial tag.'
    echohl None
    return v:false
  endif

  return {
        \ 'bufname': origin_bufname,
        \ 'startline': origin_startline,
        \ 'endline': origin_endline
        \ }
endfunction

" Name: partial#_get_file_path
" Description: Extract the file path specified in the startline.
" Params: int
" Return: string
function! partial#_get_file_path(startline) abort
  let head_string = getline(a:startline)
  let path_string = substitute(head_string, g:partial#match_except_path, '', '')
  return path_string
endfunction

" Name: partial#_get_line
" Description: Get the string of the partial range as an array.
" Params: dict(_get_range)
" Return: list[...]
function! partial#_get_line(range) abort
  return getbufline(a:range['bufname'], a:range['startline'], a:range['endline'])
endfunction
