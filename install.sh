#!/bin/bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

is_mac() {
  [ "$(uname)" == "Darwin" ] && return 0 || return 1
}

file_exists() {
  [ -f "$1" ] && return 0 || return 1
}

ensure_file_exists() {
  if ! file_exists "$1"; then
    touch "$1"
  fi
}

install_brew() {
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
}

# Mac support only, beacuse :P
if ! is_mac; then
    echo "Unsupported operating system: $OS"
    exit 1
fi

if ! command_exists brew; then
    install_brew
    echo "Homebrew installed."
else
    echo "Homebrew already installed."
fi

if ! command_exists ansible; then
    brew install ansible
    echo "Ansible installed."
else 
    echo "Ansible already installed."
fi

ansible-pull -U "https://github.com/RATIU5/ansible-config.git" local.yml
