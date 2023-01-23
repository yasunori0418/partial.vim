" partial.vim
" Author: yasunori-kirin0418
" License: MIT

" Name: partial#helper#is_absolute_path
" Description: Neovim does not have an isabsolutepath, so prepare it as a helper.
" Params: string(path)
" Return: boolean
function! partial#helper#is_absolute_path(path) abort
  if has('linux') || has('mac')
    return match(a:path, '/') == 0 || match(a:path, '\$') == 0
  elseif has('win64')
    return match(a:path, '\u:\\') == 0 || match(a:path, '\$') == 0
  endif
endfunction

" Name: partial#helper#get_range_from_origin
" Description: Returns the range (line number) you want to make into a partial file,
"             the path of original file, and the filetype passed as an argument.
" Params: string(filetype)
" Return: dict{origin_path, origin_directory, startline, endline, surround_patterns, filetype}
function! partial#helper#get_range_from_origin(filetype) abort
  let surround_patterns = partial#helper#surround_pattern(a:filetype)
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

" Name: partial#helper#surround_pattern
" Description: Generates a pattern of enclosing characters for the part to be a partial file according to the comment out for each language.
" Params: string(filetype)
" Return: dict{head_pattern, tail_pattern}
function! partial#helper#surround_pattern(filetype) abort
  return {
        \ 'head_pattern': g:partial#comment_out_symbols[a:filetype] . g:partial#head_symbol . g:partial#partial_path_prefix,
        \ 'tail_pattern': g:partial#comment_out_symbols[a:filetype] . g:partial#tail_symbol,
        \ 'partial_to_origin': g:partial#comment_out_symbols[a:filetype] . g:partial#origin_path_prefix
        \ }
endfunction

" Name: partial#helper#get_file_path
" Description: Extract the file path specified in the startline.
" Params: dict(get_range_from_origin)
" Return: string(path)
function! partial#helper#get_file_path(range) abort
  let head_string = getline(a:range.startline)
  let path_string = substitute(head_string, a:range.surround_patterns.head_pattern, '', '')

  if partial#helper#is_absolute_path(path_string)
    return fnamemodify(path_string, ':p:.')
  else

    if has('linux') || has('mac')
      return fnamemodify(a:range.origin_directory . '/' . path_string, ':p:.')
    elseif has('win64')
      return fnamemodify(a:range.origin_directory . '\' . path_string, ':p:.')
    endif
  endif
endfunction
