# RATIU5 ansible-config

This is my main ansible script for setting up my environment. Works the same on MacOS, Linux, and Windows Subsystem for Linux.

## Prerequisits

Linux or MacOS. For Windows, you can use [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

Make sure you have the following installed on your system (they exist on most systems by default):

- [curl](https://curl.se/)
- [bash](https://www.gnu.org/software/bash/)

## Installation

Run the following to download the installation script on your system. It will download and install Homebrew if on MacOS or use `apt` if on Linux to install Ansible.

```bash
curl -fsSL https://raw.githubusercontent.com/RATIU5/ansible-config/main/install.sh | bash
```