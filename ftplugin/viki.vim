" viki.vim -- the viki ftplugin
" @Author:      Tom Link (micathom AT gmail com?subject=vim)
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Revision: 557

if exists('b:did_ftplugin') "{{{2
    finish
endif
let b:did_ftplugin = 1


setlocal commentstring=%\ %s
setlocal comments=fb:-,fb:+,fb:*,fb:#,fb:?,fb:@,:%

setlocal expandtab
setlocal iskeyword+={
setlocal iskeyword+=192-255
setlocal iskeyword-=_
let &l:include = '\(^\s*#INC.\{-}\(\sfile=\|:\)\)'
let &l:define = '^\s*\(#Def.\{-}id=\|#\(Fn\|Footnote\).\{-}\(:\|id=\)\|#VAR.\{-}\s\)'

nnoremap <buffer> <silent> [[ ?^*\+\s<cr>
nnoremap <buffer> <silent> ][ /^*\+\s<cr>
nmap     <buffer> <silent> ]] ][
nmap     <buffer> <silent> [] [[

let b:undo_ftplugin = 'setlocal iskeyword< expandtab< comments< commentstring< define< include< '
            \ .'| silent! nunmap <buffer> [['
            \ .'| silent! nunmap <buffer> ]]'
            \ .'| silent! nunmap <buffer> ]['
            \ .'| silent! nunmap <buffer> []'

