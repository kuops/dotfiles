function! init#before() abort
  call before#coc#bootstrap()
endfunction

function! init#after() abort
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NonText guibg=NONE ctermbg=NONE
  highlight EndOfBuffer guibg=NONE ctermbg=NONE
  call after#coc#bootstrap()
endfunctio
