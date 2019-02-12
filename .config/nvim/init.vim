set encoding=utf-8
scriptencoding utf-8

" Disable Plugins
let g:pathogen_disabled = []
call add(g:pathogen_disabled, 'calendar.vim')
call add(g:pathogen_disabled, 'ctrlp.vim')
call add(g:pathogen_disabled, 'FastFold')
call add(g:pathogen_disabled, 'nerdtree')
"call add(g:pathogen_disabled, 'oceanic-next')
call add(g:pathogen_disabled, 'rust')
call add(g:pathogen_disabled, 'simplyfold')
" call add(g:pathogen_disabled, 'surround')
call add(g:pathogen_disabled, 'syntastic')
call add(g:pathogen_disabled, 'tagbar')
" call add(g:pathogen_disabled, 'vim-airline')
call add(g:pathogen_disabled, 'vim-airline-themes')
call add(g:pathogen_disabled, 'vim-colors-solarized')
call add(g:pathogen_disabled, 'vim-fugitive')
call add(g:pathogen_disabled, 'vim-instant-markdown')
call add(g:pathogen_disabled, 'VimRegexTutor')
call add(g:pathogen_disabled, 'vimux')
call add(g:pathogen_disabled, 'YouCompleteMe')

execute pathogen#infect()

" source specific settings
source ~/.config/nvim/rcsettings/search.vim
source ~/.config/nvim/rcsettings/navigation.vim
source ~/.config/nvim/rcsettings/appearance.vim

source ~/.config/nvim/rcsettings/python.vim
source ~/.config/nvim/rcsettings/c.vim
source ~/.config/nvim/rcsettings/cpp.vim
source ~/.config/nvim/rcsettings/tex.vim
source ~/.config/nvim/rcsettings/html.vim
source ~/.config/nvim/rcsettings/ocaml.vim
source ~/.config/nvim/rcsettings/rust.vim


set nocompatible
set encoding=utf-8
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

noremap ö 0
noremap ä $

" Enable folding
set foldmethod=indent
set foldlevel=99
" Enable folding with the spacebar
" nnoremap <space> za

" Automatic load of .vimrc
autocmd! bufwritepost .vimrc source %


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

" Calendar plugin
let g:calendar_first_day = "monday"
let g:calendar_date_endian = "little"
let g:calendar_time_zone = "+0200"
let g:calendar_date_separator= "."

" You Complete Me
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'

" Airline
" let g:airline_left_sep='>'
let g:airline_detect_modified=1
" let g:airline_powerline_fonts=1
let g:airline#extensions#syntastic#enabled = 1

" Syntastic
let g:syntastic_ocaml_checkers = ['merlin']
" let g:syntastic_asm_compiler = 'nasm'

" NERDTree
map <C-n> :NERDTreeToggle<CR>



set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key


" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

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
