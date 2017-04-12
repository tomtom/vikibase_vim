" Viki.vim -- Some kind of personal wiki for Vim
" @Author:      Tom Link (micathom AT gmail com?subject=vim)
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     08-Dec-2003.
" @Last Change: 2017-04-07.
" @Revision:    2805
"
" GetLatestVimScripts: 861 1 viki.vim
"
" Short Description:
" This plugin adds wiki-like hypertext capabilities to any document.  
" Just type :VikiMinorMode and all wiki names will be highlighted. If 
" you press <c-cr> (or <LocalLeader>vf) when the cursor is over a wiki 
" name, you jump to (or create) the referred page. When invoked via :set 
" ft=viki, additional highlighting is provided.
"
" Requirements:
" - tlib.vim (vimscript #1863)
" 
" Optional Enhancements:
" - vikitasks.vim (vimscript #2894)
" - kpsewhich (not a vim plugin :-) for vikiLaTeX

if &cp || exists('g:loaded_vikibase')
    finish
endif
let g:loaded_vikibase = 500


if !exists('g:viki_name_suffix')
    " Default file suffix (including the optional period, e.g. '.viki').
    " Can also be buffer-local.
    let g:viki_name_suffix = '.viki' "{{{2
endif

if !exists('g:viki_intervikis')
    " Definition of intervikis. (This variable won't be evaluated until 
    " autoload/viki.vim is loaded).
    let g:viki_intervikis = {}   "{{{2
endif


augroup Viki
    au!
augroup end


function! VikiDefine(...) "{{{3
    call call(function('viki#interviki#Define'), a:000)
endf


for [s:iname, s:idef] in items(g:viki_intervikis)
    " VikiDefine(name, prefix, ?suffix="*", ?index="Index.${suffix}")
    if type(s:idef) == 1
        call call('VikiDefine', [s:iname, s:idef])
    else
        call call('VikiDefine', [s:iname] + s:idef)
    endif
    unlet! s:iname s:idef
endfor


" :display: VikiDefine NAME BASE ?SUFFIX
" Define an interviki. See also |VikiDefine()|.
command! -nargs=+ VikiDefine call VikiDefine(<f-args>)

" command! -nargs=1 -complete=customlist,viki#BrowseComplete VikiBrowse :call viki#Browse(<q-args>)

" Open the |viki-homepage|.
" command! VikiHome :call viki#HomePage()

" Open the |viki-homepage|.
" command! VIKI :call viki#HomePage()


" " :display: :Vikifind[!] KIND PATTERN
" " Use |:Trag| to search the current directory or, with the optional [!] 
" " search all intervikis matching |g:viki#find_intervikis_rx|. See 
" " |:Trag| for the allowed values for KIND.
" "
" " NOTE: This command requires the trag plugin to be installed.
" command! -bar -bang -nargs=+ -complete=customlist,trag#CComplete Vikifind if exists(':Trag') == 2 | Trag<bang> --filenames --file_sources=*viki#FileSources <args> | else | echom ':Vikifind requires the trag_vim plugin to be installed!' | endif


if !empty('g:viki_name_suffix') && g:viki_name_suffix !=# '.viki' && exists('#filetypedetect')
    exec 'autocmd filetypedetect BufRead,BufNewFile *'. g:viki_name_suffix .' if empty(&ft) | setf viki | endif'
endif


