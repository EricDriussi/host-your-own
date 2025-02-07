# Host your stuff

> Ansible script to self-host a bunch of services on your VPS in one go.

An Ansible playbook that sets up:

- Static website server (served through HTTP and Onion land).
- Open source, GDPR-compliant [analytics](https://github.com/umami-software/umami)
@ `umami.domain`.
- [Nextcloud](https://nextcloud.com/) instance @ `cloud.domain`.
- [Vaultwarden](https://github.com/dani-garcia/vaultwarden) instance @ `vault.domain`.
- [SearxNG](https://github.com/searxng/searxng) instance @ `searx.domain`.
- [Gitea](https://github.com/go-gitea/gitea) instance @ `git.domain`.
- Regular unattended backups and updates for these services.
- HTTPS all the things.
- Regular unattended SSL certs renewal.
- Hardened NGINX reverse proxy.
- Hardened SSH setup.
- Firewall and [Fail2ban](https://github.com/fail2ban/fail2ban).
- Regular unattended system updates.
- [A bunch](./roles/custom/vars/main.yml) of useful CLI tools.
- Your dotfiles set up and ready to go (using GNU-Stow).
- Up to date [neovim](https://github.com/neovim/neovim) install (if nvim config
is found in dotfiles).

## Requirements

### A Debian based VPS

The script requires a Debian based VPS.

The cheapest most basic VPS you can find should do.

### Root SSH access

The machine where this script is run should have root SSH access to the VPS.

Root SSH connections will be blocked as part of the setup and
a dedicated sudo user will be used for the setup.

### Domain Name - DNS setup

You **need** a valid domain name and your DNS records should be properly set up
for your root domain as well as for (at least) the above-mentioned subdomains.

## Run

1. Clone this repo
1. Copy `.env-sample.yml` to `.env.yml` and fill in your config
1. Run `./init.sh`

You can use the `--tags` flag to run only some of the roles:

```sh
./init.sh --tags="harden,nextcloud,searx"
```

You can check the available tags in the `run.yml` file.

## Post-setup

After the main playbook is done, you should find the Nextcloud, Gitea, SearxNG
and Umami instances under their respective subdomains.

There should be a custom admin account already setup for Nextcloud and Gitea,
as well as the default Umami admin user.

Have a look around and make yourself at home!

### Vaultwarden

Public signups are disabled by default for Vaultwarden to improve security.

You'll have to visit `vault.[your.domain.com]/admin` first, enter the
`vaultwarden_password` defined in your `.env.yml` file, and manually
allow your desired email address to sign up.

This behavior can be changed, and more info can be found [here](https://github.com/dani-garcia/vaultwarden/wiki/Configuration-overview).

### Website

You'll find a lousy website under your root domain.

It is stored in `/home/[REMOTE_USER]/website/` and you can modify it at any time
using `scp` or `rsync` to upload your static website, blog or whatever else.

```sh
rsync --recursive --compress --partial --progress --times local_website/* [REMOTE_USER]@[your.domain.com]:~/website
```

#### Analytics

The default docker-compose installation process provided
in the [Umami docs](https://umami.is/docs) is followed.

You can log in to `umami.domain` following the [official instructions](https://umami.is/docs/login).

In case you prefer something simpler, a lightly modified version of
[this](https://github.com/woodruffw/snippets/blob/master/vbnla/vbnla) script is
available in `/home/[REOMTE_USER]/analytics.rb`.
Run it as follows to extract useful information from your server:

```sh
sudo cat /var/log/nginx/acces.log | ~/analytics.rb
```

### Updates and Backups

Both the OS and the individual services are updated on a monthly basis.

Backups for the services are done weekly and are stored by default under `/home/[REMOTE_USER]/backups`.
You can download them to you local machine with something like:

```sh
rsync --recursive --compress --partial --progress --times --rsync-path="sudo rsync" [REMOTE_USER]@[your.domain.com]:~/backups local_backup_dir
```

## Why?

Having your private spot on the internet shouldn't be a luxury.
