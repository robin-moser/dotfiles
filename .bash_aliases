#!/bin/bash

#  ---------------------------------------------------------------------------
#  Sections:
#  1.   custom aliases
#  2.   coreutils aliases
#  3.   custom functions
#  4.   file and archive management
#  5.   searching
#
#  bash_aliases by Robin Moser
#  ---------------------------------------------------------------------------

# -------------------------------
# 1.  CUSTOM ALIASES
# -------------------------------

alias startup='/home/moser/scripts/startup.sh'
alias shutdown='echo -e "\nAusgestempelt?\n";sleep 15;shutdown'
alias video='droidcam-cli 172.20.10.1 4747'
alias monitoring='remmina -c ~/.local/share/remmina/1556034188668.remmina'
alias dotconfig="/usr/bin/git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME"

# open programs
alias fn='nautilus --browser . &>/dev/null &'
alias br='google-chrome'
alias sb='subl .'
alias g='git'

# file managers and editors
alias vv='nnn -d'
alias v='f -e vim'

alias zz='selectpathtogo'
alias h='formhistory'
alias password='generatepassword'

alias copy='xclip -in -selection clipboard'
alias webui='git webui &>/dev/null &'
alias gh='git open 1>/dev/null'

# Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
alias alert='notify-send -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e "s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//")"'


# -----------------------------
# 2.  COREUTILS ALIASES
# -----------------------------

alias cp='cp -i'                            # Preferred 'cp' implementation
alias mv='mv -i'                            # Preferred 'mv' implementation
alias mkdir='mkdir -p'                      # Preferred 'mkdir' implementation

alias xargs='xargs -d "\n"'
alias diff='colordiff -W $(( $(tput cols) -2 ))'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ls='ls -phN --color=always'           # Slash after Dir, humanreadable, colorized
alias lk='ls -lSr'                          # Sort by size, biggest last.
alias lt='ls -ltr'                          # Sort by date, most recent last.

alias ll='ls -al --group-directories-first'
alias l='ls -l --group-directories-first'

alias lh='ls -ad .* --group-directories-first'
alias llh='ls -ald .* --group-directories-first'

alias llp='ll | less'                       #  Pipe through 'less'
alias llg="list_with_git_branch"            #

alias which='type -all'                     # which:        Find executables
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths

alias tree='tree -aC -I ".git"'             #  colored

alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels

# -------------------------------
# 3.  CUSTOM FUNCTIONS
# -------------------------------

# use fasd to select a path to go
selectpathtogo() {
    fasd_cd -d -i "$@"
    echo -e "\n\e[38;5;241m > $(pwd)\n"
}

# make new dir and jump inside
mcd() {
    mkdir -p "$1" && cd "$1"
}

# open git origin url in browser (alias in .gitconfig)
gitopenorigin() {
    git open "$1" &>/dev/null
}

generatepassword() {
    local password count chars char
    # if no value given, use default lengh 20
    count=${1:-20}
    password=$( < /dev/urandom tr -dc 'a-zA-Z0-9' | head -c "${1:-$count}");
    # add special chars
    for ((n=0; n<$(( RANDOM % ( count / 5 ) + 1 )); n++)); do
        char=$(chars='!?#-:.'; echo "${chars:$(( RANDOM % 6 )):1}");
        password=$(echo "$password" | sed "s/./$char/$(( (RANDOM % count) + 1 ))")
    done
    # print colored
    while read -n1 character; do
        case $character in
            [0-9])
                echo -n "$(tput setaf 4)${character}$(tput sgr0)" ;;
            [a-Z])
                echo -n "$(tput setaf 1)${character}$(tput sgr0)" ;;
            *)
                echo -n "$(tput setaf 2)${character}$(tput sgr0)" ;;
        esac;
    done < <(echo -n "$password");
    # copy to clipboard
    echo "$password" | copy
    echo
}

# Get Git Branch for PS1
parse_git_branch() {
    git branch 2> /dev/null\
        | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' \
        | sed -e 's/(master)/ʍ/' \
        | sed -e 's/(develop)/ᴅ/'
}

list_with_git_branch() {
    paste <(ls -ld --color=always {*,.[^.]*} 2> /dev/null) <(for i in $( ls -d {*,.[^.]*}); do if [ -d "$i"/.git ] ; then echo -e "\033[38;5;240m ($(git --git-dir="$i/.git" branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'))\033[0m"; else echo; fi; done) | sed 's/[\t]*//g' | sed '/^\s*$/d'
}

formhistory() {
    history | awk '
    BEGIN {
    # FPAT = "([[:space:]]*[^[:space:]]+)";
    # OFS = "";
}
{
    $1 = "\033[2;33m" $1 "\033[0m";
    $2 = "\033[90m" $2 "\033[0m";
    $3 = "\033[90m" $3 "\033[0m";
    print
}
' | less -rn +G
}

# -------------------------------
# 4.  FILE AND ARCHIVE MANAGEMENT
# -------------------------------

alias make1mb='mkfile 1m ./1MB.dat'         # make1mb:      Creates a file of 1mb size (all zeros)
alias make5mb='mkfile 5m ./5MB.dat'         # make5mb:      Creates a file of 5mb size (all zeros)
alias make10mb='mkfile 10m ./10MB.dat'      # make10mb:     Creates a file of 10mb size (all zeros)
alias make1gb='mkfile 1g ./1GB.dat'         # make10mb:     Creates a file of 10mb size (all zeros)

# extract:  Extract most know archives with one command
extract () {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# ---------------------------
# 5.  SEARCHING
# ---------------------------

ff () { /usr/bin/find . -iname "$*" ; }          # ff:       Find file under the current directory
ffs () { /usr/bin/find . -iname "$*"'*' ; }      # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -iname '*'"$*" ; }      # ffe:      Find file whose name ends with a given string
ffc () { /usr/bin/find . -iname '*'"$*"'*' ; }   # ffc:      Find file whose name contains a given string
fft () { grep -rn . -e "$@" ; }                  # fft:      Find text in all files recursive
