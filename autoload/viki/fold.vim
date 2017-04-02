" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2017-04-02
" @Revision:    68


if !exists('g:viki#fold#max_headings')
    let g:viki#fold#max_headings = 1000   "{{{2
endif


function! viki#fold#MaybeInvalidateData(text) abort "{{{3
    " Always invalidate the data
    if !exists('b:viki_fold_headings_invalidated') && exists('b:viki_fold_headings')
        let b:viki_fold_headings_invalidated = 1
        au Viki CursorHold,CursorHoldI <buffer> call s:InvalidateData()
    endif
endf


function! s:InvalidateData() abort "{{{3
    au! Viki CursorHold,CursorHoldI <buffer> call s:InvalidateData()
    unlet! b:viki_fold_headings_invalidated
    unlet! b:viki_fold_headings
endf


function! viki#fold#Foldexpr(lnum) abort "{{{3
    if !exists('b:viki_fold_headings')
        call s:MakeHeadingsData()
    endif
    if !exists('b:viki_fold_headings')
        return -1
    else
        return b:viki_fold_headings.GetFoldLevel(a:lnum)
    endif
endf


let s:node = {}

function! s:node.GetFoldLevel(lnum) abort dict "{{{3
    if a:lnum < self.mid
        return self.left.GetFoldLevel(a:lnum)
    else
        return self.right.GetFoldLevel(a:lnum)
    endif
endf


let s:leaf = {}

function! s:leaf.GetFoldLevel(lnum) abort dict "{{{3
    if self.lnum == a:lnum
        return '>'. self.level
    else
        return self.level
    endif
endf


let s:empty = {}

function! s:empty.GetFoldLevel(lnum) abort dict "{{{3
    return -1
endf




function! s:MakeHeadingsData() abort "{{{3
    let l:lnums = []
    let l:headings = {}
    let l:pos = getpos('.')
    try
        let l:lnum = 0
        while 1
            let l:lnum += 1
            exec l:lnum
            norm! 0
            let l:lnum = search('^\*\+\ze\s', 'ceW')
            if l:lnum == 0
                break
            else
                call add(l:lnums, l:lnum)
                let l:headings[''. l:lnum] = col('.')
            endif
        endwh
    finally
        call setpos('.', l:pos)
    endtry
    if len(l:lnums) >= g:viki#fold#max_headings
        setlocal foldexpr&
    else
        let b:viki_fold_headings = s:Node(l:lnums, l:headings)
    endif
endf


function! s:Node(lnums, headings) abort "{{{3
    let l:llen = len(a:lnums)
    if l:llen == 0
        return copy(s:empty)
    elseif l:llen == 1
        let l:leaf = copy(s:leaf)
        let l:leaf.lnum = a:lnums[0]
        let l:leaf.level = a:headings[''. a:lnums[0]]
        return l:leaf
    elseif l:llen > 1
        let l:node = copy(s:node)
        let l:mid = l:llen / 2
        let l:node.mid = a:lnums[l:mid]
        let l:node.left = s:Node(a:lnums[0 : l:mid - 1], a:headings)
        let l:node.right = s:Node(a:lnums[l:mid : -1], a:headings)
        return l:node
    endif
endf

