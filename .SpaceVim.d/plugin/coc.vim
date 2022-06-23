for extension in g:coc_extensions
  call SpaceVim#logger#info("installing [ " . extension . " ] coc extension")
  if dein#tap('coc.nvim')
    call coc#add_extension(extension)
  endif
endfor
