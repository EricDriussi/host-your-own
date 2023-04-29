#!/bin/bash -uxe
#  _______   ______   ______  ________  ______  ________ _______   ______  _______
# |       \ /      \ /      \|        \/      \|        \       \ /      \|       \
# | ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\\▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓\\▓▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\ ▓▓▓▓▓▓▓\
# | ▓▓__/ ▓▓ ▓▓  | ▓▓ ▓▓  | ▓▓  | ▓▓  | ▓▓___\▓▓  | ▓▓  | ▓▓__| ▓▓ ▓▓__| ▓▓ ▓▓__/ ▓▓
# | ▓▓    ▓▓ ▓▓  | ▓▓ ▓▓  | ▓▓  | ▓▓   \▓▓    \   | ▓▓  | ▓▓    ▓▓ ▓▓    ▓▓ ▓▓    ▓▓
# | ▓▓▓▓▓▓▓\ ▓▓  | ▓▓ ▓▓  | ▓▓  | ▓▓   _\▓▓▓▓▓▓\  | ▓▓  | ▓▓▓▓▓▓▓\ ▓▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓
# | ▓▓__/ ▓▓ ▓▓__/ ▓▓ ▓▓__/ ▓▓  | ▓▓  |  \__| ▓▓  | ▓▓  | ▓▓  | ▓▓ ▓▓  | ▓▓ ▓▓
# | ▓▓    ▓▓\▓▓    ▓▓\▓▓    ▓▓  | ▓▓   \▓▓    ▓▓  | ▓▓  | ▓▓  | ▓▓ ▓▓  | ▓▓ ▓▓
#  \▓▓▓▓▓▓▓  \▓▓▓▓▓▓  \▓▓▓▓▓▓    \▓▓    \▓▓▓▓▓▓    \▓▓   \▓▓   \▓▓\▓▓   \▓▓\▓▓

# Discard stdin. Needed when running from an one-liner which includes a newline
read -N 999999 -t 0.001
# Quit on error
set -e
# Clone the repo
[ -d "${PWD}/HYO" ] || git clone https://github.com/EricDriussi/host-your-own.git "${PWD}"/HYO
cd HYO

# Don't overwrite .env.yml
if [ -f .env.yml ]; then
	echo
	echo ".env.yml is already created!"
	echo
	exit 1
fi

echo "If you prefer to fill in the .env.yml file manually,"
echo "press [Ctrl+C] to quit this script"

echo
cat <<"EOF"
.-. . .-..----..----.  .----..-. .---. .----.
| |/ \| || {_  | {}  }{ {__  | |{_   _}| {_  
|  .'.  || {__ | {}  }.-._} }| |  | |  | {__ 
`-'   `-'`----'`----' `----' `-'  `-'  `----'
EOF
echo
echo "Enter your domain name"
echo
echo "If the server is behind Cloudflare, you'll need to also add your server's IP to .env.yml"
echo
read -p "Domain name: " domain
echo "domain: \"${domain}\"" >>.env.yml

echo
echo "Enter your email"
echo "This is needed for HTTPS certs"
echo
read -p "Email address: " email
echo "email: \"${email}\"" >>.env.yml

echo
cat <<"EOF"
 .----. .----..-. .-.
{ {__  { {__  | {_} |
.-._} }.-._} }| { } |
`----' `----' `-' `-'
EOF
echo
echo "Use existing key for remote ansible user?"
echo
read -p "[y/N]: " ansible_use_existing_key
until [[ "$ansible_use_existing_key" =~ ^[yYnN]*$ ]]; do
	echo
	echo "$ansible_use_existing_key: invalid selection"
	read -p "[y/N]: " ansible_use_existing_key
done
if [[ "$ansible_use_existing_key" =~ ^[yY]$ ]]; then
	echo
	read -p "Enter your SSH public key: " ssh_key_pair
	echo "ssh_public_key: \"${ssh_key_pair}\"" >>.env.yml
	echo
else
	echo
	echo "-- Generating key pair --"
	echo "Your keys will be stored in ./ssh_keys/"
	echo
	mkdir -p ssh_keys
	ssh-keygen -b 4096 -t rsa -f ./ssh_keys/key -q -N ""
	ssh_public_key=$(cat ./ssh_keys/key.pub)
	echo "ssh_public_key: \"${ssh_public_key}\"" >>.env.yml
	echo
fi

echo
cat <<"EOF"
 .---. .-.    .----. .-. .-..----. 
/  ___}| |   /  {}  \| { } || {}  \
\     }| `--.\      /| {_} ||     /
 `---' `----' `----' `-----'`----' 
EOF
echo
echo "Enter your nextcloud username"
read -p "Username: " username
until [[ "$username" =~ ^[a-z0-9]*$ ]]; do
	echo
	echo "Invalid username"
	echo "Make sure the username only contains lowercase letters and numbers"
	read -p "Username: " username
done
echo "nextcloud_username: \"${username}\"" >>.env.yml

echo
echo "Enter your password"
echo
read -s -p "Password: " nextcloud_password
echo "nextcloud_password: \"${nextcloud_password}\"" >>.env.yml

echo
cat <<"EOF"
.-. .-.  .--.  .-. .-..-.  .---. 
| | | | / {} \ | { } || | {_   _}
\ \_/ //  /\  \| {_} || `--.| |  
 `---' `-'  `-'`-----'`----'`-'  
EOF
echo
echo "Public sign ups to your vault are turned off."
echo "Use the token to access the admin portal."
echo
vaultwarden_token=$(openssl rand -base64 48)
echo "vaultwarden_token: \"${vaultwarden_token}\"" >>.env.yml
echo "Your admin token $vaultwarden_token has been saved in .env.yml"

echo
cat <<"EOF"
.----.  .----.  .---. .----..-..-.   .----. .----.
| {}  \/  {}  \{_   _}| {_  | || |   | {_  { {__  
|     /\      /  | |  | |   | || `--.| {__ .-._} }
`----'  `----'   `-'  `-'   `-'`----'`----'`----' 
EOF
echo
read -p "Set up your dotfiles? [y/N]: " setup_dotfiles
until [[ "$setup_dotfiles" =~ ^[yYnN]*$ ]]; do
	echo
	echo "$setup_dotfiles: invalid selection."
	read -p "[y/N]: " setup_dotfiles
done

if [[ "$setup_dotfiles" =~ ^[yY]$ ]]; then
	echo
	echo "Enter your dotfiles repo git clone (SSH) url: "
	read -p "Dotfiles url: " dotfiles
	echo "dotfiles_repo: \"${dotfiles}\"" >>.env.yml
fi

echo
cat <<"EOF"
.----.  .----. .-. .-..----.
| {}  \/  {}  \|  `| || {_  
|     /\      /| |\  || {__ 
`----'  `----' `-' `-'`----'
EOF
echo
read -p "Would you like to run the playbook now? [y/N]: " launch_playbook
until [[ "$launch_playbook" =~ ^[yYnN]*$ ]]; do
	echo
	echo "$launch_playbook: invalid selection."
	read -p "[y/N]: " launch_playbook
done
if [[ "$launch_playbook" =~ ^[yY]$ ]]; then
	ansible-playbook init_remote_user.yml --ask-pass && ansible-playbook run.yml
else
	echo
	echo "You can run the playbook by executing the following commands"
	echo
	echo "ansible-playbook init_remote_user.yml --ask-pass"
	echo "ansible-playbook run.yml"
	echo
	echo "The init_remote_user.yml script is only needed on the first run"
	echo
	exit 0
fi
