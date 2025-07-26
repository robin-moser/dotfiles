# Personal Dotfiles

This repository contains my personal dotfiles and system configuration,
managed with [chezmoi](https://chezmoi.io/).

## Installation

### Prerequisites

**macOS:**
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Install Homebrew (https://brew.sh/)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required tools
brew install git gpg chezmoi bw coreutils util-linux grep gnu-sed findutils

# Init chezmoi repo
chezmoi init robin-moser
```

**Linux:**
```bash
# Install required packages
sudo apt update && apt install curl git gpg

# Install chezmoi
BINDIR=$HOME/.local/bin sh -c "$(curl -fsLS get.chezmoi.io)"
export PATH="$HOME/.local/bin:$PATH"

# Init chezmoi repo
chezmoi init robin-moser

# Set up bash environment to use the custom paths for Node
# No decryption required yet
chezmoi apply .bashrc .bash_profile .bash

# Reload shell to pick up custom paths
source ~/.bashrc

# Install Node via n-install
curl -fsSL https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install | bash -s -- -n

# Install Bitwarden CLI via npm
npm install -g @bitwarden/cli
```

### Initialize Dotfiles

```bash
# Bitwarden: set custom URL
bw config server https://pass.robinmoser.de

# Login to Bitwarden to store 2FA code
bw login robin@moser

# Now apply all remaining dotfiles, GPG keys and other configurations
chezmoi apply
```

### Install remaining tools

**macOS:**
```bash
# Install remaining tools via Homebrew
brew bundle --file=~/.brewfile
```

**Linux:**
```bash
# Install remaining tools via apt
sudo apt install -y \
    tmux fzf fd-find bat ripgrep yq tree colordiff \
    gdu viddy kubectl k9s gh coreutils pyenv zoxide

# Install Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz && rm nvim-linux-x86_64.tar.gz
```


## Mentioned Tools

### Core Development
- [Node.js](https://nodejs.org/) - JavaScript runtime
- [n](https://github.com/tj/n) - Node version manager (installed via npm)
- [Go](https://golang.org/dl/) - Go programming language
- [Rust](https://rustup.rs/) - Rust programming language and Cargo package manager
- [pyenv](https://github.com/pyenv/pyenv) - Python version manager

### Container & DevOps
- [Docker](https://docs.docker.com/get-docker/) - Containerization platform
- [kubectl](https://kubernetes.io/docs/tasks/tools/) - Kubernetes CLI
- [krew](https://krew.sigs.k8s.io/docs/user-guide/setup/install/) - kubectl plugin manager
- [k9s](https://k9scli.io/) - Kubernetes cluster management
- [GitHub CLI](https://cli.github.com/) - GitHub command line tool

### Terminal & Shell
- [Ghostty](https://ghostty.org/) - Terminal emulator
- [tmux](https://github.com/tmux/tmux) - Terminal multiplexer
- [tpm](https://github.com/tmux-plugins/tpm) - tmux plugin manager

### Editors & Development
- [Neovim](https://neovim.io/) - Text editor
- [opencode](https://opencode.ai/) - AI-powered coding assistant

### MacOs Applications
- [ActivityWatch](https://activitywatch.net/) - Time tracking
- [OrbStack](https://orbstack.dev/) - Docker Desktop alternative for macOS
