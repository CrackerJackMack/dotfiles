# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

#Defining Colors Used
RED='\x1B[1;31m'
REDWARNING='\x1B[4;31m'
GREEN='\x1B[0;32m'
REALGREEN='\x1B[32;1m'
YELLOW='\x1B[1;33m'
ORANGE='\x1B[0;33m'
BLUE='\x1B[0;34m'
REALBLUE='\x1B[01;37m'
MAGENTA='\x1B[0;35m'
WHITE='\x1B[0m'
GREY='\x1B[1;30m'

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

export PATH=/usr/local/bin:~/.local/bin:$PATH

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/devel
source /usr/local/bin/virtualenvwrapper.sh

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && export LESSOPEN="|lesspipe %s"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

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

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo -e "${RED}*${WHITE}"
}

function parse_git_branch {
    echo -ne "[${ORANGE}"
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)]/"
}

function charge_percent() {
    if [ -d /proc/acpi/battery/BAT1 ]; then
        REM=`awk '/remaining capacity/ { print $3 }' /proc/acpi/battery/BAT1/state`
        LAST=`awk '/last full/ { print $4}' /proc/acpi/battery/BAT1/info`
        CHARGESTATE=`awk '/charging state/ { print $3 }' /proc/acpi/battery/BAT1/state`
        CHARGEPERCENT=`echo $REM $LAST | awk '{printf "%d", ($1/$2)*100'}`
        case "${CHARGESTATE}" in
           'charged')
           CHARGECOLOR="$GREEN+"
           ;;
           'charging')
           CHARGECOLOR="$YELLOW+"
           ;;
           'discharging')
           if [ "$CHARGEPERCENT" -le "30" ] ; then
             CHARGECOLOR="$REDWARNING-"
           else
             CHARGECOLOR="$YELLOW-"
           fi
           ;;
        esac
        echo -e "[${CHARGECOLOR}${CHARGEPERCENT}%${REALBLUE}]"
    fi
}

function free_space() {
    df -h . | awk 'NR==2{ print $4 }'
}

function return_code() {
    if [ $1 != "0" ]; then
        echo -e "${REDWARNING}${1}\x1B[0;0m${REALBLUE}"
    else
        echo -e "${REALGREEN}${1}${REALBLUE}"
    fi
}

function num_files() {
    /bin/ls -1 | /usr/bin/wc -l | sed 's: ::g'
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
    base_url="https://raw.github.com/github/gitignore/master"
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

#export PS1='\[\033[01;31m\]\u@\h\[\033[01;32m\] \W \[\033[00m\]$(parse_git_branch)$ '
export PS1="\[\e[01;37m\]┌─[\[\e[01;37m\u\e[01;37m\]]─[\$(return_code \$?)]─\$(charge_percent)─[\[\e[00;37m\]${HOSTNAME%%.*}\[\e[01;37m\]]:\w\[\e[01;37m\]\n\[\e[01;37m\]└──\[\e[01;37m\](\[\e[32;1m\]\$(get_virtualenv)\[\e[01;37m\])>>\[\e[0m\]\$(parse_git_branch)\[\e[0m\]$ "

