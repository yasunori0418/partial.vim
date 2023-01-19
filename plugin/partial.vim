" partial.vim
" Author: yasunori-kirin0418
" License: MIT

if exists('g:loaded_partial_vim')
    finish
endif
let g:loaded_partial_vim = 1

command! -bang -nargs=1 PartialOpen call partial#open(<bang>0, <args>)
