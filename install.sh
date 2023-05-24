#!/bin/bash

# Function to install zsh on macOS and common Linux distros
install_zsh() {
  if [ "$(uname)" == "Darwin" ]; then
    # zsh is installed by default on macOS
    # brew install zsh
    echo "zsh installed on macOS..."
  elif command -v apt &>/dev/null; then
    sudo apt install zsh
  elif command -v yum &>/dev/null; then
    sudo yum install zsh
  elif command -v pacman &>/dev/null; then
    sudo pacman -S zsh
  else
    echo "Unsupported package manager. Install zsh manually."
    exit 1
  fi

  if [ ! -f "$HOME/.zshenv" ]; then
      touch "$HOME/.zshenv"
  fi

  if [ ! -d "$HOME/.config" ]; then
    mkdir -p "$HOME/.config"
  fi

  echo 'export XDG_CONFIG_HOME="$HOME/.config"' >> "$HOME/.zshenv"
  echo 'export ZDOTDIR="$XDG_CONFIG_HOME/zsh"' >> "$HOME/.zshenv"
}

# Function to install brew on macOS or Linux
install_brew() {
    if ! command -v brew &>/dev/null; then
        echo "Installing brew..."

        # Install dependencies for Linux
        if [ "$(uname)" == "Linux" ]; then
            if command -v apt &>/dev/null; then
                apt update
                apt install -y build-essential procps curl file git
            elif command -v yum &>/dev/null; then
                yum -y groupinstall 'Development Tools'
                yum -y install procps-ng curl file git
            else
                echo "Unsupported package manager. Install dependencies manually."
                exit 1
            fi
        fi

        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Append brew path
        if [ "$(uname)" == "Darwin" ]; then
            # Check for .zshrc and create if they don't exist
            if [ ! -f "$ZDOTDIR/.zshrc" ]; then
                touch "$ZDOTDIR/.zshrc"
            fi
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> $ZDOTDIR/.zshrc
            source $ZDOTDIR/.zshrc
        else  # Assuming Linux
            # Check for .bashrc and create if they don't exist
            if [ ! -f "$HOME/.bashrc" ]; then
                touch "$HOME/.bashrc"
            fi
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            source ~/.bashrc
            brew install zsh

            if [ ! -f "$$ZDOTDIR/.zshrc" ]; then
                touch "$$ZDOTDIR/.zshrc"
            fi
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $ZDOTDIR/.zshrc
        fi
    else
        echo "Brew is already installed."
    fi
}

# Detect the operating system
OS="$(uname)"
if [ "$OS" == "Darwin" ] || [ "$OS" == "Linux" ]; then
    install_zsh
    install_brew
else
    echo "Unsupported operating system: $OS"
    exit 1
fi

# Install git on macOS
if [ "$OS" == "Darwin" ]; then
    brew install git
fi

# Install Ansible
brew install ansible

ansible-pull -U "https://github.com/RATIU5/ansible-config.git"



# # Set XDG_CONFIG_HOME and ZDOTDIR variables in .zshenv
# mkdir "~/.config"
# echo 'export XDG_CONFIG_HOME="~"' >>~/.zshenv
# echo 'export ZDOTDIR="$XDG_CONFIG_HOME"' >>~/.zshenv

# if [[ "$(uname)" == "Darwin" ]]; then
#   # Check if Homebrew is installed
#   if ! command -v brew &>/dev/null; then
#     # Install Homebrew
#     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#   else
#     # Update Homebrew
#     brew update
#   fi

#   echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
#   # Add Homebrew shell environment to .zshrc
#   echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>"~/.zshrc"
#   eval "$(/opt/homebrew/bin/brew shellenv)"

#   # Install ansible
#   brew install ansible

# elif [[ "$(uname)" == "Linux" ]]; then
#   # Update package manager
#   apt update

#   # Install git
#   apt install -y git

#   # Install ansible
#   DEBIAN_FRONTEND=noninteractive apt install -y ansible
# fi

# # Create the .config/ansible directory
# mkdir -p "$XDG_CONFIG_HOME/ansible"

# # Move the existing ansible.cfg file to the new location (if it exists)
# if [ -f "$HOME/.ansible.cfg" ]; then
#   mv "$HOME/.ansible.cfg" "$XDG_CONFIG_HOME/ansible/ansible.cfg"
# fi

# # Add remote_tmp and local_tmp settings to the ansible.cfg file
# echo '[defaults]' >> "$XDG_CONFIG_HOME/ansible/ansible.cfg"
# echo 'remote_tmp = $XDG_CONFIG_HOME/ansible/tmp' >> "$XDG_CONFIG_HOME/ansible/ansible.cfg"
# echo 'local_tmp = $XDG_CONFIG_HOME/ansible/tmp' >> "$XDG_CONFIG_HOME/ansible/ansible.cfg"

# echo "Please wait. This may take several minutes..."

# # Run the Ansible playbook
# ansible-pull -U "https://github.com/RATIU5/ansible-config.git"