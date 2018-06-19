let s:save_cpo = &cpo
set cpo&vim

autocmd BufNewFile,BufRead *.js  set tabstop=2 shiftwidth=2 expandtab

let &cpo = s:save_cpo
