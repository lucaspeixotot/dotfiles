" #########################################################
" #
" Nerd tree configuration 
" #
" #########################################################
map <leader>nd :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"

" #########################################################
" #
" MRU configuration 
" #
" #########################################################
map <leader>mru :MRU<CR>

" #########################################################
" #
" Lightline 
" #
" #########################################################

"function! getUnicodeNumber() abort
    "let ret = printf("%d", winnr())
    "return ret
"endfunction

"function! GetUnicodeNumber(num) abort
    "let l:number = a:num
    "if l:number == "1"
        "return printf("①")
    "elseif l:number == "2"
        "return printf("②")
    "elseif l:number == "3"
        "return printf("③")
    "elseif l:number == 4
        "return printf("④")
    "elseif l:number == 5
        "return printf("⑤")
    "elseif l:number == 6
        "return printf("⑥")
    "elseif l:number == 7
        "return printf("⑦")
    "elseif l:number == 8
        "return printf("⑧")
    "elseif l:number == 9
        "return printf("⑨")
    "endif
    "return printf("Undefined")
"endfunction

"function! Strange(num) abort
    "if a:num == "1"
        "return 'uno'
    "elseif a:num == "2"
        "return 'dos'
    "endif
  "if a:num > "0" && a:num <= "20"
      "echo nr2char(char2nr('①') + (a:num - 1))
    "return nr2char(char2nr('①') + (a:num - 1))
  "else
    "return 'Failed'
  "endif
"endfunction

"function! GetUnicodeNumber(num) abort
    "echo a:num
    "if a:num == "1"
        "return printf("kkkkk %s", a:num)
    "else
        "return 'Failed'
    "endif
"endfunction


let g:lightline = {
            \ 'colorscheme': 'palenight',
            \ 'active': {
                \   'left': [ [ 'WindowNumber', 'mode', 'paste' ],
                \             [ 'readonly', 'filename', 'modified' ] ]
            \ },
            \ 'inactive': {
                    \ 'left': [['WindowNumber', 'mode', 'paste'],
                    \           ['readonly', 'filename', 'modified']]
            \},
            \ 'component': {
                \   'WindowNumber': '%{winnr()}'
            \ },
            \ 'component_type': {
                \   'WindowNumber': 'ok'
            \ }
      \ }

let s:palette = g:lightline#colorscheme#palenight#palette
let s:palette.inactive.left = s:palette.normal.left
unlet s:palette

" #########################################################
" #
" Clang 
" #
" #########################################################

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
map <Leader>C :ClangFormatAutoToggle<CR>


" #########################################################
" #
" rainbow 
" #
" #########################################################

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

" #########################################################
" #
" fzf 
" #
" #########################################################
map <C-p> :Files<cr>


" #########################################################
" #
" doxygen 
" #
" #########################################################
let g:DoxygenToolkit_authorName="Lucas Peixoto (lucaspeixotoac@gmail.com)"
let g:DoxygenToolkit_licenseTag="My own license"

" #########################################################
" #
" palenight 
" #
" #########################################################
let g:palenight_terminal_italics=1

" #########################################################
" #
" vim-lsp 
" #
" #########################################################
"if executable('clangd')
    "augroup lsp_clangd
        "autocmd!
        "autocmd User lsp_setup call lsp#register_server({
                    "\ 'name': 'clangd',
                    "\ 'cmd': {server_info->['clangd']},
                    "\ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
                    "\ })
        "autocmd FileType c setlocal omnifunc=lsp#complete
        "autocmd FileType cpp setlocal omnifunc=lsp#complete
        "autocmd FileType objc setlocal omnifunc=lsp#complete
        "autocmd FileType objcpp setlocal omnifunc=lsp#complete
    "augroup end
"endif

" Register ccls C++ lanuage server.
if executable('ccls')
   au User lsp_setup call lsp#register_server({
      \ 'name': 'ccls',
      \ 'cmd': {server_info->['ccls']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
      \ 'initialization_options': {},
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
      \ })
endif

" #########################################################
" #
" Asyncomplete
" #
" #########################################################
"set completeopt-=preview
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" #########################################################
" #
" Whichkey
" #
" #########################################################
set timeoutlen=300
nnoremap <silent> <leader>      :<c-u>WhichKey ','<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  '<Space>'<CR>

" #########################################################
" #
" Easymotion
" #
" #########################################################
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" Gif config
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

" #########################################################
" #
" Vim airline
" #
" #########################################################

"let g:airline_powerline_fonts = 1
"let g:airline_theme='bubblegum'
"let g:airline#extensions#wordcount#enabled = 0

"if !exists('g:airline_symbols')
    "let g:airline_symbols = {}
"endif

"" airline symbols
"let g:airline_left_sep = ''
"let g:airline_left_alt_sep = ''
"let g:airline_right_sep = ''
"let g:airline_right_alt_sep = ''
"let g:airline_symbols.branch = ''
"let g:airline_symbols.readonly = ''
"let g:airline_symbols.linenr = ''

"" Add window number to airline
"function! WindowNumber(...)
    "let builder = a:1
    "let context = a:2
    "call builder.add_section('airline_b', '%{tabpagewinnr(tabpagenr())}')
    "return 0
"endfunction
"call airline#add_statusline_func('WindowNumber')
"call airline#add_inactive_statusline_func('WindowNumber')


" #########################################################
" #
" Vim fzf
" #
" #########################################################
function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()

let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'
set rtp+=~/.fzf
map <leader>bf :Buffers<cr>
map <leader>fd :Files<cr>
map <leader>pf :ProjectFiles<cr>


" #########################################################
" #
" Vim gutentags
" #
" #########################################################

let g:gutentags_exclude = ['*.css', '*.html', '*.js', '*.json', '*.xml',
                            \ '*.phar', '*.ini', '*.rst', '*.md',
                            \ '*vendor/*/test*', '*vendor/*/Test*',
                            \ '*vendor/*/fixture*', '*vendor/*/Fixture*',
                            \ '*var/cache*', '*var/log*', '.ccls-cache/*']
let g:gutentags_file_list_command = 'rg --files'
