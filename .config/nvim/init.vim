set encoding=utf-8
scriptencoding utf-8


" Setup plugins
call plug#begin('~/.config/nvim/plugged')
"Plug 'mhartington/oceanic-next'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'neovimhaskell/haskell-vim'
Plug 'alx741/vim-hindent'
"Plug 'sirver/UltiSnips'
"Plug 'vim-airline/vim-airline-themes'
"Plug 'fatih/vim-go'
call plug#end()


" source specific settings
source ~/.config/nvim/rcsettings/search.vim
source ~/.config/nvim/rcsettings/navigation.vim
source ~/.config/nvim/rcsettings/appearance.vim

source ~/.config/nvim/rcsettings/python.vim
source ~/.config/nvim/rcsettings/c.vim
source ~/.config/nvim/rcsettings/cpp.vim
source ~/.config/nvim/rcsettings/go.vim
source ~/.config/nvim/rcsettings/tex.vim
source ~/.config/nvim/rcsettings/html.vim
source ~/.config/nvim/rcsettings/ocaml.vim
source ~/.config/nvim/rcsettings/rust.vim


set nocompatible
set autowrite
set backup
set undofile
set undolevels=10000
set clipboard=unnamed
set guicursor=
set undodir=~/.config/nvim/undofiles
set backupdir=~/.config/nvim/backupfiles

" save swap files in different dirs
set directory=/tmp

filetype plugin indent on

"let mapleader = "+"
"let localmapleader = ","
"map +o <Esc>mxea"<Esc>`mbi"<Esc>`x

set whichwrap=b,s

runtime! ftplugin/man.vim


" general
let mapleader = ","

noremap <space>q :nohl<CR>
noremap <space>w :nopc<CR>
noremap <space><C-]> <C-w><C-]><C-w>T

" for vimux
noremap <space>p :VimuxPromptCommand<CR>
noremap <space>r :VimuxRunLastCommand<CR>
noremap <space>c :VimuxCloseRunner<CR>
noremap <space>i :VimuxInterruptRunner<CR>

" for ycn
noremap <space>gg :YcmCompleter GoTo<CR>
noremap <space>gd :YcmShowDetailedDiagnostic<CR>
noremap <space>gI :YcmCompleter GoToInclude<CR>
noremap <space>gi :YcmCompleter GoToImplementation<CR>
noremap <space>gr :YcmCompleter GoToReference<CR>
noremap <space>gt :YcmCompleter GetType<CR>
noremap <space>gd :YcmCompleter GetDoc<CR>
noremap <space>gf :YcmCompleter FixIt<CR>

" general
cmap w!! w !sudo tee > /dev/null %
noremap ö 0
noremap ä $
noremap ü @:

" stay in visual mode when indenting
vnoremap < <gv
vnoremap > >gv

" Enable folding
set foldmethod=indent
set foldlevel=99
" Enable folding with the spacebar
" nnoremap <space> za

" Automatic load of .vimrc
autocmd! bufwritepost init.vim source %


" ------ FUNCTION KEYS -------

" Toggle paste mode (wenn aus inet kopieren)
set pastetoggle=<F2>

"paste date
nmap <F3> i<C-R>=strftime("%d-%m-%Y %a %H:%M %p")<CR><Esc>
imap <F3> <C-R>=strftime("%d-%m-%Y %a %H:%M %p")<CR>

"spellcheck F6 en F5 de
map <F6> :setlocal spell! spelllang=en_us<CR>
map <F5> :setlocal spell! spelllang=de_20<CR>

nmap <F8> :TagbarToggle<CR>

map <F11> ]



" ------ PLUGIN CONFIGURATIOON ------

" Git
autocmd Filetype gitcommit setlocal spell textwidth=72

" You Complete Me
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'

" Airline
" let g:airline_left_sep='>'
let g:airline_detect_modified=1
" let g:airline_powerline_fonts=1
let g:airline#extensions#syntastic#enabled = 1

" Syntastic
" let g:syntastic_ocaml_checkers = ['merlin']
" let g:syntastic_asm_compiler = 'nasm'

" NERDTree
map <C-n> :NERDTreeToggle<CR>

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"



"When writing a buffer (no delay).
"call neomake#configure#automake('w')
" When writing a buffer (no delay), and on normal mode changes (after 750ms).
"call neomake#configure#automake('nw', 750)
" When reading a buffer (after 1s), and when writing (no delay).
"call neomake#configure#automake('rw', 1000)
" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 1s; no delay when writing).
"call neomake#configure#automake('nrwi', 500)


set wildmenu            " display completion matches in a status line

set ttimeout            " time out for key codes
set ttimeoutlen=100     " wait up to 100ms after Esc for special key


map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>


" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

":w !sudo tee %

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" Put these in an autocmd group, so that you can revert them with:
" ":augroup vimStartup | au! | augroup END"
augroup vimStartup
au!

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).
autocmd BufReadPost *
\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
\ |   exe "normal! g`\""
\ | endif

augroup END


" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
\ | wincmd p | diffthis
endif
