call plug#begin('~/.config/nvim/plugged')

" Elegant status line
Plug 'itchyny/lightline.vim'

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
"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/vim-lsp'
"Plug 'mattn/vim-lsp-settings'
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'

" Expand region
Plug 'terryma/vim-expand-region'

" Grepper
Plug 'mhinz/vim-grepper'

" Startfy
Plug 'mhinz/vim-startify'

" Vim which key
Plug 'liuchengxu/vim-which-key'
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

" Vim easymotion
Plug 'easymotion/vim-easymotion'

"" Vim choosewindow
"Plug 't9md/vim-choosewin'

"" Vim airline
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'

" Vim fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()
