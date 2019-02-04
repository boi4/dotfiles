
"--------------- Cpp ----------------

autocmd FileType cpp set expandtab
autocmd FileType cpp set shiftwidth=2
autocmd FileType cpp set softtabstop=2


autocmd FileType cpp nnoremap ,m :-1read $HOME/.vim/skeletons/m.c<CR>5j
autocmd FileType cpp nnoremap ,i <Esc>o#include <><Esc>i
