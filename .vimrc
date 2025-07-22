" ~/.vimrc - Base configuration for Vim

" Enable syntax highlighting
syntax on
colorscheme desert

" Set indentation to 4 spaces, use spaces instead of tabs
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

" Show line numbers and ruler
set number
set ruler

" Enable search enhancements
set hlsearch      " Highlight search results
set incsearch     " Show matches as you type
set ignorecase    " Case-insensitive search
set smartcase     " ...unless uppercase used

" Set UTF-8 encoding
set encoding=utf-8

" Show command being typed
set showcmd

" Enable command-line completion menu
set wildmenu

" Set background for dark terminals
set background=dark

" Allow backspace over everything in insert mode
set backspace=indent,eol,start

" Set a simple status line
set laststatus=2
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [LEN=%L]

" Enable mouse support (uncomment if you want)
" set mouse=a

" Set default clipboard to system clipboard (uncomment if you want)
" set clipboard=unnamedplus
