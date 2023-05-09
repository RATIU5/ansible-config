#!/bin/bash

# Set XDG_CONFIG_HOME and ZDOTDIR in .zshenv
mkdir -p $HOME/.config/zsh
echo 'export XDG_CONFIG_HOME="$HOME/.config"' >> $HOME/.zshenv
echo 'export ZDOTDIR="$XDG_CONFIG_HOME/zsh"' >> $HOME/.zshenv

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew shell environment to .zshrc
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.config/zsh/.zshrc

brew install ansible