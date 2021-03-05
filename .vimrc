syntax on
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

let g:python_highlight_all=1
set autoindent
set number
set ruler

set relativenumber

set laststatus=2
set backspace=indent,eol,start
set ignorecase

set hlsearch
set incsearch
set ignorecase

set mouse+=a

" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>

