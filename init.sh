#!/usr/bin/env bash
set -o nounset
set -o errexit
set -o pipefail

rm -rf ./host-your-own && git clone git@gitlab.com:ericdriussi/host-your-own.git ./host-your-own

if [ "$EUID" -eq 0 ]; then # is root user
    apt install -y pipx
else
    sudo apt install -y pipx
fi

pipx install --include-deps ansible

cd ./host-your-own
~/.local/bin/ansible-playbook run.yml
