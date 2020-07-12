"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File:         plugin/linearly.vim
" Author:       Jeet Sukumaran
"
" Copyright:    (C) 2020 Jeet Sukumaran
"
" License:      Permission is hereby granted, free of charge, to any person obtaining
"               a copy of this software and associated documentation files (the
"               "Software"), to deal in the Software without restriction, including
"               without limitation the rights to use, copy, modify, merge, publish,
"               distribute, sublicense, and/or sell copies of the Software, and to
"               permit persons to whom the Software is furnished to do so, subject to
"               the following conditions:
"
"               The above copyright notice and this permission notice shall be included
"               in all copies or substantial portions of the Software.
"
"               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"               OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"               MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"               IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"               CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"               TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"               SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Reload Guard {{{1
" ============================================================================
if exists("g:did_linearly_plugin") && g:did_linearly_plugin == 1
    finish
endif
let g:did_linearly_plugin = 1
" }}} 1

" Compatibility Guard {{{1
" ============================================================================
" avoid line continuation issues (see ':help user_41.txt')
let s:save_cpo = &cpo
set cpo&vim
" }}}1

" Operator Bindings {{{1
" ============================================================================
" Break lines on sentences.

" Used in some following
onoremap <SID>(underline) _

" <S-j> Join Lines Operator {{{2
" Like 'J' for join, but takes motions etc.)
func! s:_joinoperator(submode)
        '[,']join
endfunc
" override 'join with spaces' to take operator
nnoremap <silent> J :set operatorfunc=<SID>_joinoperator<CR>g@
onoremap <silent> J j
nmap <silent> JJ Jip
" }}}2

" <C-j> Split Sentences Out Into Separate Line Operator {{{2
silent! nmap <silent> <C-j> :<C-U>set opfunc=linearly#SplitIntoLinesBySentence<CR>g@
silent! xmap <silent> <C-j> :<C-U>call linearly#SplitIntoLinesBySentence("'<", "'>")<CR>
silent! nmap <expr> <C-j><C-j>  '<C-j>' . v:count1 . '<SID>(underline)'
" }}}2

" <M-j> Split Into Lines on Expression Operator {{{2
silent! nmap <silent> <M-j> :<C-U>set opfunc=linearly#SplitIntoLinesOnExpression<CR>g@
silent! xmap <silent> <M-j> :<C-U>call linearly#SplitIntoLinesOnExpression("'<", "'>")<CR>
silent! nmap <expr> <M-j><M-j>  '<M-j>' . v:count1 . '<SID>(underline)'
" 2}}}

"
" gJ Join Lines with Delimiter Operator {{{2

" func! s:_gjoinoperator(submode)
"         '[,']join!
" endfunc
" nnoremap <silent> gJ :set operatorfunc=<SID>_gjoinoperator<CR>g@

silent! nmap <silent> gJ :<C-U>set opfunc=linearly#JoinLinesWithExpression<CR>g@
silent! xmap <silent> gJ :<C-U>call linearly#JoinLinesWithExpression("'<", "'>")<CR>
silent! nmap gJJ  Jip
" }}}1

" Restore State {{{1
" ============================================================================
" restore options
let &cpo = s:save_cpo
" }}}1

