set encoding=utf-8
scriptencoding utf-8

" Enable Plugins
let g:pathogen_disabled = []
" call add(g:pathogen_disabled, 'nerdtree')
" call add(g:pathogen_disabled, 'vim-fugitive')
call add(g:pathogen_disabled, 'vim-colors-solarized')
" call add(g:pathogen_disabled, 'syntastic')
call add(g:pathogen_disabled, 'simplyfold')
call add(g:pathogen_disabled, 'FastFold')
call add(g:pathogen_disabled, 'oceanic-next')
call add(g:pathogen_disabled, 'VimRegexTutor')
call add(g:pathogen_disabled, 'vim-airline-themes')
""call add(g:pathogen_disabled, 'vim-instant-markdown')

execute pathogen#infect()

" source specific settings
source ~/.vim/rcsettings/search.vim
source ~/.vim/rcsettings/navigation.vim
source ~/.vim/rcsettings/appearance.vim
source ~/.vim/rcsettings/python.vim
source ~/.vim/rcsettings/c.vim
source ~/.vim/rcsettings/cpp.vim
source ~/.vim/rcsettings/tex.vim
source ~/.vim/rcsettings/html.vim
source ~/.vim/rcsettings/ocaml.vim
source ~/.vim/rcsettings/rust.vim
"  source ~/.vim/rcsettings/ranger.vim


set nocompatible
set encoding=utf-8
set autowrite
set undolevels=10000
set clipboard=unnamed
set cryptmethod=blowfish2

" save swap files in different dirs
set directory=~/.vim/tmp,/tmp

filetype plugin indent on

" extend %
packadd! matchit

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







" ------- Trash ------

" map <F12> :call ToggleList()<Cr>
" set listchars=tab:>-,trail:-
" function! ToggleList()
" 	if &list
" 		set nolist
" 	else
" 		set list
" 	endif
" endfunction


" Syntatic related
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0







" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=10000		" keep 200 lines of command line history
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

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  set backupdir=/home/fecht/.vim/backupfiles
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
    set undodir=/home/fecht/.vim/undofiles
  endif
endif




" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
" ## added by OPAM user-setup for vim / ocp-indent ## 7b29859686bb4f65b6631c3928115658 ## you can edit, but keep this line
if count(s:opam_available_tools,"ocp-indent") == 0
  source "/home/fecht/.opam/default/share/ocp-indent/vim/indent/ocaml.vim"
endif
" ## end of OPAM user-setup addition for vim / ocp-indent ## keep this line
