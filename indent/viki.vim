" @Author:      Tom Link (micathom AT gmail com?subject=vim)
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2017-03-31.
" @Revision:    272

if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal indentexpr=viki#indent#GetIndent()
setlocal indentkeys=0=#\ ,0=?\ ,0=<*>\ ,0=-\ ,0=+\ ,0=@\ ,=::\ ,!^F,o,O

