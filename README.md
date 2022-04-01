# Host your stuff!
> '*Easy to use*' Ansible script to set up a VPS in one go.
> **This is only tested on Debian systems!**

Simple Ansible playbook that provides you with:

- A self-hosted website.
- An onion version of your website served to Tor.
- A [Nextcloud](https://nextcloud.com/) instance @ `cloud.domain`.
- A [Vaultwarden](https://github.com/dani-garcia/vaultwarden) instance @ `vault.domain`.
- HTTPS all the things.
- Possibly more stuff in the future.

## 🔧 Pre-requisites

For the script to work there are a couple of things that need to be taken care of.

### Basic SSH root setup

There needs to be a working ssh connection from your machine to the root user of your VPS.

This connection is expected to use your id_rsa key pair. As in:

```sh
ssh-copy-id -i ~/.ssh/id_rsa.pub root@[VPS-IP-ADDRESS]
```

### A website to serve

The playbook expects a website to serve under `/var/www/website/`.

Assuming a working SSH connection you can use `rsync` (assuming its installed on both machines) as such:

```sh
rsync -rtvzP --rsh=ssh [LOCAL-WEBSITE-DIR] --rsync-path="mkdir -p /var/www/website && rsync" root@[VPS-IP-ADDRESS]:/var/www/website
```

### Obvious stuff

Ports `80` and `443` need to be available.

You **need** a valid domain name and your DNS records should be properly set up.

This should include A and AAAA records for both `www` and non `www` versions of your domain, as well as your subdomains (at least `cloud` and `vault`).

## ⚙️ Config

User config is done through the `.env.yml` file.
Create it by renaming `.env-sample.yml` and filling in the correct information.

### ⚠️ Note on Vars

#### Ports 

The `internal_ports` vars are there in case you have other things taking up ports `81` and/or `82`.

If that's not the case there's no need to change them.

The `admin_token` is optional and should be set to the output of something like `openssl rand -base64 48` as recommended in the [documentation](https://github.com/dani-garcia/vaultwarden/wiki/Enabling-admin-page) for Vaultwarden.

**Keep in mind** that not setting it will leave you out of the admin panel.
If on top of this you leave the `signups` as `false`, you won't be able to access your vault at all!

## 🏃 Run

To run the whole playbook in one go, run:

```sh
ansible-playbook run.yml --extra-vars=@.env.yml
```

Optionally and in case you need to debug, use the `--tags` flag:

```sh
ansible-playbook run.yml --extra-vars=@.env.yml --tags="user,ssh,install"
```

## Why?

Having your own private spot on the internet shouldn't be a luxury.

Here's a step to make it more accessible.
