#!/usr/bin/env bash

if [[ -f /opt/homebrew/bin/brew ]]; then

    # Hombrew installation
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Homebrew keg-only packages
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
    export PATH="/opt/homebrew/opt/icu4c/bin:$PATH"
    export PATH="/opt/homebrew/opt/curl/bin:$PATH"

fi

# Custom bin locations
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/Development/bin:$PATH"
export PATH="$HOME/Documents/Software/Skripte/bin:$PATH"
export PATH="$HOME/Development/swarm/volumes/environment/bin:$PATH"

# Tool bin locations
export PATH="$HOME/.local/share/cargo/bin:$PATH"
export PATH="$HOME/.local/share/n/bin:$PATH"

export PATH="${GOPATH:-$HOME/go}/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
