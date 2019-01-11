" Nerd tree configuration ------------------------------------------------------
map <leader>nd :NERDTreeToggle<CR>

" MRU configuration ------------------------------------------------------------
map <leader>mru :MRU<CR>

" Lightline --------------------------------------------------------------------
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

" Clang ------------------------------------------------------------------------

let g:clang_format#style_options = {
            \ "BasedOnStyle": "google",
            \ "IndentWidth": 4,
            \ "ColumnLimit": 100,
            \ "Language": "Cpp",
            \ "AlignConsecutiveAssignments": "true",
            \ "SpaceAfterCStyleCast": "true",
            \ "MaxEmptyLinesToKeep": 2,
            \ "IndentCaseLabels": "false",
            \ "AlignTrailingComments": "true",
            \ "AllowAllParametersOfDeclarationOnNextLine": "false",
            \ "AlignAfterOpenBracket": "true",
            \ "BreakBeforeBraces": "Linux",
            \ "AllowShortIfStatementsOnASingleLine": "false",
            \ "AllowShortLoopsOnASingleLine": "false",
            \ "AllowShortFunctionsOnASingleLine": "false",
            \ "BreakBeforeBinaryOperators": "NonAssignment",
            \ "AlwaysBreakBeforeMultilineStrings": "false",
            \ "IncludeBlocks": "Regroup",
            \ "SpaceBeforeAssignmentOperators": "true",
            \ "SpaceBeforeParens": "ControlStatements",
            \ "SpaceInEmptyParentheses": "false" }

" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc ClangFormatAutoEnable

" Toggle auto formatting:
map <Leader>C :ClangFormatAutoToggle<CR>


" Ctags ------------------------------------------------------------------------

let g:ctags_enable=0
map <Leader>ct :let g:ctags_enable = !ctags_enable<cr>

function CtagsOnSave()
    if g:ctags_enable == 1
        !ctags_handler.sh $PWD &<cr>
    endif
endfunction

autocmd BufWritePre *.c,*.h,*.cc,*.cpp call CtagsOnSave()
