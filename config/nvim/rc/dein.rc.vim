let g:dein#enable_notification = 1
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" no dein.vim? download it
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif


call dein#begin(s:dein_dir,  [expand('<sfile>')]
      \ + split(glob('~/.config/nvim/rc/*.toml'), '\n'))

  " load toml file
  call dein#load_toml('~/.config/nvim/rc/dein.toml',      {'lazy': 0})
  call dein#load_toml('~/.config/nvim/rc/dein_lazy.toml', {'lazy': 1})
  if has('nvim')
    call dein#load_toml('~/.config/nvim/rc/deineo.toml', {})
    call dein#add('Shougo/deoplete.nvim')
    let g:deoplete#enable_at_startup = 1
  endif

  " If running this script on nvim and enabled deopelete,
  " disable neocomplete.vim because deoplete is a replacement of neocomplete
  " for neovim
  if dein#tap('deoplete.nvim') && has('nvim')
    call dein#disable('neocomplete.vim')
  endif

" ready!
call dein#end()
call dein#call_hook('source')


" install not installed package
if dein#check_install()
  call dein#install()
endif
