function! Umlaute()
  silent %s/ä/\&auml;/gIe
  silent %s/Ä/\&Auml;/gIe
  silent %s/ö/\&ouml;/gIe
  silent %s/Ö/\&Ouml;/gIe
  silent %s/ü/\&uuml;/gIe
  silent %s/Ü/\&Uuml;/gIe
  silent %s/ß/\&szlig;/gIe
endfunction


autocmd FileType html nnoremap ,u :<C-U>call Umlaute()<CR>
autocmd FileType html nnoremap ,m :-1read $HOME/.vim/.skeleton.html<CR>3jwf>a
