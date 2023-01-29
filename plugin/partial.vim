" partial.vim
" Author: yasunori-kirin0418
" License: MIT

if exists('g:loaded_partial_vim')
    finish
endif
let g:loaded_partial_vim = 1

call partial#option()

command! -bang -nargs=1 PartialOpen call partial#open(<bang>0, <f-args>)
command! -bang -nargs=1 PartialTabedit call partial#open(<bang>0, <f-args>, 'tabedit')
command! -bang -nargs=1 PartialVsplit call partial#open(<bang>0, <f-args>, 'vsplit')
command! -bang -nargs=1 PartialSplit call partial#open(<bang>0, <f-args>, 'split')
command! -bang -nargs=1 PartialEdit call partial#open(<bang>0, <f-args>, 'edit')
command! -nargs=1 PartialCreate echo 'Create partial file: ' . partial#create(1, <f-args>)
command! PartialUpdate call partial#update_origin()
