" viki.vim -- the viki syntax fileviki_viki#SetupBuffer
" @Author:      Tom Link (micathom AT gmail com?subject=vim)
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     30-Dez-2003.
" @Last Change: 2017-10-31.
" @Revision: 108.1113

if exists('b:current_syntax')
    finish
endif
scriptencoding utf-8

syntax spell toplevel

runtime syntax/texmath.vim

syntax match vikiSemiParagraph /^\s\+$/

syntax match vikiEscape /\\/ contained containedin=vikiEscapedChar
syntax match vikiEscapedChar /\\\_./ contains=vikiEscape,vikiChar

syntax match vikiAnchor /^\s*#\l.*/
syntax match vikiMarkers /\V\%(###\|???\|!!!\|+++\)/


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
                \ ['Circumflex', '^\%({}\)\?', '^'],
                \ ]
        exec 'syntax match vikiSymbol'. s:name .' /\V'. s:chars .'/ conceal cchar='. s:cchar
        call add(s:sym_cluster, 'vikiSymbol'. s:name)
    endfor
    syntax match vikiSymbolExtra /\V\%(&\%(#\d\+\|\w\+\);\)/
    exec 'syntax cluster vikiSymbols contains=vikiSymbolExtra,'. join(s:sym_cluster, ',')
    unlet! s:name s:chars s:cchar s:sym_cluster
else
    syntax match vikiSymbols /\V\%(--\|!=\|==\+\|~~\+\|<-\+>\|<=\+>\|<~\+>\|<-\+\|-\+>\|<=\+\|=\+>\|<~\+\|~\+>\|...\|&\%(#\d\+\|\w\+\);\)/
    syntax cluster vikiSymbols contains=vikiSymbols
endif

syntax match vikiLink /\C\(\<[A-Z0-9_]\+::\)\?\%(\<\u\l\+\(\u[[:lower:]0-9]\+\)\+\>\)\(#\l\w*\>\)\?/
if has('conceal')
    syntax region vikiExtendedLink matchgroup=vikiExtendedLinkMarkup start=/\[\[\%([^]]\+\]\[\)\?/ end=/\][!~*$\-]*\]/ concealends keepend
else
    syntax match vikiExtendedLink /\[\[.\{-}\][!~*$\-]*\]/
endif
syntax cluster vikiHyperLinks contains=vikiLink,vikiExtendedLink

if has('conceal')
    syntax region vikiBold matchgroup=NonText start=/\%(^\|\W\zs\)__\ze[^ 	_]/ end=/__\|\n\{2,}/ skip=/\\_\|\\\n/ contains=vikiEscapedChar,@Spell
                \ concealends
    syntax region vikiTypewriter matchgroup=NonText start=/\%(^\|[^\w`]\zs\)''\ze[^ 	']/ end=/''\|\n\{2,}/ skip=/\\'\|\\\n/ contains=vikiEscapedChar,@Spell
                \ concealends
else
    syntax region vikiBold start=/\%(^\|\W\zs\)__\ze[^ 	_]/ end=/__\|\n\{2,}/ skip=/\\_\|\\\n/ contains=vikiEscapedChar,@Spell
    syntax region vikiTypewriter start=/\%(^\|[^\w`]\zs\)''\ze[^ 	']/ end=/''\|\n\{2,}/ skip=/\\'\|\\\n/ contains=vikiEscapedChar,@Spell
endif
syntax cluster vikiTextstyles contains=vikiBold,vikiTypewriter,vikiEscapedChar

syntax cluster vikiText contains=@Spell,@vikiTextstyles,@vikiHyperLinks,vikiMarkers,@vikiSymbols

syntax match vikiComment /^\s*%.*$/ contains=@vikiHyperLinks,vikiMarkers,vikiEscapedChar

syntax match vikiString /\%(^\|[[:blank:]({\[]\)\zs"[^"]*"/ contains=@vikiText

syntax region vikiHeading start=/^\*\+\s\+/ end=/\n/ contains=@vikiText

syntax match vikiTableRowSep /||\?/ contained containedin=vikiTableRow,vikiTableHead
syntax region vikiTableHead start=/^\s*|| / skip=/\\\n/ end=/\%(^\| \)||\s*$/
            \ transparent keepend
syntax region vikiTableRow  start=/^\s*| / skip=/\\\n/ end=/\%(^\| \)|\s*$/
            \ transparent keepend

syntax keyword vikiCommandNames 
            \ #CAP #CAPTION #LANG #LANGUAGE #INC #INCLUDE #DOC #VAR #KEYWORDS #OPT 
            \ #PUT #CLIP #SET #GET #XARG #XVAL #ARG #VAL #BIB #TITLE #TI #AUTHOR 
            \ #AU #AUTHORNOTE #AN #DATE #IMG #IMAGE #FIG #FIGURE #MAKETITLE 
            \ #MAKEBIB #LIST #DEFLIST #REGISTER #DEFCOUNTER #COUNTER #TABLE #IDX 
            \ #AUTOIDX #NOIDX #DONTIDX #WITH #ABBREV #MODULE #MOD #LTX #INLATEX 
            \ #PAGE #NOP
            \ contained containedin=vikiCommand

syntax keyword vikiRegionNames
            \ #Doc #Var #Native #Ins #Write #Code #Inlatex #Ltx #Img #Image #Fig 
            \ #Figure #Footnote #Fn #Foreach #Table #Verbatim #Verb #Abstract 
            \ #Quote #Qu #R #Ruby #Clip #Put #Set #Header #Footer #Swallow #Skip 
            \ contained containedin=vikiMacroDelim,vikiRegion,vikiRegionWEnd,vikiRegionAlt

syntax keyword vikiMacroNames 
            \ {fn {cite {attr {attrib {date {doc {var {arg {val {xarg {xval {opt 
            \ {msg {clip {get {ins {native {ruby {ref {anchor {label {lab {nl {ltx 
            \ {math {$ {list {item {term {, {sub {^ {sup {super {% {stacked {: 
            \ {text {plain {\\ {em {emph {_ {code {verb {img {cmt {pagenumber 
            \ {pagenum {idx {let {counter 
            \ contained containedin=vikiMacro,vikiMacroDelim
" workaroud vim syntax }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

syntax match vikiSkeleton /{{\_.\{-}[^\\]}}/

syntax region vikiMacro matchgroup=vikiMacroDelim start=/{\W\?[^:{}]*:\?/ end=/}/ 
            \ transparent contains=@vikiText,vikiMacroNames,vikiMacro

syntax region vikiRegion matchgroup=vikiMacroDelim 
            \ start=/^\s*#\([A-Z]\([a-z][A-Za-z]*\)\?\>\|!!!\)\(\\\n\|.\)\{-}<<\z(.*\)$/ 
            \ end=/^\s*\z1\s*$/ 
            \ contains=@vikiText,vikiRegionNames
syntax region vikiRegionAlt matchgroup=vikiMacroDelim 
            \ start=/^\s*\z(=\{4,}\)\s*\([A-Z][a-z]*\>\|!!!\)\(\\\n\|.\)\{-}$/ 
            \ end=/^\s*\z1\(\s.*\)\?$/ 
            \ contains=@vikiText,vikiRegionNames

syntax match vikiCommand /^\C\s*#\%([A-Z]\{2,}\)\>\%(\\\n\|.\)*/
            \ contains=vikiCommandNames

syntax match vikiFilesIndicators /^\s*[`_+|\\-]\+\s/ contained containedin=vikiFiles
syntax match vikiFiles /^\%(\s*[`_+|\\-]\+\s\+\)\?\[\[.\{-}\]!\].*$/
            \ contained containedin=vikiFilesRegion contains=vikiExtendedLink,vikiFilesIndicators
syntax region vikiFilesRegion matchgroup=vikiMacroDelim
            \ start=/^\s*#Files\>\(\\\n\|.\)\{-}<<\z(.*\)$/ 
            \ end=/^\s*\z1\s*$/ 
            \ contains=vikiFiles


syntax region vikiTexFormula matchgroup=Comment
            \ start=/\z(\$\$\?\)/ end=/\z1/
            \ contains=@texmathMath
syntax sync match vikiTexFormula grouphere NONE /^\s*$/

syntax region vikiTexMacro matchgroup=vikiMacroDelim
            \ start=/{\(ltx\)\([^:{}]*:\)\?/ end=/}/ 
            \ transparent contains=vikiMacroNames,@texmath
syntax region vikiTexMathMacro matchgroup=vikiMacroDelim
            \ start=/{\(math\>\|\$\)\([^:{}]*:\)\?/ end=/}/ 
            \ transparent contains=vikiMacroNames,@texmathMath
syntax region vikiTexRegion matchgroup=vikiMacroDelim
            \ start=/^\s*#Ltx\>\(\\\n\|.\)\{-}<<\z(.*\)$/ 
            \ end=/^\s*\z1\s*$/ 
            \ contains=@texmathMath


syntax match vikiList /^\s\+\%([-+*#?@]\|[0-9#]\+\.\|[a-zA-Z?]\.\)\ze\s/
syntax match vikiDescription /^\s\+\%(\\\n\|.\)\{-1,}\s::\ze\s/ contains=@vikiHyperLinks,vikiEscapedChar,vikiComment

syntax match vikiPriorityListTodo0 /#\%(T: \+.\{-}\u.\{-}:\|\d*\u\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syntax match vikiPriorityListTodoA /#\%(T: \+.\{-}A.\{-}:\|\d*A\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syntax match vikiPriorityListTodoB /#\%(T: \+.\{-}B.\{-}:\|\d*B\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syntax match vikiPriorityListTodoC /#\%(T: \+.\{-}C.\{-}:\|\d*C\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syntax match vikiPriorityListTodoD /#\%(T: \+.\{-}D.\{-}:\|\d*D\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syntax match vikiPriorityListTodoE /#\%(T: \+.\{-}E.\{-}:\|\d*E\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress
syntax match vikiPriorityListTodoF /#\%(T: \+.\{-}F.\{-}:\|\d*F\d*\)/ contained containedin=vikiPriorityListTodoGen nextgroup=vikiProgress

syntax cluster vikiPriorityListTodo contains=vikiPriorityListTodoA,vikiPriorityListTodoB,vikiPriorityListTodoC,vikiPriorityListTodoD,vikiPriorityListTodoE,vikiPriorityListTodoF,vikiPriorityListTodo0

let s:progress = '\%(_\|[0-9]\+%\|\d\{4}-\d\{2}-\d\{2}\%(\.\.\d\{4}-\d\{2}-\d\{2}\)\?\)'
exec 'syntax match vikiProgress /\s\+'. s:progress .'/ contained containedin=vikiPriorityListTodoGen'

if has('conceal')
    syntax match vikiTagPrefix /\s\zs:/ contained containedin=vikiTag conceal
    syntax match vikiContactPrefix /\s\zs@/ contained containedin=vikiContact conceal
    syntax match vikiTag /\%(\s\%(:\%(\d\{4}-\d\{2}-\d\{2}\|[^[:punct:][:space:]]\+\)\+\)\+\)\+/ contained containedin=vikiPriorityListTodoGen contains=vikiTagPrefix
    syntax match vikiContact /\s@[^[:punct:][:space:]]\+/ contained containedin=vikiPriorityListTodoGen contains=vikiContactPrefix
else
    syntax match vikiTag /\%(\s\+\%(:\%(\d\{4}-\d\{2}-\d\{2}\|[^[:punct:][:space:]]\+\)\+\)\+\)\+/ contained containedin=vikiPriorityListTodoGen
    syntax match vikiContact /\s\+\zs@[^[:punct:][:space:]]\+/ contained containedin=vikiPriorityListTodoGen
endif

let s:plquant = tlib#var#Get('vikiIndentedPriorityLists', 'wbg') || g:vikibase#tasks_must_be_indented ? '\+' : '*'

exec 'syntax match vikiPriorityListTodoGen /^\s'. s:plquant .'\zs#\%(T: \+.\{-}\u.\{-}:\|\d*\u\d*\%(\s\+'. s:progress .'\)\?\)\s.*$/ contains=vikiContact,vikiTag,@vikiPriorityListTodo,@vikiText'
exec 'syntax match vikiPriorityListDoneGen /^\s'. s:plquant .'\zs#\%(T: \+x\%([0-9%-]\+\)\?.\{-}\u.\{-}:\|\%(T: \+\)\?\d*\u\d* \+x'. s:progress .'\?\):\? .*/'
exec 'syntax match vikiPriorityListDoneX /^\s'. s:plquant .'\zs#[X-Z]\d\?\s.*/'

unlet s:plquant

syntax cluster vikiPriorityListGen contains=vikiPriorityListTodoGen,vikiPriorityListDoneX,vikiPriorityListDoneGen

syntax sync minlines=2

if &background ==# 'light'
    let s:cm1 = 'Dark'
    let s:cm2 = 'Light'
else
    let s:cm1 = 'Light'
    let s:cm2 = 'Dark'
endif

hi def link vikiSemiParagraph NonText
hi def link vikiEscapedChars Normal
exec 'hi vikiEscape ctermfg='. s:cm2 .'grey guifg='. s:cm2 .'grey'
hi vikiList term=bold cterm=bold gui=italic,bold ctermfg=Cyan guifg=Cyan
hi def link vikiDescription vikiList
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
hi def link vikiContact Special
hi def link vikiTag Title
if has('conceal')
    hi def link vikiContactPrefix Special
    hi def link vikiTagPrefix Title
endif
hi def link vikiProgress WarningMsg

hi def link vikiPriorityListDoneA Comment
hi def link vikiPriorityListDoneB Comment
hi def link vikiPriorityListDoneC Comment
hi def link vikiPriorityListDoneD Comment
hi def link vikiPriorityListDoneE Comment
hi def link vikiPriorityListDoneF Comment
hi def link vikiPriorityListDoneGen Comment
hi def link vikiPriorityListDoneX Comment

exec 'hi vikiTableRowSep term=bold cterm=bold gui=bold ctermbg='. s:cm2 .'Grey guibg='. s:cm2 .'Grey'

exec 'hi vikiSymbols term=bold cterm=bold gui=bold ctermfg='. s:cm1 .'Red guifg='. s:cm1 .'Red'

hi vikiMarkers term=bold cterm=bold gui=bold ctermfg=DarkRed guifg=DarkRed ctermbg=yellow guibg=yellow
hi def link vikiAnchor NonText
hi def link vikiComment Comment
hi def link vikiString String

hi vikiBold term=bold,underline cterm=bold,underline gui=bold
exec 'hi vikiTypewriter term=underline ctermfg='. s:cm1 .'Grey guifg='. s:cm1 .'Grey'

hi def link vikiMacroHead Statement
hi def link vikiMacroDelim Identifier
hi def link vikiSkeleton Special
hi def link vikiCommand Statement
hi def link vikiRegion Statement
hi def link vikiRegionWEnd vikiRegion
hi def link vikiRegionAlt vikiRegion
hi def link vikiFilesRegion Statement
hi def link vikiFiles Constant
hi def link vikiFilesMarkers Ignore
hi def link vikiFilesIndicators Directory
hi def link vikiCommandNames Identifier
hi def link vikiRegionNames Identifier
hi def link vikiMacroNames Identifier

hi def link vikiTexSup Type
hi def link vikiTexSub Type
hi def link vikiTexCommand Statement
hi def link vikiTexText Normal
hi def link vikiTexMathFont Type
hi def link vikiTexMathWord Identifier
hi def link vikiTexUnword Constant
hi def link vikiTexPairs PreProc

let b:current_syntax = 'viki'

