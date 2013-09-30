"set foldmethod=indent
set nocompatible
set bg=dark
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set wildmenu
set wildmode=list:longest,full

call pathogen#infect()
call pathogen#helptags()
"nmap <F8> :TagbarToggle<CR>
"nmap <F7> :NERDTreeToggle<CR>

"colorscheme cthulhian
"colorscheme elise
"colorscheme enzyme
"colorscheme fu
"colorscheme gentooish
"colorscheme getafe
colorscheme ingretu
"colorscheme inkpot
"colorscheme ir_black
"colorscheme leo
"colorscheme northsky

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Try the following if your GUI uses a dark background.
highlight ExtraWhitespace ctermbg=darkgreen guibg=white guibg=#FFD9D9
match ExtraWhitespace /\s\+$/

if exists('+colorcolumn')
    set colorcolumn=120
else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>199v.\+', -1)
endif

if has('gui_running')
    set guifont=Source\ Code\ Pro\ Medium\ 10
endif

if has("autocmd")
    filetype off
    filetype plugin indent off
    set runtimepath+=/usr/share/vim/addons
    filetype plugin indent on
    filetype on
endif

if has("syntax")
    syntax off
    syntax on
endif


