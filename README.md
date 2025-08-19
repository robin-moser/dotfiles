# Personal Dotfiles

This repository contains my personal dotfiles and system configuration,
managed with [chezmoi](https://chezmoi.io/).

## Installation

### Prerequisites

**macOS:**
```bash
# Install Homebrew (https://brew.sh/)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required tools
brew install bash git gpg chezmoi bitwarden-cli

# Add Homebrew to PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# Change default shell to homebrew bash
echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells
chsh -s "$(brew --prefix)/bin/bash"

# Init chezmoi repo
chezmoi init robin-moser
```

**Linux:**
```bash
# Install required packages
sudo apt update && sudo apt install curl git gpg gcc build-essential coreutils

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
bw login robin@moser && bw sync

# Now apply all remaining dotfiles, GPG keys and other configurations
chezmoi apply

```

### Install remaining tools

**macOS:**
```bash
# Install remaining tools via Homebrew
brew bundle --global install
```

**Linux:**
```bash
# Install remaining tools via apt
sudo apt install -y \
    tree colordiff zoxide dnsutils \
    fzf fd-find bat ripgrep jq yq gh \

# Install pyenv
curl -fsSL https://pyenv.run | bash

# Build tmux (extended-keys support since 3.6)
sudo apt install autoconf automake pkg-config libevent-dev \
    ncurses-dev build-essential bison pkg-config
git clone https://github.com/tmux/tmux ~/Development/repos/tmux
cd ~/Development/repos/tmux
sh autogen.sh
./configure && make
ln -s /home/robin/Development/repos/tmux/tmux ~/.local/bin/

# Install Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz && rm nvim-linux-x86_64.tar.gz

# Install xremap
rustup default  stable
cargo install xremap --features gnome
systemctl --user start xremap.service
systemctl --user enable xremap.service
```

### Initialize nvim

```bash
# Isnstall Neovim plugins using lockfile
nvim --headless "+Lazy! restore" +qa
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
