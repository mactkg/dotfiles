syntax enable
filetype indent on
filetype plugin indent on

if isdirectory("/opt/homebrew/bin")
  let g:python3_host_prog = '/opt/homebrew/bin/python3'
else
  let g:python3_host_prog = '/usr/local/bin/python3'
endif

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

" display
set wrap
set display=lastline

set backspace=2
set virtualedit=all

" search
set showmatch
set matchtime=1
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

" filetype
autocmd BufRead,BufNewFile Fastfile setfiletype ruby

" help
set helplang=ja,en
