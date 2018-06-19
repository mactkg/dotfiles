syntax enable
filetype indent on
filetype plugin indent on

" let g:python3_host_prog = $PYENV_ROOT . '/versions/3.5.1/bin'
" let g:python_host_prog = $PYENV_ROOT . '/versions/2.7.11/bin'
let g:ruby_path = $HOME . '/.rbenv/shims'

" tab
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
set shiftround
set ambiwidth=double

" indent
set smartindent
set autoindent
set shiftround
let g:indentLine_color_term = 239

set backspace=2
set virtualedit=all

" search
set showmatch
set hlsearch
set ignorecase
set smartcase
set incsearch
set wrapscan
noremap <Esc><Esc> :nohlsearch<CR><Esc>

" command
set wildmode=longest:full,full
set wildmenu
set shellslash
set cinoptions+=:0,g0 " don't indent when I make a label
set hlsearch
set infercase

" backup / swap
set nowritebackup
set nobackup
set noswapfile

" format
set fileformats=unix,dos,mac
set ambiwidth=double

" keybind
noremap ; :
noremap : ;

" move
nnoremap <Tab> %
vnoremap <Tab> %

" shell
set sh=zsh
tnoremap <silent> <ESC> <C-\><C-n>
