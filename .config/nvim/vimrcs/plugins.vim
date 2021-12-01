call plug#begin('~/.vim/plugged')


" ########## Visual ##########

" Elegant status line
Plug 'itchyny/lightline.vim'

" Rainbow parenthesis
Plug 'luochen1990/rainbow'


" ########## Colorschemes ##########

" Ayu 
Plug 'ayu-theme/ayu-vim' " or other package manager

" Palenight
Plug 'drewtempelmeyer/palenight.vim'

" Onedark
Plug 'joshdick/onedark.vim'

"" Material
"Plug 'kaicataldo/material.vim', { 'branch': 'main' }

" Seoul256
Plug 'junegunn/seoul256.vim'

" Nord
Plug 'arcticicestudio/nord-vim'

" Dracula
Plug 'dracula/vim', { 'as': 'dracula' }


" ########## C/C++ ##########

"" Ctags
"Plug 'ludovicchabant/vim-gutentags'

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
"Plug 'scrooloose/nerdtree'

" Open last files
Plug 'yegappan/mru'

" Git info
Plug 'tpope/vim-fugitive'

" Vim polyglot
Plug 'sheerun/vim-polyglot'

" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'

"" Deoplete
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Coc
" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Avy
Plug 'easymotion/vim-easymotion'

" Neosnippet
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

Plug 'josa42/vim-lightline-coc'

"Plug 'neovim/nvim-lspconfig'
"Plug 'hrsh7th/nvim-compe'

Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

call plug#end()
