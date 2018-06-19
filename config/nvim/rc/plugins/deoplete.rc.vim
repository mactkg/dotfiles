let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.ruby =
    \ ['[^. *\t]\.\w*', '\h\w*::']

" from http://qiita.com/takezo/items/809d53ecd37c438bac9e
inoremap <expr><tab> pumvisible() ? "\<C-n>" :
        \ neosnippet#expandable_or_jumpable() ?
        \    "\<Plug>(neosnippet_expand_or_jump)" : "\<tab>"

" deoplete-clang
" let g:deoplete#sources#clang#libclang_path = '/usr/local/opt/llvm/lib/libclang.dylib'
let g:deoplete#sources#clang#libclang_path = '/usr/local/Cellar/llvm/3.8.1/lib/libclang.dylib'
let g:deoplete#sources#clang#clang_header = '/usr/local/opt/llvm/include/clang'
