#!/usr/bin/env bash
set -o nounset
set -o errexit
set -o pipefail

if [ "$EUID" -eq 0 ]; then # is root user
    apt install -y pipx git openssh-client
else
    sudo apt install -y pipx git openssh-client
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

git checkout ci
~/.local/bin/ansible-playbook run.yml "$@"
