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

# TODO.Test

# Discard stdin. Needed when running from an one-liner which includes a newline
#read -N 999999 -t 0.001
# Quit on error
set -e
# Clone the Ansible playbook
#[ -d "${PWD}/HYO" ] || git clone https://github.com/EricDriussi/host-your-own.git "${PWD}"/HYO
#cd HYO

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
echo "The domain name should already resolve to the IP address of your server"
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
# TODO.Implement SSH key generation
echo
echo "Would you like to use an existing SSH key?"
echo "Press 'n' if you want to generate a new SSH key pair"
echo
read -p "Use existing SSH key? [y/N]: " use_existing_ssh_keys
until [[ "$use_existing_ssh_keys" =~ ^[yYnN]*$ ]]; do
	echo
	echo "$use_existing_ssh_keys: invalid selection"
	read -p "[y/N]: " use_existing_ssh_keys
done

if [[ "$use_existing_ssh_keys" =~ ^[yY]$ ]]; then
	echo
	read -p "Please enter your SSH public key: " ssh_key_pair
	echo "ssh_public_key: \"${ssh_key_pair}\"" >>.env.yml
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
read -s -p "Password: " user_password
until [[ "${#user_password}" -lt 60 ]]; do
	echo
	echo "The password is too long"
	read -s -p "Password: " user_password
done
echo
read -s -p "Repeat password: " user_password2
echo
until [[ "$user_password" == "$user_password2" ]]; do
	echo
	echo "The passwords don't match"
	read -s -p "Password: " user_password
	echo
	read -s -p "Repeat password: " user_password2
done
echo "user_pwd: \"${user_password}\"" >>.env.yml

echo
cat <<"EOF"
.-. .-.  .--.  .-. .-..-.  .---. 
| | | | / {} \ | { } || | {_   _}
\ \_/ //  /\  \| {_} || `--.| |  
 `---' `-'  `-'`-----'`----'`-'  
EOF
echo
echo "By default, public sign up to your vault are turned off."
echo "This means that you'll have to give explicit login permission through the admin portal."
echo "To change this behavior add 'allow_signups: true' in .env.yml"
echo
echo "Would you like to use an existing admin token for your vault?"
echo "Press 'n' if you want to generate a new admin token"
echo
read -p "Use existing admin token? [y/N]: " use_existing_token
until [[ "$use_existing_token" =~ ^[yYnN]*$ ]]; do
	echo
	echo "$use_existing_token: invalid selection."
	read -p "[y/N]: " use_existing_token
done

if [[ "$use_existing_token" =~ ^[yY]$ ]]; then
	echo
	read -p "Please enter your admin token: " admin_token
else
	echo
	admin_token=$(openssl rand -base64 48)
	echo "Your admin token $(admin_token) has been saved in .env.yml"
fi
echo "admin_token: \"${admin_token}\"" >>.env.yml

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
	ansible-playbook init_remote_user.yml &
	ansible-playbook run.yml
else
	echo
	echo "You can run the playbook by executing the following commands"
	echo "ansible-playbook init_remote_user.yml"
	echo "ansible-playbook run.yml"
	echo
	echo "Skip the first command after the first run"
	exit
fi
