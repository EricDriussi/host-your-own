# Host your stuff

> Ansible script to set up your self-hosting VPS in one go.

Simple Ansible playbook that provides you with:

- A static website server (served through HTTP and TOR).
- A [Nextcloud](https://nextcloud.com/) instance @ `cloud.domain`.
- A [Vaultwarden](https://github.com/dani-garcia/vaultwarden) instance @ `vault.domain`.
- A [SearxNG](https://github.com/searxng/searxng) instance @ `searx.domain`.
- A [Gitea](https://github.com/go-gitea/gitea) instance @ `git.domain`.
- Regular unattended backups and updates for these services.
- HTTPS all the things.
- Regular unattended SSL certs renewal.
- Hardened NGINX reverse proxy.
- Hardened SSH setup.
- Firewall and [Fail2ban](https://github.com/fail2ban/fail2ban).
- Regular unattended system updates.
- [A bunch](./roles/custom/vars/main.yml) of useful CLI tools.
- Your dotfiles set up and ready to go (using GNU-Stow).
- Up to date [neovim](https://github.com/neovim/neovim) install (if nvim config is found in dotfiles).

## Requirements

### A Debian based VPS

You need a Debian based VPS, and root SSH access to it.

This should work with the cheapest most basic VPS you can find.

Tested with Debian Buster.

### Domain Name - DNS setup

You **need** a valid domain name and your DNS records should be properly set up.

This should include A and AAAA records for your root domain, as well as CNAME records for your subdomains (at least `cloud`, `vault`, `searx` and `git`).

## Config

### Required

Rename `.env-sample.yml` to `.env.yml` and fill in your data.

### Optional

More low level customization (specific internal ports to use, whether to create a sudo user or not, that user's expected name, where to store your backups, etc.) can be achieved by modifying the variables in `inventory.yml`.

## Run

To execute the playbook run:

```sh
ansible-playbook run.yml
```

You can use the `--tags` flag, to run only the selected roles (tags):

```sh
ansible-playbook run.yml --tags="harden,nextcloud,searx"
```

---

By default, this script attempts to establish an ssh connection with the `root` user of your VPS, creates a sudo user called `ansible`, **blocks** further `root` connections and performs the setup using this newly created user.

If root ssh connections are already disabled and/or you already have a fully-setup, password-less sudo and docker user that you would rather use, change the `username` and `create_remote_user` vars in `inventory.yml` accordingly.

## Post-install

### General

After the main playbook is done, you should find a Nextcloud, Gitea and SearxNG instances under their respective subdomains.

These should work as expected out of the box, there should be an **admin** account already setup for Nextcloud and Gitea.

Have a look around and make yourself at home!

### Vaultwarden

Public signups are disabled by default for Vaultwarden to improve security.

This means that you'll have to visit `vault.[your.domain.com]/admin` first, enter the `vaultwarden_password` defined in the`.env.yml` file, and manually allow your desired email address to sign up.

This behavior can be changed, much more info can be found [here](https://github.com/dani-garcia/vaultwarden/wiki/Configuration-overview).

### Website

You'll also find a lousy website under your root domain.

It is stored in `/home/ansible/website/` and you can modify it at any time using `scp`, or `rsync` to upload your static website, blog or whatever!

```sh
rsync --recursive --compress --partial --progress --times [LOCAL-WEBSITE-DIR]/* ansible@[your.domain.com]:/home/ansible/website
```

### Updates and Backups

System wise and individual service updates are done on a monthly basis.

Backups are done weekly and are stored by default under `/home/ansible/backups`. You can download them to you local machine with something like:

```sh
rsync --recursive --compress --partial --progress --times ansible@[your.domain.com]:/home/ansible/backups ~/Downloads/
```

## ❓ Why?

Having your own private spot on the internet shouldn't be a luxury.
