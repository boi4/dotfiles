
"--------------- Go ----------------
" mainly copied from https://github.com/fatih/vim-go-tutorial
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 

let g:go_fmt_command = "goimports"

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>r  :GoRun<CR>
autocmd FileType go nmap <leader>t  :GoTest<CR>
autocmd FileType go nmap <leader>c  :GoCoverageToggle<CR>

