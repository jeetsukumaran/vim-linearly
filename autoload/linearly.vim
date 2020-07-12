"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File:         autoload/linearly.vim
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

" Compatibility Guard {{{1
" ============================================================================
" avoid line continuation issues (see ':help user_41.txt')
let s:save_cpo = &cpo
set cpo&vim
" }}}1

" Script Variables {{{1
" ============================================================================
let g:punctuation_marks = '?!'
let s:punctuation_marks = g:punctuation_marks
" }}}1

" Functions {{{1
" ============================================================================

function! linearly#SplitIntoLinesBySentence(...) abort
    call s:split_text_into_lines(-1, a:000)
endfunction

function! linearly#SplitIntoLinesOnExpression(...)
    call s:split_text_into_lines(-2, a:000)
endfunction

function! linearly#JoinLinesWithExpression(...)
    call s:split_text_into_lines(2, a:000)
endfunction

function! s:split_text_into_lines(operationIndex, markers) abort
    " normal! m`
    if len(a:markers) == 2
        " visual mode
        let open_marker  = a:markers[0]
        let close_marker = a:markers[1]
    else
        " normal mode
        let open_marker  = "'["
        let close_marker = "']"
    endif
    if a:operationIndex < 0
        " splitting operation
        if a:operationIndex == -1
            " - From: https://github.com/Konfekt/vim-sentence-chopper
            " - Known Issue: does not work if sentence ends with a digit.
            let match_pattern = '\C\v(%(%([^[:digit:]IVX]|[\])''"])[.]|[' . s:punctuation_marks . ']))%(\s+|([\])''"]))'
            let replace_pattern = '\1\2\r'
        elseif a:operationIndex == -2
            let user_match_pattern = input('Expression on which to split: ')
            if char2nr(user_match_pattern) == 0 || empty(user_match_pattern)
                return
            end
            let match_pattern = '\(' . user_match_pattern  . '\)'
            let replace_pattern = '\1\r'
        endif
    else
        " joining operation
        if a:operationIndex == 2

            " blank lines squashed; side-effect: extra lines outside region
            " might be pulled in
            " let match_pattern = '\(\r\n\|\r\|\n\)\{1,}'

            " each blank line in region gets added separately
            let match_pattern = '\(\r\n\|\r\|\n\)\{1}'
            let replace_pattern = input('Join with: ')
            if char2nr(replace_pattern) == 0 || empty(replace_pattern)
                let replace_pattern = ""
            end
        endif
    end
    if a:operationIndex < 0
        exe open_marker . ',' . close_marker . 'join'
    end
    call s:process_text(match_pattern, replace_pattern, open_marker, close_marker)
    if a:operationIndex < 0
        call s:reformat_text(open_marker, close_marker)
        execute "normal! ']$"
    end
endfunction

function! s:process_text(match_pattern, replace_pattern, open_marker, close_marker)
    let open_marker = a:open_marker
    let close_marker = a:close_marker
    let match_pattern = a:match_pattern
    let replace_pattern = a:replace_pattern
    let subst_pattern =
                \ match_pattern
                \ . '/'
                \ . replace_pattern
    let gdefault = &gdefault
    set gdefault&
    exe 'silent keeppatterns' . open_marker . ',' . close_marker . 'substitute/' . subst_pattern . '/geI'
    let &gdefault = gdefault
endfunction

function! s:reformat_text(open_marker, close_marker)
    let equalprg = &l:equalprg
    let equalprg = ''
    exe 'silent keepjumps normal! ' . a:open_marker . '=' . a:close_marker
    let &l:equalprg = equalprg
endfunction

" }}}1

" Restore State {{{1
" ============================================================================
" restore options
let &cpo = s:save_cpo
" }}}1

