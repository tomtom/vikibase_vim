" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2017-04-01
" @Revision:    15


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
" suffix == "*" -> g:vikiNameSuffix
function! viki#interviki#Define(name, prefix, ...) "{{{3
    if a:name =~ '[^A-Z0-9]'
        throw 'Invalid interviki name: '. a:name
    endif
    call add(g:vikiInterVikiNames, a:name .'::')
    call sort(g:vikiInterVikiNames)
    let g:vikiInter{a:name}          = a:prefix
    let g:vikiInter{a:name}_suffix   = a:0 >= 1 && a:1 != '*' ? a:1 : g:vikiNameSuffix
    let index = a:0 >= 2 && !empty(a:2) ? tlib#file#Join([a:prefix, a:2]) . g:vikiInter{a:name}_suffix : a:prefix
    if exists(':'+ a:name) != 2
        if isdirectory(index)
            exec 'command! -bang' a:name g:viki#interviki#explore_cmd fnameescape(index)
        else
            exec 'command! -bang' a:name g:viki#interviki#edit_cmd fnameescape(index)
        endif
    else
        echom 'Viki: Command already exists. Cannot define a command for '+ a:name
    endif
endf

