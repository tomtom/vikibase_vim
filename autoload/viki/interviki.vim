" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2017-10-30
" @Revision:    64


if !exists('g:viki#interviki#edit_cmd')
    let g:viki#interviki#edit_cmd = &hidden ? 'edit' : 'split'   "{{{2
endif


if !exists('g:viki#interviki#explore_cmd')
    let g:viki#interviki#explore_cmd = &hidden ? 'Explore' : 'Sexplore'   "{{{2
endif


if !exists('g:viki#interviki#special_protocols')
    " URLs matching these protocols are handled by |VikiOpenSpecialProtocol()|.
    " Can also be buffer-local.
    let g:viki#interviki#special_protocols = 'https\?\|ftps\?\|nntp\|mailto\|mailbox\|file' "{{{2
    if exists('g:viki#interviki#special_protocols_extra')
        let g:viki#interviki#special_protocols .= '\|'. g:viki#interviki#special_protocols_extra
    endif
endif


let g:viki#interviki#names  = []

let s:InterVikiNameRx = '^\([[:upper:]0-9]\+\)'
let s:InterVikiRx = s:InterVikiNameRx .'::\(.*\)$'


" :def: viki#interviki#Define(name, prefix, ?suffix="*", ?index="Index.${suffix}")
" Define an interviki name
" suffix == "*" -> g:viki_name_suffix
function! viki#interviki#Define(name, prefix, ...) abort "{{{3
    if a:name =~# '[^A-Z0-9]'
        throw 'Invalid interviki name: '. a:name
    endif
    call add(g:viki#interviki#names, a:name .'::')
    call sort(g:viki#interviki#names)
    let prefix = a:prefix
    if prefix !~# '[\/]$'
        let prefix .= '/'
    endif
    let g:vikiInter{a:name} = prefix
    if prefix !~# g:viki#interviki#special_protocols
        let g:vikiInter{a:name}_suffix = a:0 >= 1 && a:1 !=# '*' ? a:1 : g:viki_name_suffix
    endif
    let baseindex = a:0 >= 2 ? a:2 : 'Index'. g:viki_name_suffix
    let index = prefix
    if !empty(baseindex)
        let index0 = tlib#file#Join([prefix, baseindex])
        if filereadable(index0)
            let index = index0
            let g:vikiInter{a:name}_index = index
        endif
    endif
    if exists(':'+ a:name) != 2
        exec 'command! -bang' a:name 'call feedkeys(":". '. string(g:viki#interviki#edit_cmd) .'." ". (<bang>0 ? '. string(fnameescape(index)) .' : '. string(fnameescape(prefix)) .'), "t")'
    else
        echom 'Viki: Command already exists. Cannot define a command for '+ a:name
    endif
endf


function! viki#interviki#GetInterVikis() abort "{{{3
    return g:viki#interviki#names
endf


function! viki#interviki#IsKnown(name) abort "{{{3
    return exists('g:vikiInter'. a:name)
endf


function! viki#interviki#IsSpecialName(name) abort "{{{3
    let dest = viki#interviki#GetPrefix(a:name)
    return dest =~# g:viki#interviki#special_protocols
endf


function! s:Get(name, what) abort "{{{3
    let suffix = empty(a:what) ? '' : '_'. a:what
    if exists('g:vikiInter'. a:name . suffix)
        return g:vikiInter{a:name}{suffix}
    else
        return ''
    endif
endf


function! viki#interviki#GetPrefix(name) abort "{{{3
    return s:Get(a:name, '')
endf


function! viki#interviki#GetSuffix(name) abort "{{{3
    return s:Get(a:name, 'suffix')
endf


function! viki#interviki#GetIndex(name) abort "{{{3
    return s:Get(a:name, 'index')
endf


function! viki#interviki#GetDest(name) abort "{{{3
    let prefix = viki#interviki#GetPrefix(a:name)
    if !empty(prefix) && prefix !~# '[\/]$'
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

