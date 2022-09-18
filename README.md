# Host your stuff

> '*Easy to use*' Ansible script to set up a VPS in one go.
>
> Some manual assembly may be required.

Simple Ansible playbook that provides you with:

- A static website to upload whatever you want.
- That same website mirrored to Tor.
- Basic ssh and firewall hardening.
- A [Nextcloud](https://nextcloud.com/) instance @ `cloud.domain`.
- A [Vaultwarden](https://github.com/dani-garcia/vaultwarden) instance @ `vault.domain`.
- A [SearxNG](https://github.com/searxng/searxng) instance @ `searx.domain`.
- [Fail2ban](https://github.com/fail2ban/fail2ban) protection.
- [Bunkerweb](https://github.com/bunkerity/bunkerweb) protection.
- HTTPS all the things.
- Backup and update regularly all the things.
- Possibly more stuff in the future.

## 🔧 Pre-requisites

### A Debian based VPS

This should work with the cheapest most basic VPS you can find.

### DNS

You **need** a valid domain name and your DNS records should be properly set up.

This should include A and AAAA records for your root domain, as well as your subdomains (at least `cloud`, `vault` and `searx`).

## ⚙️ Config

User config of the desired output is done through the `.env.yml` file.

There are two ways to set up this file:

- Manually create it by renaming / copying `.env-sample.yml` and filling in the required information.
- Just run the following command. It will clone this repo, guide you through the setup process and give you an option to run the playbook directly.

```sh
wget https://raw.githubusercontent.com/EricDriussi/host-your-own/master/bootstrap.sh -O bootstrap.sh && bash bootstrap.sh
```

Further configuration can be achieved if needed by modifying the `inventory.yml` file.

## 🏃 Run

### First time run / User setup

<details>
  <summary>Click to expand</summary>
  The main playbook (<code>run.yml</code>) expects a fully setup, password-less sudo and docker user named <code>ansible</code> to be present in the remote machine.
  <br>
  This user should also have the required <code>ssh_public_key</code> in its <code>~/.ssh/authorized_keys</code> file.
  <br>
  <br>
  You can configure this on your own or run <code>ansible-playbook init_remote_user.yml --ask-pass</code>
  <br>
  Now you should be set up to run <code>ansible-playbook run.yml</code> and watch the magic happen!
  <br>
  <br>
  Please keep in mind that, after the main playbook is done, root connections to the server will be disabled to improve security.
  <br>
  Thus, the <code>init_remote_user.yml</code> script can really only be run once (and shouldn't be needed afterwards).
  <br>
</details>

---

### Subsequent runs

To run the playbook (assuming your `.env.yml` file is properly set up) use:

```sh
ansible-playbook run.yml
```

Optionally and for debugging purposes, you can use the `--tags` flag, to run only the selected roles (as described in the `run.yml` file):

```sh
ansible-playbook run.yml --tags="harden,nextcloud,searx"
```

## 🤔 Post-install

### General

After the main playbook is done, you should find a Nextcloud and SearXG instances under their respective subdomains.

These should work as expected out of the box.

Have a look around and make yourself at home!

### Vaultwarden

As explained in the `bootstrap.sh` script, public signups are disabled by default for Vaultwarden to improve security.

This means that you'll have to visit `vault.your.domain/admin` first, enter the `admin_token` defined in the`.env.yml` file, and manually allow your desired email address to sign up.

Much more info can be found [here](https://github.com/dani-garcia/vaultwarden/wiki/Configuration-overview).

### Website

You'll also find a lousy website under your root domain.

It is stored in `/home/ansible/website/` and you can modify it at any time using `scp`, or `rsync` to upload your static website, blog or whatever!

```sh
rsync -rtvzP --rsh=ssh [LOCAL-WEBSITE-DIR]/* ansible@[your.domain.com]:/home/ansible/website
```

## ❓ Why?

Having your own private spot on the internet shouldn't be a luxury.
