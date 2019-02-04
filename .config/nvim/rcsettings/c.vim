"--------------- C ----------------

autocmd FileType c set expandtab
autocmd FileType c set shiftwidth=2
autocmd FileType c set softtabstop=2


autocmd FileType c nnoremap ,m :-1read $HOME/.vim/skeletons/m.c<CR>5j
autocmd FileType c nnoremap ,i <Esc>o#include <><Esc>i
