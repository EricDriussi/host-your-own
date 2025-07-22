# Host your stuff

> Ansible script to self-host a bunch of services on your VPS.

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
- [A bunch](./roles/custom/vars/main.yml) of useful CLI tools (add your own!).
- Your dotfiles set up and ready to go (assuming a [GNU-Stow setup](https://devintheshell.com/blog/stow/)).
- Up to date [neovim](https://github.com/neovim/neovim) install (if nvim config
is found in dotfiles).

## Requirements

### A Debian based VPS

The script requires a Debian based VPS. If you want this to work on other
distros, feel free to [open a MR](https://gitlab.com/ericdriussi/host-your-own/-/merge_requests/new).

Assuming it's for personal use, the cheapest most basic VPS you can find should
be enough.

### Root SSH access

Root key-based SSH access to the target machine should be set up on the machine
running this script.

Further root SSH connections will be blocked at the beginning of the execution,
a dedicated sudo user will be created and used for the (rest of the) setup.

This sudo user will use the same SSH keys (unless configured otherwise, read
the [env file](./.env-sample.yml) for more info).

### Domain Name - DNS setup

You **need** a valid domain name and a proper DNS setup for your root domain as
well as for (at least) the above-mentioned subdomains.

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

After the playbook is done, you should find the Nextcloud, Gitea, SearxNG
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

### Updates and Backups

Both the OS and the individual services are updated on a monthly basis.

Backups for the services are done weekly and are stored by default under `/home/[REMOTE_USER]/backups`.
You can download them to you local machine with something like:

```sh
rsync --recursive --compress --partial --progress --times --rsync-path="sudo rsync" [REMOTE_USER]@[your.domain.com]:~/backups local_backup_dir
```

## Why?

Having your private spot on the internet shouldn't be a luxury.
