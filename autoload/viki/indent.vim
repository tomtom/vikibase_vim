" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2017-03-31
" @Revision:    2

if !exists('g:viki#indent#desc')
    " Possible values: 'sw', '::'
    let g:viki#indent#desc = 'sw'   "{{{2
endif


function! viki#indent#GetIndent()
    let lr = &lazyredraw
    set lazyredraw
    try
        let cnum = v:lnum
        " Find a non-blank line above the current line.
        let lnum = prevnonblank(v:lnum - 1)

        " At the start of the file use zero indent.
        if lnum == 0
            Tlibtrace 'viki', lnum
            return 0
        endif

        let ind  = indent(lnum)
        " if ind == 0
        "     TLogVAR ind
        "     return 0
        " end

        let line = getline(lnum)      " last line
        Tlibtrace 'viki', lnum, ind, line
        
        let cind  = indent(cnum)
        let cline = getline(cnum)
        Tlibtrace 'viki', v:lnum, cnum, cind, cline
        
        " Do not change indentation in regions
        if viki#IsInRegion(cnum)
            Tlibtrace 'viki', cnum, cind
            return cind
        endif
        
        let cHeading = matchend(cline, '^\*\+\s\+')
        if cHeading >= 0
            Tlibtrace 'viki', cHeading
            return 0
        endif
            
        let pnum   = v:lnum - 1
        let pind   = indent(pnum)
        let pline  = getline(pnum) " last line
        let plCont = matchend(pline, '\\$')
        
        if plCont >= 0
            Tlibtrace 'viki', plCont, cind
            return cind
        end

        " if pline =~ '^\s*\(+++\|!!!\|???\|###\)\s'
        "     Tlibtrace 'viki', "marker:", pline
        "     return pind + 4
        " endif
        
        if cind > 0
            Tlibtrace 'viki', cind
            " Do not change indentation of:
            "   - commented lines
            "   - headings
            if cline =~ '^\(\s*%\|\*\)'
                Tlibtrace 'viki', cline, ind
                return ind
            endif

            let markRx = '^\s\+\([#?!+]\)\1\{2,2}\s\+'
            let listRx = '^\s\+\([-+*#?@]\|[0-9#]\+\.\|[a-zA-Z?]\.\)\s\+'
            let priRx  = '^\s\+#[A-Z]\d\? \+\([x_0-9%-]\+ \+\)\?'
            let descRx = '^\s\+.\{-1,}\s::\s\+'
            
            let clMark = matchend(cline, markRx)
            let clList = matchend(cline, listRx)
            let clPri  = matchend(cline, priRx)
            let clDesc = matchend(cline, descRx)
            " let cln    = clList >= 0 ? clList : clDesc

			" let swhalf = &sw / 2
			let swhalf = 2

            if clList >= 0 || clDesc >= 0 || clMark >= 0 || clPri >= 0
                " let spaceEnd = matchend(cline, '^\s\+')
                " let rv = (spaceEnd / &sw) * &sw
                let rv = (cind / &sw) * &sw
                Tlibtrace 'viki', clList, clDesc, clMark, clPri, rv
                return rv
            else
                let plMark = matchend(pline, markRx)
                if plMark >= 0
                    Tlibtrace 'viki', plMark
                    " return plMark
                    return pind + 4
                endif
                
                let plList = matchend(pline, listRx)
                if plList >= 0
                    Tlibtrace 'viki', plList
                    return plList
                endif

                let plPri = matchend(pline, priRx)
                if plPri >= 0
                    " let rv = indent(pnum) + &sw / 2
                    let rv = pind + swhalf
                    Tlibtrace 'viki', plPri, rv
                    " return plPri
                    return rv
                endif

                let plDesc = matchend(pline, descRx)
                if plDesc >= 0
                    Tlibtrace 'viki', plDesc, pind
                    if plDesc >= 0 && g:viki#indent#desc == '::'
                        " return plDesc
                        return pind
                    else
                        return pind + swhalf
                    endif
                endif

                Tlibtrace 'viki', cind, ind
                if cind < ind
                    let rv = (cind / &sw) * &sw
                    return rv
                elseif cind >= ind
                    if cind % &sw == 0
                        return cind
                    else
                        return ind
                    end
                endif
            endif
        endif

        Tlibtrace 'viki', ind
        return ind
    finally
        let &lazyredraw = lr
    endtry
endf

