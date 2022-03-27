# Host your stuff!
> '*Easy to use*' Ansible script to set up a VPS in one go.

Simple Ansible playbook that provides you with:

- A self-hosted website.
- An onion version of your website served to Tor.
- A [Nextcloud](https://nextcloud.com/) instance @ `cloud.domain`.
- A [Bitwarden](https://bitwarden.com/) instance @ `vault.domain`.
- HTTPS all the things.
- Possibly more stuff in the future.

## Pre-requisites

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

Your DNS records should be properly set up.
This includes your A (and AAAA if you want IPv6) records as well as you CAA records for your subdomains (at least `cloud` and `vault`).

## Config

User config is done through the `.env.yml` file.
Create it by renaming `.env-sample.yml` and filling in the correct information.

## Run

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
