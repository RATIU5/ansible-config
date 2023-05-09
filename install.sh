#!/bin/bash

# Set XDG_CONFIG_HOME and ZDOTDIR variables in .zshenv
mkdir -p ~/.config/zsh
echo 'export XDG_CONFIG_HOME="$HOME/.config"' >>~/.zshenv
echo 'export ZDOTDIR="$XDG_CONFIG_HOME/zsh"' >>~/.zshenv

if [[ "$(uname)" == "Darwin" ]]; then
  # Check if Homebrew is installed
  if ! command -v brew &>/dev/null; then
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    # Update Homebrew
    brew update
  fi

  # Add Homebrew shell environment to .zshrc
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>"$XDG_CONFIG_HOME/zsh/.zshrc"

  # Install ansible
  brew install ansible

elif [[ "$(uname)" == "Linux" ]]; then
  # Update package manager
  sudo apt-get update

  # Install ansible
  sudo apt-get install -y ansible
fi