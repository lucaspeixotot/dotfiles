" Nerd tree configuration ------------------------------------------------------
map <leader>nd :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"

" MRU configuration ------------------------------------------------------------
map <leader>mru :MRU<CR>

" Lightline --------------------------------------------------------------------
let g:lightline = {
      \ 'colorscheme': 'palenight',
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
"autocmd FileType c,cpp,objc ClangFormatAutoEnable

" Toggle auto formatting:
map <Leader>C :ClangFormatAutoToggle<CR>


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

" fzf ------------------------------------------------------------------------
map <C-p> :Files<cr>


" doxygen ------------------------------------------------------------------------
let g:DoxygenToolkit_authorName="Lucas Peixoto (lucaspeixotoac@gmail.com)"
let g:DoxygenToolkit_licenseTag="My own license"

" palenight ------------------------------------------------------------------------
let g:palenight_terminal_italics=1

" vim-lsp ------------------------------------------------------------------------
if executable('clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
                    \ })
        autocmd FileType c setlocal omnifunc=lsp#complete
        autocmd FileType cpp setlocal omnifunc=lsp#complete
        autocmd FileType objc setlocal omnifunc=lsp#complete
        autocmd FileType objcpp setlocal omnifunc=lsp#complete
    augroup end
endif
