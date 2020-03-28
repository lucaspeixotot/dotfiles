call plug#begin('~/.config/nvim/plugged')

" Elegant status line
Plug 'itchyny/lightline.vim'

" Elegant buftab line
Plug 'ap/vim-buftabline'

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

" Clang
Plug 'rhysd/vim-clang-format'
Plug 'kana/vim-operator-user'

" Rainbow parenthesis
Plug 'luochen1990/rainbow'

" Ctags
Plug 'ludovicchabant/vim-gutentags'

" Vim polyglot
Plug 'sheerun/vim-polyglot'

" Onedark
Plug 'joshdick/onedark.vim'

" Doxygen
Plug 'vim-scripts/DoxygenToolkit.vim'

" Palenight
Plug 'drewtempelmeyer/palenight.vim'

" VIM lsp requirements
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()
