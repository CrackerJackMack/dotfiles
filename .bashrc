# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Add local/bin and .local/bin
export PATH=/usr/local/bin:~/.local/bin:$PATH

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export GOPATH=~/.go

if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
elif [ -e /usr/share/terminfo/g/gnome-256color ]; then
    export TERM='gnome-256color'
elif [ -e /usr/share/terminfo/x/xterm+256color ]; then
    export TERM='xterm-256color'
elif [ -e /usr/share/terminfo/78/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi

# Defining Colors Used
if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
      MAGENTA=$(tput setaf 9)
      ORANGE=$(tput setaf 172)
      GREEN=$(tput setaf 190)
      PURPLE=$(tput setaf 141)
      WHITE=$(tput setaf 255)
      BLACK=$(tput setaf 80)
    else
      MAGENTA=$(tput setaf 5)
      ORANGE=$(tput setaf 4)
      GREEN=$(tput setaf 2)
      PURPLE=$(tput setaf 1)
      WHITE=$(tput setaf 7)
      BLACK=$(tput setaf 0)
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    MAGENTA="\x1B[1;31m"
    ORANGE="\x1B[1;33m"
    GREEN="\x1B[1;32m"
    BLUE="\x1B[1;34m"
    PURPLE="\x1B[1;35m"
    WHITE="\x1B[1;37m"
    BOLD=""
    BLACK="\x1B[0;0m"
    RESET="\x1B[m"
fi

# Simple colors for functions
BORDER=$BOLD$WHITE
USERCOLOR=$ORANGE
RETOKCOLOR=$GREEN
RETNOKCOLOR=$BOLD$MAGENTA
HOSTCOLOR=$BLACK
PWDCOLOR=$BOLD$GREEN


# Set the virtualenvwrapper variables
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/devel

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups

# append to the history file, don't overwrite it
shopt -s histappend

# mac cases... ugh
bind "set completion-ignore-case on" 

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && export LESSOPEN="|lesspipe %s"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Enable virtualenvwrapper if available
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    . /usr/local/bin/virtualenvwrapper.sh
fi

SSH_ENV="$HOME/.ssh/env"

function start_agent {
    if [ -n "$SSH_AUTH_SOCK" ]; then
        # agent was forwarded, don't spawn
        return
    fi
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

if [ -x /usr/bin/virsh ]; then
    export VAGRANT_DEFAULT_PROVIDER=libvirt
fi

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo -e "${PURPLE}*${BORDER}"
}

function parse_git_branch {
    echo -ne "${ORANGE}"
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

function return_code() {
    echo -ne "$BORDER<"
    if [ $1 != "0" ]; then
        echo -ne "${RETNOKCOLOR}${1}"
    else
        echo -ne "${RETOKCOLOR}${1}"
    fi
    echo -ne "$BORDER>"
}

function gitignore() {
    if [ "$1" == "" ]; then
        echo "Usage: gitignore <language name>"
        echo ""
        echo "Downloads a handy pre-made gitignore file for a given language."
        echo "Full list available at https://github.com/github/gitignore."
        return 1
    fi
 
    if [ -f ./.gitignore -a "$2" != "a" ]; then
        echo ".gitignore already exists!" >&2
        return 1
    fi
 
    lang=$1
    base_url="https://raw.githubusercontent.com/github/gitignore/master"
    url="$base_url/$lang.gitignore"
 
    curl -fs $url >> .gitignore
 
    if [ $? -gt 0 ]; then
        echo "Could not fetch $url" >&2
        return 1
    fi
 
    echo "Fetched $url"
}

function get_virtualenv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo $(basename $VIRTUAL_ENV)
    else
        echo "no venv"
    fi
}

# export PS1="${BORDER}┌─[${USERCOLOR}\u${BORDER}]─[\$(return_code \$?)${BORDER}]──[${HOSTCOLOR}${HOSTNAME%%.*}${BORDER}]:${PWDCOLOR}\w${BORDER}\n${BORDER}└──(${GREEN}\$(get_virtualenv)${BORDER})>>\$(parse_git_branch)${RESET}${BORDER}$ ${RESET}"
# export PS1="${BORDER}[${USERCOLOR}\u${BORDER}]\$(return_code \$?)${BORDER}[${HOSTCOLOR}${HOSTNAME%%.*}${BORDER}]:${PWDCOLOR}\w${GREEN}\$(get_virtualenv)${BORDER})>>\$(parse_git_branch)${BORDER}$ "
PS1_USER="${USERCOLOR}\u${RESET}"
PS1_HOST="${HOSTCOLOR}${HOSTNAME%%.*}${RESET}"
SEP="${BOLD}${BORDER},${RESET}"
BOXIN="${BORDER}[${RESET}"
BOXOUT="${BORDER}]${RESET}"
VENV="${ORANGE}\$(get_virtualenv)${RESET}"
GIT="\$(parse_git_branch)${RESET}"
CWD="${PWDCOLOR}\w${RESET}"
export PS1="${BOXIN}${PS1_USER}${SEP}${PS1_HOST}${BOXOUT}\$(return_code \$?)${BOXIN}${VENV}${SEP}${GIT}${BOXOUT}${CWD}${RESET}\n\$ "
