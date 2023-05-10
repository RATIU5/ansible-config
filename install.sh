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
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>"$ZDOTDIR/.zshrc"

  # Install ansible
  brew install ansible

elif [[ "$(uname)" == "Linux" ]]; then
  # Update package manager
  sudo apt-get update

  # Install ansible
  sudo apt-get install -y ansible
fi

# Create the .config/ansible directory
mkdir -p "$XDG_CONFIG_HOME/ansible"

# Move the existing ansible.cfg file to the new location (if it exists)
if [ -f "$HOME/.ansible.cfg" ]; then
  mv "$HOME/.ansible.cfg" "$XDG_CONFIG_HOME/ansible/ansible.cfg"
fi

# Add remote_tmp and local_tmp settings to the ansible.cfg file
echo '[defaults]' >> "$XDG_CONFIG_HOME/ansible/ansible.cfg"
echo 'remote_tmp = $XDG_CONFIG_HOME/ansible/tmp' >> "$XDG_CONFIG_HOME/ansible/ansible.cfg"
echo 'local_tmp = $XDG_CONFIG_HOME/ansible/tmp' >> "$XDG_CONFIG_HOME/ansible/ansible.cfg"

# Set the ANSIBLE_CONFIG environment variable in the .zshrc file
echo 'export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg"' >> "$ZDOTDIR/.zshenv"

# Run the Ansible playbook
ansible-pull -U "https://github.com/RATIU5/ansible-config.git"