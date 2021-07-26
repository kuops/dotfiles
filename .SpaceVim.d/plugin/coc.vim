for extension in g:coc_extensions
  call SpaceVim#logger#info("installing [ " . extension . " ] coc extension")
  call coc#add_extension(extension)
endfor
