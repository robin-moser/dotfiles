#!/bin/bash

# change prompt
#   username (orange)
#   colon (white)
#   current dir (grey)
#   git branch (green)
#   privilege (grey, #/$)
export PS1="\
\[\033[38;5;166m\]\u\
\[\033[38;5;15m\]:\
\[\033[38;5;244m\]\W\
\[\e[32m\]\$(parse_git_branch) \
\[\033[38;5;244m\]\\$\[$(tput sgr0)\]\
\[\e[0m\] "

# cursor color
echo -ne "\e]12;#555\a"

# autostart tmux
[[ $TERM != "screen" ]] && tmux

# history search with arrow keys
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOA": history-search-backward'
bind '"\eOB": history-search-forward'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
shopt -s histappend

# set defaults
export EDITOR=/usr/bin/vim
export PAGER=less

# set history options
export HISTCONTROL=ignoreboth
export HISTSIZE=
export HISTFILESIZE=
export HISTTIMEFORMAT="[%F %T] "
export HISTFILE=$HOME/.bash_history
PROMPT_COMMAND='history -a'

# LESS set better options
export LESSCHARSET='utf-8'
export LESSOPEN='|/usr/bin/lesspipe %s 2>&-'
export LESS='-iR'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# nnn set options and hotkeys
export NNN_COLORS='6234'
export NNN_TRASH=1
export NNN_PLUG="\
f:openinfinder;\
r:renamer;\
o:organize;\
t:treeview;\
h:hexdump;\
e:-_vim \$nnn*;\
p:-_less \$nnn*;\
l:-_git log;\
s:-_git status"

# fzf set options
export FZF_DEFAULT_OPTS="--extended --ansi"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPS"
export FZF_DEFAULT_COMMAND="fd --type f --color always"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# set node version manager options
export NVM_DIR="$HOME/.nvm"

# set go options
GOROOT=/usr/local/go
GOPATH=~/go

# set default ls colors
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# init node version manager
if [ -s "$NVM_DIR/nvm.sh" ]; then
	\. "$NVM_DIR/nvm.sh"  # This loads nvm
fi

# init node version manager completion
if [ -s "$NVM_DIR/bash_completion" ]; then
	\. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# init fasd configs
eval "$(fasd --init auto)"

# init fuzzy finder
if [ -f ~/.fzf.bash ]; then
	source ~/.fzf.bash
fi

# source aliases and functions
if [ -f ~/.bash_aliases ]; then
	source ~/.bash_aliases
fi
