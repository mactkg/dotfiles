" Reference:
" https://github.com/Shougo/shougo-s-github/blob/master/vim/rc/vimrc
"

if &compatible
  set nocompatible
endif

function! s:source_rc(path, ...) abort "{{{
  let use_global = get(a:000, 0, !has('vim_starting'))
  let abspath = resolve(expand('~/.config/nvim/rc/' . a:path))
  if !use_global
    execute 'source' fnameescape(abspath)
    return
  endif

  " substitute all 'set' to 'setglobal'
  let content = map(readfile(abspath),
        \ 'substitute(v:val, "^\\W*\\zsset\\ze\\W", "setglobal", "")')
  " create tempfile and source the tempfile
  let tempfile = tempname()
  try
    call writefile(content, tempfile)
    execute printf('source %s', fnameescape(tempfile))
  finally
    if filereadable(tempfile)
      call delete(tempfile)
    endif
  endtry
endfunction "}}}

call s:source_rc('dein.rc.vim')

" suffix
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Plugin
" template
autocmd BufNewFile *.pl 0r $HOME/.vim/template/perl-script.txt
autocmd BufNewFile *.pm 0r $HOME/.vim/template/perl-script.txt
autocmd BufRead *.psgi set filetype=perl
autocmd BufNewFile,BufRead *.pm      set filetype=perl
autocmd BufNewFile *.t  0r $HOME/.vim/template/perl-test.txt
autocmd BufNewFile,BufRead *.t      set filetype=perl

autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead, BufNewFile *.ino set filetype=arduino
autocmd bufnewfile,bufread *.scpt,*.applescript :setl filetype=applescript
au BufRead,BufNewFile *.jsx set filetype=javascript.jsx

call s:source_rc('basic.rc.vim')
call s:source_rc('view.rc.vim')
call s:source_rc('encoding.rc.vim')
