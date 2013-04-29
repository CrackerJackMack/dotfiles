"set foldmethod=indent
set nocompatible
set bg=dark
colorscheme slate
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
filetype plugin on
filetype indent on
syntax on

set wildmenu
set wildmode=list:longest,full

call pathogen#infect()
nmap <F8> :TagbarToggle<CR>
nmap <F7> :NERDTreeToggle<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Try the following if your GUI uses a dark background.
highlight ExtraWhitespace ctermbg=darkgreen guibg=white guibg=#FFD9D9
match ExtraWhitespace /\s\+$/

if has('gui_running')
    set guifont=Source\ Code\ Pro\ Medium\ 10
endif
