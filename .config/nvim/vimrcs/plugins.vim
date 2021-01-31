call plug#begin('~/.vim/plugged')


" ########## Visual ##########

" Elegant status line
Plug 'itchyny/lightline.vim'

" Elegant buftab line
Plug 'ap/vim-buftabline'

" Rainbow parenthesis
Plug 'luochen1990/rainbow'

" Palenight
Plug 'drewtempelmeyer/palenight.vim'

" Onedark
Plug 'joshdick/onedark.vim'

" ########## C/C++ ##########

" Ctags
Plug 'ludovicchabant/vim-gutentags'

" Clang
Plug 'rhysd/vim-clang-format'
Plug 'kana/vim-operator-user'

" Doxygen
Plug 'vim-scripts/DoxygenToolkit.vim'

" ########## Util ##########

" Vim go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" ########## Util ##########

" Smart Parens
Plug 'jiangmiao/auto-pairs'

" Smart commenter
Plug 'scrooloose/nerdcommenter'

" Smart surround substitution i.e '({
Plug 'tpope/vim-surround'

" Smart nerd tree
Plug 'scrooloose/nerdtree'

" Open last files
Plug 'yegappan/mru'

" Git info
Plug 'tpope/vim-fugitive'

" Vim polyglot
Plug 'sheerun/vim-polyglot'

" fzf
Plug 'junegunn/fzf.vim'

" Ale
Plug 'dense-analysis/ale'

" Deoplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Avy
Plug 'easymotion/vim-easymotion'


call plug#end()
