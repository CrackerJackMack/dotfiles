"set foldmethod=indent
call pathogen#infect()
call pathogen#helptags()
"nmap <F8> :TagbarToggle<CR>
"nmap <F7> :NERDTreeToggle<CR>
nmap <F10> :!python %<CR>
nnoremap <F11> :TogglePudbBreakPoint<CR>
inoremap <F11> :TogglePudbBreakPoint<CR>
nmap <S-F11> :!pudb %<CR>


"colorscheme cthulhian
"colorscheme elise
"colorscheme enzyme
"colorscheme fu
colorscheme getafe
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

let g:ycm_autoclose_preview_window_after_insertion = 1
let mapleader = ','
let g:jedi#show_call_signatures = "1"
let g:jedi#use_tabs_not_buffers = "0"

