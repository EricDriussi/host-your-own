#!/usr/bin/env bash
set -o nounset
set -o errexit
set -o pipefail

if command -v apt &>/dev/null; then
  install_pipx="apt install -y pipx"
elif command -v dnf &>/dev/null; then
  install_pipx="dnf install -y pipx"
elif command -v pacman &>/dev/null; then
  install_pipx="pacman --noconfirm -S python-pipx"
elif command -v brew &>/dev/null; then
  install_pipx="brew install pipx"
else
  echo "Unsupported package manager."
  exit 1
fi

if
  [ "$EUID" -eq 0 ] || [ -n "$(command -v brew)" ]
then # is root user (ci) or brew used
  eval "$install_pipx"
else
  eval sudo "$install_pipx"
fi

pipx install --include-deps ansible
~/.local/bin/ansible-playbook run.yml "$@"
