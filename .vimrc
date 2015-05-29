call pathogen#infect()
call pathogen#helptags()
nnoremap <F11> :TogglePudbBreakPoint<CR>
inoremap <F11> :TogglePudbBreakPoint<CR>
nmap <S-F11> :!pudb %<CR>
nmap <F10> :!python %<CR>

if has('gui_running')
    set guifont=Source\ Code\ Pro\ Medium\ 10
    set clipboard=unnamed
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


"colorscheme cthulhian
"colorscheme elise
"colorscheme enzyme
colorscheme fu
"colorscheme getafe
"colorscheme ingretu
"colorscheme inkpot
"colorscheme ir_black
"colorscheme leo
"colorscheme northsky
set nocompatible
set bg=dark
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set wildmenu
set wildmode=list:longest,full


set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set number

let mapleader = ','

autocmd Filetype yaml setlocal ts=2 sts=2 sw=2
autocmd Filetype sls setlocal ts=2 sts=2 sw=2
