" Nerd tree configuration ------------------------------------------------------
noremap <leader>nd :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"

" MRU configuration ------------------------------------------------------------
noremap <leader>mru :MRU<CR>

" Fugitive ---------------------------------------------------------------------
" Fugitive Conflict Resolution
nnoremap <leader>gd :Gvdiff<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>

" Lightline --------------------------------------------------------------------
let i = 1
while i <= 9
    execute 'nnoremap <Leader>' . i . ' :' . i . 'wincmd w<CR>'
    let i = i + 1
endwhile

function! WindowNumber()
    let str=tabpagewinnr(tabpagenr())
    return str
endfunction

let g:lightline = {
    \ 'colorscheme': 'dracula',
      \ 'active': {
      \   'left': [ [ 'winnumber', 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \ },
      \ 'inactive': {
      \   'left': [ [ 'winnumber'], [ 'filename' ]
      \              ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'winnumber': 'WindowNumber'
      \ },
      \ }

let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_infos': 'lightline#ale#infos',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }

let g:lightline.component_type = {
      \     'linter_checking': 'right',
      \     'linter_infos': 'right',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'right',
      \ }

let g:lightline.active = {
      \   'right': [ [ 'lineinfo', 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \}


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
noremap <Leader>C :ClangFormatAutoToggle<CR>


" rainbow ------------------------------------------------------------------------

let g:rainbow_conf = {
    \	'guifgs': ['royalblue1', 'darkorange1', 'seagreen3', 'lightcyan3'],
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

" Search for files in current directory
noremap <leader>pf :Files<cr>

" Search for files by line in current directory
noremap <leader>ps :Ag<cr>

" Search for buffer
noremap <leader>bf :Buffers<cr>

function! s:ag_with_opts(arg, bang)
  let tokens  = split(a:arg)
  let ag_opts = join(filter(copy(tokens), 'v:val =~ "^-"'))
  let query   = join(filter(copy(tokens), 'v:val !~ "^-"'))
  call fzf#vim#ag(query, fzf#vim#with_preview(), a:bang)
endfunction

function! s:rg_with_opts(arg, bang)
  let tokens  = split(a:arg)
  let ag_opts = join(filter(copy(tokens), 'v:val =~ "^-"'))
  let query   = join(filter(copy(tokens), 'v:val !~ "^-"'))
  call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(query), 1, fzf#vim#with_preview(), a:bang)
endfunction

command! -nargs=* -bang Ag call s:ag_with_opts(<q-args>, <bang>0)
"command! -bang -nargs=* Rg call s:rg_with_opts(<q-args>, <bang>0)


" doxygen ------------------------------------------------------------------------
let g:DoxygenToolkit_authorName="Lucas Peixoto (lucaspeixotoac@gmail.com)"
let g:DoxygenToolkit_licenseTag="My own license"

" palenight ------------------------------------------------------------------------
let g:palenight_terminal_italics=1

" vim-go --------------------------------------------------
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_options = {
    \ 'golines': '-m 100 --base-formater goimports',
    \ }
let g:go_auto_type_info = 1
let g:go_doc_keywordprg_enabled = 0
let g:go_addtags_transform = 'snakecase'



" Ale ------------------------------------------------------------------
let g:ale_sign_error = '*'
let g:ale_sign_warning = '!'
let g:ale_completion_enabled = 0
let g:ale_close_preview_on_insert=1


" Deoplete-go ----------------------------------------------------------

"" Enable deoplete on startup
"let g:deoplete#enable_at_startup = 1

"call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })

"" deoplete
"inoremap <expr> <tab>   pumvisible() ? "\<c-n>" : "\<tab>"
"inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<tab>"
"inoremap <expr> <cr>    pumvisible() ? deoplete#close_popup() : "\<cr>"

" Easymotion -----------------------------------------------------------
"map  <Leader>f <Plug>(easymotion-bd-f)
"nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap <Leader>s <Plug>(easymotion-overwin-f2)

" Move to line
nmap <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>l <Plug>(easymotion-overwin-line)

" Ayu ------------------------------------------------------------------
"let ayucolor="light"  " for light version of theme
let ayucolor="dark" " for mirage version of theme
"let ayucolor="dark"   " for dark version of theme

" Material -----------------------------------------
"let g:material_terminal_italics = 1
"let g:material_theme_style = 'palenight-community'

colorscheme dracula

" neosnippet -----------------------------------------------------------

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Coc ------------------------------------------------------------------

" Code action on <leader>a
vmap <leader>a <Plug>(coc-codeaction-selected)<CR>
nmap <leader>a <Plug>(coc-codeaction-selected)<CR>

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Format action on <leader>f
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Goto definition
nmap <silent> gd <Plug>(coc-definition)
" Open definition in a split window
nmap <silent> gv :vsp<CR><Plug>(coc-definition)<C-W>L
" GoTo code navigation.
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
autocmd FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']


