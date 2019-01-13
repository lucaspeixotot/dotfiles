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
function PrintCtags()
    echom g:ctags_enable
endfunction

function GenerateCtags()
    if g:ctags_enable == 0
        Disctags_handler.sh $PWD &
        let g:ctags_enable = !g:ctags_enable
    else
        !ctags_stop.sh
        let g:ctags_enable = !g:ctags_enable
    endif
endfunction

"map <Leader>ct :call GenerateCtags()<cr>
"map <Leader>pt :call PrintCtags()<cr>


"autocmd BufWritePre *.c,*.h,*.cc,*.cpp call CtagsOnSave()
"
" rainbow ------------------------------------------------------------------------

let g:rainbow_conf = {
	\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
	\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
	\	'operators': '_,_',
	\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
	\	'separately': {
	\		'*': {},
	\		'tex': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
	\		},
	\		'lisp': {
	\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
	\		},
	\		'vim': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
	\		},
	\		'html': {
	\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
	\		},
	\		'css': 0,
	\	}
	\}
let g:rainbow_active = 1
