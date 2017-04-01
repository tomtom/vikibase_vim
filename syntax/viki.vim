" viki.vim -- the viki syntax fileviki_viki#SetupBuffer
" @Author:      Tom Link (micathom AT gmail com?subject=vim)
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     30-Dez-2003.
" @Last Change: 2017-04-01.
" @Revision: 57.1113

if version < 600
    syntax clear
elseif exists('b:current_syntax')
    finish
endif
scriptencoding utf-8

syntax spell toplevel

runtime syntax/texmath.vim

syn match vikiSemiParagraph /^\s\+$/

syn match vikiEscape /\\/ contained containedin=vikiEscapedChar
syn match vikiEscapedChar /\\\_./ contains=vikiEscape,vikiChar

syn match vikiAnchor /^[[:blank:]]*%\?[[:blank:]]*#\l.*/
syn match vikiMarkers /\V\%(###\|???\|!!!\|+++\)/

if has('conceal') && &encoding ==# 'utf-8'
    let s:sym_cluster = []
    for [s:name, s:chars, s:cchar] in [
                \ ['Dash', '--', '—'],
                \ ['Unequal', '!=', '≠'],
                \ ['Identity', '==', '≡'],
                \ ['Approx', '~~', '≈'],
                \ ['ArrowLR', '<-\+>', '↔'],
                \ ['ArrowL', '<-\+', '←'],
                \ ['ArrowR', '-\+>', '→'],
                \ ['ARROWLR', '<=\+>', '⇔'],
                \ ['ARROWL', '<=\+', '⇐'],
                \ ['ARROWR', '=\+>', '⇒'],
                \ ['ArrowTildeLR', '<~\+>', '↭'],
                \ ['ArrowTildeL', '<~\+', '↜'],
                \ ['ArrowTildeR', '~\+>', '↝'],
                \ ['Ellipsis', '...', '…'],
                \ ['Circumflex', '\^\%({}\)\?', '^'],
                \ ]

        exec 'syn match vikiSymbol'. s:name .' /\V'. s:chars .'/ conceal cchar='. s:cchar
        call add(s:sym_cluster, 'vikiSymbol'. s:name)
    endfor
    syn match vikiSymbolExtra /\V\%(&\%(#\d\+\|\w\+\);\)/
    exec 'syn cluster vikiSymbols contains=vikiSymbolExtra,'. join(s:sym_cluster, ',')
    unlet s:name s:chars s:cchar s:sym_cluster
else
    syn match vikiSymbols /\V\%(--\|!=\|==\+\|~~\+\|<-\+>\|<=\+>\|<~\+>\|<-\+\|-\+>\|<=\+\|=\+>\|<~\+\|~\+>\|...\|&\%(#\d\+\|\w\+\);\)/
    syn cluster vikiSymbols contains=vikiSymbols
endif

syntax match vikiLink /\C\(\<[A-Z0-9_]\+::\)\?\%(\<\u\l\+\(\u[[:lower:]0-9]\+\)\+\>\)\(#\l\w*\>\)\?/
if has('conceal')
    " cchar=^
    syntax region vikiExtendedLinkInfo matchgroup=vikiExtendedLinkMarkup start=/\[\[\(\(\\\[\|[^]]\)\+\]\[\)\?/ end=/\][!*]\?\]/ concealends contained containedin=vikiExtendedLink
    syntax match vikiExtendedLink /\[\[\%(.\{-}\)\?\%(#.\{-}\)\?\]\%(\[[^]]\+\]\)\?[!~*$\-]*\]/ skipnl contains=vikiExtendedLinkInfo
else
    syntax match vikiExtendedLink /\[\[\%(.\{-}\)\?\%(#.\{-}\)\?\]\%(\[[^]]\+\]\)\?[!~*$\-]*\]/ skipnl
endif
" exec "syntax match vikiURL /" . b:vikiUrlSimpleRx . "/"
syn cluster vikiHyperLinks contains=vikiLink,vikiExtendedLink

if has('conceal')
    syn region vikiBold matchgroup=NonText start=/\%(^\|\W\zs\)__\ze[^ 	_]/ end=/__\|\n\{2,}/ skip=/\\_\|\\\n/ contains=vikiEscapedChar,@Spell
                \ concealends
    syn region vikiTypewriter matchgroup=NonText start=/\%(^\|[^\w`]\zs\)''\ze[^ 	']/ end=/''\|\n\{2,}/ skip=/\\'\|\\\n/ contains=vikiEscapedChar,@Spell
                \ concealends
else
    syn region vikiBold start=/\%(^\|\W\zs\)__\ze[^ 	_]/ end=/__\|\n\{2,}/ skip=/\\_\|\\\n/ contains=vikiEscapedChar,@Spell
    syn region vikiTypewriter start=/\%(^\|[^\w`]\zs\)''\ze[^ 	']/ end=/''\|\n\{2,}/ skip=/\\'\|\\\n/ contains=vikiEscapedChar,@Spell
endif
syn cluster vikiTextstyles contains=vikiBold,vikiTypewriter,vikiEscapedChar

syn cluster vikiText contains=@Spell,@vikiTextstyles,@vikiHyperLinks,vikiMarkers,@vikiSymbols

syn match vikiComment /^[[:blank:]]*%.*$/ contains=@vikiHyperLinks,vikiMarkers,vikiEscapedChar

syn match vikiString /\%(^\|[[:blank:]({\[]\)\zs"[^"]*"/ contains=@vikiText

syn region vikiHeading start=/^\*\+\s\+/ end=/\n/ contains=@vikiText

syn match vikiTableRowSep /||\?/ contained containedin=vikiTableRow,vikiTableHead
syn region vikiTableHead start=/^[[:blank:]]*|| / skip=/\\\n/ end=/\%(^\| \)||[[:blank:]]*$/
            \ transparent keepend
syn region vikiTableRow  start=/^[[:blank:]]*| / skip=/\\\n/ end=/\%(^\| \)|[[:blank:]]*$/
            \ transparent keepend

syn keyword vikiCommandNames 
            \ #CAP #CAPTION #LANG #LANGUAGE #INC #INCLUDE #DOC #VAR #KEYWORDS #OPT 
            \ #PUT #CLIP #SET #GET #XARG #XVAL #ARG #VAL #BIB #TITLE #TI #AUTHOR 
            \ #AU #AUTHORNOTE #AN #DATE #IMG #IMAGE #FIG #FIGURE #MAKETITLE 
            \ #MAKEBIB #LIST #DEFLIST #REGISTER #DEFCOUNTER #COUNTER #TABLE #IDX 
            \ #AUTOIDX #NOIDX #DONTIDX #WITH #ABBREV #MODULE #MOD #LTX #INLATEX 
            \ #PAGE #NOP
            \ contained containedin=vikiCommand

syn keyword vikiRegionNames
            \ #Doc #Var #Native #Ins #Write #Code #Inlatex #Ltx #Img #Image #Fig 
            \ #Figure #Footnote #Fn #Foreach #Table #Verbatim #Verb #Abstract 
            \ #Quote #Qu #R #Ruby #Clip #Put #Set #Header #Footer #Swallow #Skip 
            \ contained containedin=vikiMacroDelim,vikiRegion,vikiRegionWEnd,vikiRegionAlt

syn keyword vikiMacroNames 
            \ {fn {cite {attr {attrib {date {doc {var {arg {val {xarg {xval {opt 
            \ {msg {clip {get {ins {native {ruby {ref {anchor {label {lab {nl {ltx 
            \ {math {$ {list {item {term {, {sub {^ {sup {super {% {stacked {: 
            \ {text {plain {\\ {em {emph {_ {code {verb {img {cmt {pagenumber 
            \ {pagenum {idx {let {counter 
            \ contained containedin=vikiMacro,vikiMacroDelim
" workaroud vim syntax }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

syn match vikiSkeleton /{{\_.\{-}[^\\]}}/

syn region vikiMacro matchgroup=vikiMacroDelim start=/{\W\?[^:{}]*:\?/ end=/}/ 
            \ transparent contains=@vikiText,vikiMacroNames,vikiMacro

syn region vikiRegion matchgroup=vikiMacroDelim 
            \ start=/^[[:blank:]]*#\([A-Z]\([a-z][A-Za-z]*\)\?\>\|!!!\)\(\\\n\|.\)\{-}<<\z(.*\)$/ 
            \ end=/^[[:blank:]]*\z1[[:blank:]]*$/ 
            \ contains=@vikiText,vikiRegionNames
syn region vikiRegionAlt matchgroup=vikiMacroDelim 
            \ start=/^[[:blank:]]*\z(=\{4,}\)[[:blank:]]*\([A-Z][a-z]*\>\|!!!\)\(\\\n\|.\)\{-}$/ 
            \ end=/^[[:blank:]]*\z1\([[:blank:]].*\)\?$/ 
            \ contains=@vikiText,vikiRegionNames

syn match vikiCommand /^\C[[:blank:]]*#\%([A-Z]\{2,}\)\>\%(\\\n\|.\)*/
            \ contains=vikiCommandNames

syn match vikiFilesIndicators /^\s*[`_+|\\-]\+\s/ contained containedin=vikiFiles
syn match vikiFiles /^\%(\s*[`_+|\\-]\+\s\+\)\?\[\[.\{-}\]!\].*$/
            \ contained containedin=vikiFilesRegion contains=vikiExtendedLink,vikiFilesIndicators
syn region vikiFilesRegion matchgroup=vikiMacroDelim
            \ start=/^[[:blank:]]*#Files\>\(\\\n\|.\)\{-}<<\z(.*\)$/ 
            \ end=/^[[:blank:]]*\z1[[:blank:]]*$/ 
            \ contains=vikiFiles


syn region vikiTexFormula matchgroup=Comment
            \ start=/\z(\$\$\?\)/ end=/\z1/
            \ contains=@texmathMath
syn sync match vikiTexFormula grouphere NONE /^\s*$/

syn region vikiTexMacro matchgroup=vikiMacroDelim
            \ start=/{\(ltx\)\([^:{}]*:\)\?/ end=/}/ 
            \ transparent contains=vikiMacroNames,@texmath
syn region vikiTexMathMacro matchgroup=vikiMacroDelim
            \ start=/{\(math\>\|\$\)\([^:{}]*:\)\?/ end=/}/ 
            \ transparent contains=vikiMacroNames,@texmathMath
syn region vikiTexRegion matchgroup=vikiMacroDelim
            \ start=/^[[:blank:]]*#Ltx\>\(\\\n\|.\)\{-}<<\z(.*\)$/ 
            \ end=/^[[:blank:]]*\z1[[:blank:]]*$/ 
            \ contains=@texmathMath


syn match vikiList /^[[:blank:]]\+\%([-+*#?@]\|[0-9#]\+\.\|[a-zA-Z?]\.\)\ze[[:blank:]]/
syn match vikiDescription /^[[:blank:]]\+\%(\\\n\|.\)\{-1,}[[:blank:]]::\ze[[:blank:]]/ contains=@vikiHyperLinks,vikiEscapedChar,vikiComment

syn match vikiPriorityListTodo0 /#\%(T: \+.\{-}\u.\{-}:\|\d*\u\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syn match vikiPriorityListTodoA /#\%(T: \+.\{-}A.\{-}:\|\d*A\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syn match vikiPriorityListTodoB /#\%(T: \+.\{-}B.\{-}:\|\d*B\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syn match vikiPriorityListTodoC /#\%(T: \+.\{-}C.\{-}:\|\d*C\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syn match vikiPriorityListTodoD /#\%(T: \+.\{-}D.\{-}:\|\d*D\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syn match vikiPriorityListTodoE /#\%(T: \+.\{-}E.\{-}:\|\d*E\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syn match vikiPriorityListTodoF /#\%(T: \+.\{-}F.\{-}:\|\d*F\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress

syn cluster vikiPriorityListTodo contains=vikiPriorityListTodoA,vikiPriorityListTodoB,vikiPriorityListTodoC,vikiPriorityListTodoD,vikiPriorityListTodoE,vikiPriorityListTodoF,vikiPriorityListTodo0

let s:progress = '\%(_\|[0-9]\+%\|\d\{4}-\d\{2}-\d\{2}\%(\.\.\d\{4}-\d\{2}-\d\{2}\)\?\)'
exec 'syn match vikiProgress /\s\+'. s:progress .'/ contained containedin=vikiPriorityListTodoGen'

if has('conceal')
    syn match vikiTagPrefix /\s\zs:/ contained containedin=vikiTag conceal
    syn match vikiContactPrefix /\s\zs@/ contained containedin=vikiContact conceal
    syn match vikiTag /\%(\s\%(:\%(\d\{4}-\d\{2}-\d\{2}\|[^[:punct:][:space:]]\+\)\+\)\+\)\+/ contained containedin=vikiPriorityListTodoGen contains=vikiTagPrefix
    syn match vikiContact /\s@[^[:punct:][:space:]]\+/ contained containedin=vikiPriorityListTodoGen contains=vikiContactPrefix
else
    syn match vikiTag /\%(\s\+\%(:\%(\d\{4}-\d\{2}-\d\{2}\|[^[:punct:][:space:]]\+\)\+\)\+\)\+/ contained containedin=vikiPriorityListTodoGen
    syn match vikiContact /\s\+\zs@[^[:punct:][:space:]]\+/ contained containedin=vikiPriorityListTodoGen
endif

let s:plquant = tlib#var#Get('vikiIndentedPriorityLists', 'wbg') ? '\+' : '*'

exec 'syn match vikiPriorityListTodoGen /^[[:blank:]]'. s:plquant .'\zs#\%(T: \+.\{-}\u.\{-}:\|\d*\u\d*\%(\s\+'. s:progress .'\)\?\)\s.*$/ contains=vikiContact,vikiTag,@vikiPriorityListTodo,@vikiText'
exec 'syn match vikiPriorityListDoneGen /^[[:blank:]]'. s:plquant .'\zs#\%(T: \+x\%([0-9%-]\+\)\?.\{-}\u.\{-}:\|\%(T: \+\)\?\d*\u\d* \+x'. s:progress .'\?\):\? .*/'
exec 'syn match vikiPriorityListDoneX /^[[:blank:]]'. s:plquant .'\zs#[X-Z]\d\?\s.*/'

unlet s:plquant

syn cluster vikiPriorityListGen contains=vikiPriorityListTodoGen,vikiPriorityListDoneX,vikiPriorityListDoneGen

syntax sync minlines=2
" syntax sync maxlines=50
" syntax sync match vikiParaBreak /^\s*$/
" syntax sync linecont /\\$/


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists('did_viki_syntax_inits')
    if version < 508
        let did_viki_syntax_inits = 1
        " :nodoc:
        command! -nargs=+ HiLink hi link <args>
    else
        " :nodoc:
        command! -nargs=+ HiLink hi def link <args>
    endif

    if &background ==# 'light'
        let s:cm1 = 'Dark'
        let s:cm2 = 'Light'
    else
        let s:cm1 = 'Light'
        let s:cm2 = 'Dark'
    endif

    HiLink vikiSemiParagraph NonText
    HiLink vikiEscapedChars Normal
    exec 'hi vikiEscape ctermfg='. s:cm2 .'grey guifg='. s:cm2 .'grey'
    hi vikiList term=bold cterm=bold gui=italic,bold ctermfg=Cyan guifg=Cyan
    HiLink vikiDescription vikiList
    exec 'hi vikiHeading term=bold,underline cterm=bold gui=bold ctermfg='. s:cm1 .'Magenta guifg='.s:cm1.'Magenta'

    hi vikiHyperLink cterm=underline gui=underline
    hi def link vikiExtendedLink vikiHyperLink
    hi def link vikiExtendedLinkInfo vikiHyperLink
    hi def link vikiExtendedLinkMarkup vikiHyperLink

    let vikiPriorityListTodo = ' term=bold,underline cterm=bold gui=bold guifg=Black ctermfg=Black '
    exec 'hi vikiPriorityListTodo0'. vikiPriorityListTodo  .'ctermbg=LightRed guibg=LightRed'
    exec 'hi vikiPriorityListTodoA'. vikiPriorityListTodo  .'ctermbg=Red guibg=Red'
    exec 'hi vikiPriorityListTodoB'. vikiPriorityListTodo  .'ctermbg=Brown guibg=Orange'
    exec 'hi vikiPriorityListTodoC'. vikiPriorityListTodo  .'ctermbg=Yellow guibg=Yellow'
    exec 'hi vikiPriorityListTodoD'. vikiPriorityListTodo  .'ctermbg=LightMagenta guibg=LightMagenta'
    exec 'hi vikiPriorityListTodoE'. vikiPriorityListTodo  .'ctermbg=LightYellow guibg=LightYellow'
    exec 'hi vikiPriorityListTodoF'. vikiPriorityListTodo  .'ctermbg=LightGreen guibg=LightGreen'
    HiLink vikiContact Special
    HiLink vikiTag Title
    if has('conceal')
        HiLink vikiContactPrefix Special
        HiLink vikiTagPrefix Title
    endif
    HiLink vikiProgress WarningMsg

    HiLink vikiPriorityListDoneA Comment
    HiLink vikiPriorityListDoneB Comment
    HiLink vikiPriorityListDoneC Comment
    HiLink vikiPriorityListDoneD Comment
    HiLink vikiPriorityListDoneE Comment
    HiLink vikiPriorityListDoneF Comment
    HiLink vikiPriorityListDoneGen Comment
    HiLink vikiPriorityListDoneX Comment

    exec 'hi vikiTableRowSep term=bold cterm=bold gui=bold ctermbg='. s:cm2 .'Grey guibg='. s:cm2 .'Grey'

    exec 'hi vikiSymbols term=bold cterm=bold gui=bold ctermfg='. s:cm1 .'Red guifg='. s:cm1 .'Red'

    hi vikiMarkers term=bold cterm=bold gui=bold ctermfg=DarkRed guifg=DarkRed ctermbg=yellow guibg=yellow
    hi vikiAnchor term=italic cterm=italic gui=italic ctermfg=grey guifg=grey
    HiLink vikiComment Comment
    HiLink vikiString String

    hi vikiBold term=bold,underline cterm=bold,underline gui=bold
    exec 'hi vikiTypewriter term=underline ctermfg='. s:cm1 .'Grey guifg='. s:cm1 .'Grey'

    HiLink vikiMacroHead Statement
    HiLink vikiMacroDelim Identifier
    HiLink vikiSkeleton Special
    HiLink vikiCommand Statement
    HiLink vikiRegion Statement
    HiLink vikiRegionWEnd vikiRegion
    HiLink vikiRegionAlt vikiRegion
    HiLink vikiFilesRegion Statement
    HiLink vikiFiles Constant
    HiLink vikiFilesMarkers Ignore
    HiLink vikiFilesIndicators Directory
    HiLink vikiCommandNames Identifier
    HiLink vikiRegionNames Identifier
    HiLink vikiMacroNames Identifier

    HiLink vikiTexSup Type
    HiLink vikiTexSub Type
    HiLink vikiTexCommand Statement
    HiLink vikiTexText Normal
    HiLink vikiTexMathFont Type
    HiLink vikiTexMathWord Identifier
    HiLink vikiTexUnword Constant
    HiLink vikiTexPairs PreProc

    delcommand HiLink
endif

let b:current_syntax = 'viki'

