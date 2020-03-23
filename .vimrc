syntax on
colorscheme koehler
set number
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
set mouse=n
function! FormatJSON()
:%!python -m json.tool
endfunction
