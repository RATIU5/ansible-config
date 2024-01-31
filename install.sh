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

# Mac support only for now, beacuse :P
# Eveantually, I will add support for Linux
if ! is_mac; then
    echo "Unsupported operating system: $OS"
    exit 1
fi

if ! command_exists brew; then
    if ! command_exists curl; then
        echo "curl is required to install Homebrew. Please install curl."
        exit 1
    fi
    install_brew
    echo "Homebrew installed."
else
    echo "Homebrew already installed."
fi

if ! command_exists ansible; then
    export ANSIBLE_HOME=~/.config/.ansible
    brew install ansible
    echo "Ansible installed."
else 
    echo "Ansible already installed."
fi

echo ""

echo "Would you like me to install your ansible playbook for you? (y/n)"
read -r answer
if [ "$answer" != "y" ]; then
    echo ""
    echo "Got it. You can run the playbook manually with:"
    echo ""
    echo "ansible-pull -U "https://github.com/RATIU5/ansible-config.git" local.yml"
else
    echo ""
    echo "Running the ansible playbook. This may take a while..."
    ansible-pull -U "https://github.com/RATIU5/ansible-config.git" local.yml
fi