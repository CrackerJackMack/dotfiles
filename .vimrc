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

" Add the virtualenv's site-packages to vim path
"py << EOF
"import os
"import sys
"import vim
"if 'VIRTUAL_ENV' in os.environ:
"   project_base_dir = os.environ['VIRTUAL_ENV']
"   sys.path.insert(0, project_base_dir)
"   activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"   execfile(activate_this, dict(__file__=activate_this))
"EOF
:python << EOF
import os
import vim
virtualenv = os.environ.get('VIRTUAL_ENV')
if virtualenv:
    pypath = os.path.join(virtualenv, 'bin', 'python')
    vim.command("".join(["let g:syntastic_python_python_exe = '", pypath, "'"]))
    vim.command("".join(["let g:ycm_path_to_python_interpreter = '", pypath, "'"]))
    activate_this = os.path.join(virtualenv, 'bin', 'activate_this.py')
    if os.path.exists(activate_this):
        exec(compile(open(activate_this).read(), activate_this, 'exec'), {'__file__': activate_this})
EOF
