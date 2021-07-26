" install coc extensions
let g:coc_extensions = [
  \ 'coc-docker',
  \ 'coc-go',
  \ 'coc-sh',
  \ 'coc-jedi',
\]

let g:coc_preferences = {
  \ "go.testFlags": [
  \  "-v",
  \],
\}

function! before#coc#bootstrap()
endfunction
