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
git checkout ci

cd ./host-your-own

if [ "$1" == "ci" ]; then
    cat <<EOF >.env.yml
---
domain: "localhost"
email: "your@email.address"
nextcloud_username: "admin_user"
nextcloud_password: "admin_pwd"
gitea_username: "admin_user"
gitea_password: "admin_pwd"
vaultwarden_password: "admin_panel_pwd"
ssh_key: "~/.ssh/id_rsa"
dotfiles_repo: "https://github.com/ericdriussi/dotfiles.git"
EOF
    ~/.local/bin/ansible-playbook run.yml --connection=local
else
    ~/.local/bin/ansible-playbook run.yml
fi
