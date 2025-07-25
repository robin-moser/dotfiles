# MacOS: ignore Deprication Warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# set defaults
export EDITOR=vim
export PAGER=less

# set the TTY for GPG signing passphrases
export GPG_TTY=$(tty)

# LESS: set better options
export LESSCHARSET='utf-8'
export LESSOPEN='|/usr/bin/lesspipe %s 2>&-'
export LESS='-iR --mouse'

# LESS: man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;34m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# fzf set options
export FZF_DEFAULT_OPTS="--extended --ansi \
    --height=100% --preview-window=right:50% \
    --bind=ctrl-n:preview-half-page-down,ctrl-i:preview-half-page-up,tab:toggle-out,btab:toggle-in \
    --color hl:10,hl+:10,info:11,pointer:11,prompt:8"

export FZF_DEFAULT_COMMAND="fd --type f --color always \
    --exclude node_modules --exclude __pycache__ --exclude venv"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# set install path for n (node version manager)
export N_PREFIX="$HOME/.local/share/n"

# set go options
export GOPATH=$HOME/.local/share/go

# set rust options
export RUSTUP_HOME=$HOME/.local/share/rustup
export CARGO_HOME=$HOME/.local/share/cargo

# set krew options (kubectl plugin manager)
export KREW_ROOT=$HOME/.local/share/krew
