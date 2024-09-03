
"hide vim line numbers: 
set nornu
set nonu
let g:tidal_boot="BootTidal.hs"

" let vim have transparent background color
highlight Normal guibg=NONE ctermbg=NONE
highlight EndOfBuffer guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE
highlight StatusLine guibg=NONE ctermbg=NONE

" disable statusline
set laststatus=0
hi! link StatusLine Normal
hi! link StatusLineNC Normal
set statusline=%{repeat('─',winwidth('.'))}
set noruler

" hide tabs
set showtabline=0

" lua stuff
source init.lua
