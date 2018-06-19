let g:neocomplete#disable_auto_complete = 0
let g:neocomplete#enable_at_startup=1

" use smart case
let g:neocomplete#enable_smart_case=1
let g:neocomplete#enable_camel_case=1

" fuzzy compl
let g:neocomplete#enebale_fuzzy_complation = 1

let g:neocomplete#sources#syntax#min_keyword_length=3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
let g:neocomplete#force_overwrite_completefunc=1

let g:marching_enable_neocomplete = 1
let g:neocomplete#force_omni_input_patterns.cpp =
    \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'

let g:neocomplete#sources#omni#input_patterns.python =
    \ '[^. *\t]\.\w*\|\h\w*'

let g:neocomplete#sources#omni#functions.go =
    \ 'gocomplete#Complete'

let g:neocomplete#sources#omni#input_patterns.php =
    \'\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'


noremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction

inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()

inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
