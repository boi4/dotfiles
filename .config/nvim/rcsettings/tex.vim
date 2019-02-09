autocmd FileType tex nnoremap ,b i\begin{}<CR>\end{}<Esc>k$<C-v>joI
autocmd FileType tex nnoremap ,e :-1read $HOME/.vim/skeletons/eidi2.tex<CR>
autocmd FileType tex nnoremap ,g :-1read $HOME/.vim/skeletons/german_article.tex<CR>

autocmd FileType plaintex nnoremap ,b i\begin{}<CR>\end{}<Esc>k$<C-v>joI
autocmd FileType plaintex nnoremap ,e :-1read $HOME/.vim/skeletons/eidi2.tex<CR>
autocmd FileType plaintex nnoremap ,g :-1read $HOME/.vim/skeletons/german_article.tex<CR>
