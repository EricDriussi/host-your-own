#!/usr/bin/env bash
set -o nounset
set -o errexit
set -o pipefail

if [ "$EUID" -eq 0 ]; then # is root user
    apt install -y pipx git
else
    sudo apt install -y pipx git
fi

pipx install --include-deps ansible

rm -rf ./host-your-own && git clone https://gitlab.com/ericdriussi/host-your-own.git ./host-your-own

cd ./host-your-own
~/.local/bin/ansible-playbook run.yml
