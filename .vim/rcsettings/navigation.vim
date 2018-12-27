set conceallevel=0
set mouse=a

"Tag Jumping:
command! MakeTags !ctags -R .
"strg ] -> jump
"strg t -> jump back
"g strg ] -> all matches

"split navigations
nnoremap <C-K> :tabprevious<CR>
nnoremap <C-J> :tabnext<CR>
nnoremap <C-H> :tabprevious<CR>
nnoremap <C-L> :tabnext<CR>
