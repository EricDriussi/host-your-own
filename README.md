# Host your stuff

> '*Easy to use*' Ansible script to set up a VPS in one go.
>
> Some manual assembly may be required.

Simple Ansible playbook that provides you with:

- A static website server.
- The same website mirrored to Tor.
- Basic ssh and firewall hardening.
- A [Nextcloud](https://nextcloud.com/) instance @ `cloud.domain`.
- A [Vaultwarden](https://github.com/dani-garcia/vaultwarden) instance @ `vault.domain`.
- A [SearxNG](https://github.com/searxng/searxng) instance @ `searx.domain`.
- A [Gitea](https://github.com/go-gitea/gitea) instance @ `git.domain`.
- Regular backups and updates for these services.
- Your dotfiles set up and ready to go (using GNU-Stow).
- Up to date [neovim](https://github.com/neovim/neovim) install (if nvim config is found in dotfiles).
- [Fail2ban](https://github.com/fail2ban/fail2ban) protection.
- HTTPS all the things.

## Pre-requisites

### A Debian based VPS

This should work with the cheapest most basic VPS you can find.

### DNS

You **need** a valid domain name and your DNS records should be properly set up.

This should include A and AAAA records for your root domain, as well as CNAME records for your subdomains (at least `cloud`, `vault`, `searx` and `git`).

## Config

Needed user data is gathered through the `.env.yml` file.

There are two ways to set up this file:

- Manually create it by renaming / copying `.env-sample.yml` and filling in the required information.
- Just run the following command. It will clone this repo, guide you through the setup process and give you an option to run the playbook directly.

```sh
wget https://raw.githubusercontent.com/EricDriussi/host-your-own/master/bootstrap.sh -O bootstrap.sh && bash bootstrap.sh
```

You can also change the default behavior (subdomains, remote username and more) in `inventory.yml`.

### A note on dotfiles

The script assumes your dotfiles are set up using GNU Stow, don't provide a URL if that's not your case.

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

By default, this script attempts to establish an ssh connection with the `root` user of the provided VPS, creates a remote user called `ansible` and **blocks** further `root` connections.

This is done to install all services as a non-root user for obvious reasons.

If you already have a fully-setup, password-less sudo and docker user that you would rather use, change the `username` and `create_remote_user` vars in `inventory.yml` accordingly.

## Post-install

### General

After the main playbook is done, you should find a Nextcloud, Gitea and SearxNG instances under their respective subdomains.

These should work as expected out of the box, there should be an **admin** account already setup for Nextcloud and Gitea.

Have a look around and make yourself at home!

### Vaultwarden

Public signups are disabled by default for Vaultwarden to improve security.

This means that you'll have to visit `vault.your.domain/admin` first, enter the `vaultwarden_password` defined in the`.env.yml` file, and manually allow your desired email address to sign up.

Much more info can be found [here](https://github.com/dani-garcia/vaultwarden/wiki/Configuration-overview).

### Website

You'll also find a lousy website under your root domain.

It is stored in `/home/ansible/website/` and you can modify it at any time using `scp`, or `rsync` to upload your static website, blog or whatever!

```sh
rsync -rtvzP --rsh=ssh [LOCAL-WEBSITE-DIR]/* ansible@[your.domain.com]:/home/ansible/website
```

Swap `your.domain.com` for your VPS's IP address if you are using Cloudflare.

## ❓ Why?

Having your own private spot on the internet shouldn't be a luxury.
