#!/usr/bin/env bash
set -o nounset
set -o errexit
set -o pipefail

if command -v apt &>/dev/null; then
  install_cmd="apt install -y pipx git openssh-client"
elif command -v dnf &>/dev/null; then
  install_cmd="dnf install -y pipx git openssh-client"
elif command -v pacman &>/dev/null; then
  install_cmd="pacman --noconfirm -S python-pipx git openssh-client"
else
  echo "Unsupported package manager."
  exit 1
fi

if [ "$EUID" -eq 0 ]; then # is root user
  eval "$install_cmd"
else
  eval sudo "$install_cmd"
fi

pipx install --include-deps ansible

directory="./HYO"
mkdir -p "$directory"
if [ -d "$directory/.git" ]; then # if was already cloned
  cd "$directory" && git "$directory" pull
else
  # clone the repository preserving previous files (.env.yml from ci)
  git clone https://gitlab.com/ericdriussi/host-your-own.git /tmp/"$directory"
  cp -ir /tmp/"$directory"/.git "$directory"/.git
  cd "$directory" && git restore .
fi

~/.local/bin/ansible-playbook run.yml "$@"
