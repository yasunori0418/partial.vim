" partial.vim
" Author: yasunori-kirin0418
" License: MIT

if exists('g:loaded_partial_vim')
    finish
endif
let g:loaded_partial_vim = 1

if has('linux') || has('mac')
  let g:partial#use_os_type = 'posix'
elseif has('win64')
  let g:partial#use_os_type = 'windows'
endif
