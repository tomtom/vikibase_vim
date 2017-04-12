" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2017-04-07
" @Revision:    31


if !exists('g:viki#interviki#edit_cmd')
    let g:viki#interviki#edit_cmd = &hidden ? 'edit' : 'split'   "{{{2
endif


if !exists('g:viki#interviki#explore_cmd')
    let g:viki#interviki#explore_cmd = &hidden ? 'Explore' : 'Sexplore'   "{{{2
endif

let g:vikiInterVikiNames  = []

let s:InterVikiNameRx = '^\([[:upper:]0-9]\+\)'
let s:InterVikiRx = s:InterVikiNameRx .'::\(.*\)$'


" :def: viki#interviki#Define(name, prefix, ?suffix="*", ?index="Index.${suffix}")
" Define an interviki name
" suffix == "*" -> g:viki_name_suffix
function! viki#interviki#Define(name, prefix, ...) abort "{{{3
    if a:name =~# '[^A-Z0-9]'
        throw 'Invalid interviki name: '. a:name
    endif
    call add(g:vikiInterVikiNames, a:name .'::')
    call sort(g:vikiInterVikiNames)
    let g:vikiInter{a:name}          = a:prefix
    let g:vikiInter{a:name}_suffix   = a:0 >= 1 && a:1 !=# '*' ? a:1 : g:viki_name_suffix
    let index = a:0 >= 2 && !empty(a:2) ? tlib#file#Join([a:prefix, a:2]) : a:prefix
    if exists(':'+ a:name) != 2
        if isdirectory(index)
            let index .= '/'
        endif
        exec 'command! -bang' a:name 'call feedkeys(":". '. string(g:viki#interviki#edit_cmd .' '. fnameescape(index)) .', "t")'
    else
        echom 'Viki: Command already exists. Cannot define a command for '+ a:name
    endif
endf


function! viki#interviki#GetDest(interviki) abort "{{{3
    let prefix = g:vikiInter{a:interviki}
    if prefix !~# '[\/]$'
        let prefix .= '/'
    endif
    return prefix
endf


" for l:sfx in ['e', 'b:viki_name_suffix', 'g:viki_name_suffix', 'b:vikiNameSuffix', 'g:vikiNameSuffix']
"     if l:sfx ==# 'e'
"         let l:suffix = '.'. expand('%:e')
"     elseif exists(l:sfx)
"         let l:suffix = eval(l:sfx)
"     else
"         continue
"     endif
"     let link1 = link . l:suffix
"     if filereadable(link1)
"         let link = link1
"         break
"     endif
" endfor

" " Get the suffix to use for viki filenames
" function! viki#interviki#GetSuffix(link) abort "{{{3
"     for l:sfx in ['e', 'b:viki_name_suffix', 'g:viki_name_suffix', 'b:vikiNameSuffix', 'g:vikiNameSuffix']
"         if l:sfx ==# 'e'
"             let l:suffix = '.'. expand('%:e')
"         elseif exists(l:sfx)
"             let l:suffix = eval(l:sfx)
"         else
"             continue
"         endif
"         let l:link = a:link . l:suffix
"         if filereadable(l:link)
"             return l:suffix
"         endif
"     endfor
"     return ''
" endf

