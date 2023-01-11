" partial.vim
" Author: yasunori-kirin0418
" License: MIT

let g:partial#comment_out_symbols = {
  \ 'vim': '"',
  \ 'lua': '--',
  \ }
let g:partial#head_string = ' <%'
let g:partial#tail_string = ' %>'
let g:partial#partial_path_prefix = ' partial_path: '
let g:partial#origin_path_prefix = ' origin_path: '
" open_type(edit, vsplit, split, tabedit)
let g:partial#open_type = 'edit'

" Name: partial#surround_pattern
" Description: Generates a pattern of enclosing characters for the part to be a partial file according to the comment out for each language.
" Params: string(filetype)
" Return: dict{head_pattern, tail_pattern}
function! partial#surround_pattern(filetype) abort
  return {
        \ 'head_pattern': g:partial#comment_out_symbols[a:filetype] . g:partial#head_string . g:partial#partial_path_prefix,
        \ 'tail_pattern': g:partial#comment_out_symbols[a:filetype] . g:partial#tail_string,
        \ 'partial_to_origin': g:partial#comment_out_symbols[a:filetype] . g:partial#origin_path_prefix
        \ }
endfunction

" Name: partial#get_range_from_origin
" Description: Returns the range (line number) you want to make into a partial file,
"             the path of original file, and the filetype passed as an argument.
" Params: string(filetype)
" Return: dict{origin_path, origin_directory, startline, endline, surround_patterns, filetype}
function! partial#get_range_from_origin(filetype) abort
  let surround_patterns = partial#surround_pattern(a:filetype)
  let startline = search(surround_patterns.head_pattern, 'bcW')
  let endline = search(surround_patterns.tail_pattern, 'nW')
  let origin_path = fnamemodify(bufname('%'), ':p')
  let origin_directory = fnamemodify(origin_path, ':p:h')

  if startline == 0 || endline == 0
    echohl WarningMsg
    echomsg 'Not found partial tag.'
    echohl None

    return {}
  endif

  return {
        \ 'origin_path': origin_path,
        \ 'origin_directory': origin_directory,
        \ 'startline': startline,
        \ 'endline': endline,
        \ 'surround_patterns': surround_patterns,
        \ 'filetype': a:filetype,
        \ }
endfunction

" Name: partial#get_range_from_partial
" Description: From the original file information attached when creating the partial file,
"             get the partial range of original file.
" Return: dict{origin_path, partial_path, startline, endline}
function! partial#get_range_from_partial() abort
  let surround_patterns = partial#surround_pattern(&filetype)
  let origin_head_string = search(surround_patterns.head_pattern, 'bcW')->getline()
  let origin_path = search(surround_patterns.partial_to_origin, 'nW')
                  \ ->getline()
                  \ ->substitute(surround_patterns.partial_to_origin, '', '')
                  \ ->substitute(g:partial#tail_string, '', '')
  execute 'vsplit' origin_path
  let startline = search(origin_head_string, 'cW')
  let endline = search(surround_patterns.tail_pattern, 'nW')
  execute 'bdelete' bufname('%')

  return {
        \ 'origin_head_string': origin_head_string,
        \ 'origin_path': origin_path,
        \ 'startline': startline,
        \ 'endline': endline,
        \ }
endfunction

" Name: partial#_get_file_path
" Description: Extract the file path specified in the startline.
" Params: dict(get_range_from_origin)
" Return: string(path)
function! partial#_get_file_path(range) abort
  let head_string = getline(a:range.startline)
  let path_string = substitute(head_string, a:range.surround_patterns.head_pattern, '', '')

  if partial#__is_absolute_path(path_string)
    return path_string
  else

    if has('linux') || has('mac')
      return a:range.origin_directory . '/' . path_string
    elseif has('win64')
      return a:range.origin_directory . '\' . path_string
    endif
  endif
endfunction

" Name: partial#__is_absolute_path
" Description: Neovim does not have an isabsolutepath, so prepare it as a helper.
" Params: string(path)
" Return: boolean
function! partial#__is_absolute_path(path) abort
  let posix_absolute_pattern = '/'
  let windows_absolute_pattern = '\u:\'

  if has('linux') || has('mac')
    return match(a:path, posix_absolute_pattern) == 0
  elseif has('win64')
    return match(a:path, windows_absolute_pattern) == 0
  endif
endfunction

" Name: partial#_get_line_from_origin
" Description: Get the string of the partial range as an array.
" Params: dict(get_range_from_origin)
" Return: list
function! partial#_get_line_from_origin(range) abort
  if has('linux') || has('mac')
    let home_dir_env = '$HOME'
  elseif has('win64')
    let home_dir_env = '$USERPROFILE'
  endif

  let origin_lines = getline(a:range.startline, a:range.endline - 1)
  let partial_head_string = g:partial#comment_out_symbols[a:range.filetype]
                          \ . g:partial#origin_path_prefix
                          \ . a:range.origin_path->substitute(expand(home_dir_env), home_dir_env, '')
                          \ . g:partial#tail_string

  call add(origin_lines, partial_head_string)
  return origin_lines
endfunction

" Name: partial#open
" Description: Create a file containing the code to be partial and open it in a new buffer.
"             If the file already exists, open it.
" Params: string(filetype)
" Return: void
function! partial#open(filetype, open_type = g:partial#open_type) abort
  let partial_range = partial#get_range_from_origin(a:filetype)
  if empty(partial_range)
    return
  endif
  let partial_file_path = partial#_get_file_path(partial_range)
  let partial_directory = fnamemodify(partial_file_path, ':h')

  if !isdirectory(partial_directory)
    call mkdir(partial_directory)
  endif

  if !filereadable(partial_file_path)
    call partial#_get_line_from_origin(partial_range)->writefile(partial_file_path, 'b')
  endif

  if a:open_type =~# 'edit\|vsplit\|split\|tabedit'
    execute a:open_type partial_file_path
  else
    echohl WarningMsg
    echomsg 'Wrong open_type => ' . a:open_type
    echohl None
  endif
endfunction

" Name: partial#update_origin
" Description: Update the original file from the partial file.
" Return: void


" Name: partial#update_partial
" Description: Update a partial file from the original file.
" Params: string(filetype)
" Return: void
