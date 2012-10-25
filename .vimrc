set foldmethod=indent
set nocompatible
set bg=light
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
filetype plugin on
filetype indent on

call pathogen#infect()
nmap <F8> :TagbarToggle<CR>
nmap <F7> :NERDTreeToggle<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Highlight >80 chars
highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
match OverLength '\%>79v.\+'

"match none
" Try the following if your GUI uses a dark background.
highlight ExtraWhitespace ctermbg=darkgreen guibg=white guibg=#FFD9D9
2match ExtraWhitespace /\s\+$/
