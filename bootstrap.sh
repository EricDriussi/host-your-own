#!/bin/bash -uxe
# TODO.Add email, website path, vault admin token(automate??) and ask if vault signups

# Discard stdin. Needed when running from an one-liner which includes a newline
read -N 999999 -t 0.001

# Quit on error
set -e

# Clone the Ansible playbook
[ -d "$HOME/HYO" ] || git clone https://github.com/EricDriussi/host-your-own.git

cd $HOME/HYO
cp .env-sample.yml .env.yml

clear
echo "If you prefer to fill in the inventory.yml file manually,"
echo "press [Ctrl+C] to quit this script"
echo
echo "Enter your desired UNIX username"
read -p "Username: " username
until [[ "$username" =~ ^[a-z0-9]*$ ]]; do
	echo "Invalid username"
	echo "Make sure the username only contains lowercase letters and numbers"
	read -p "Username: " username
done

sed -i "s/nextcloud_username: .*/nextcloud_username: ${username}/g" $HOME/HYO/.env.yml

echo
echo "Enter your user password"
echo "This password will be used for Nextcloud login, administrative access and SSH login"
read -s -p "Password: " user_password
until [[ "${#user_password}" -lt 60 ]]; do
	echo
	echo "The password is too long"
	echo "OpenSSH does not support passwords longer than 72 characters"
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

sed -i "s/nextcloud_pwd: .*/nextcloud_pwd: ${user_password}/g" $HOME/HYO/.env.yml

echo
echo
echo "Enter your domain name"
echo "The domain name should already resolve to the IP address of your server"
echo
read -p "Domain name: " root_host
until [[ "$root_host" =~ ^[a-z0-9\.]*$ ]]; do
	echo "Invalid domain name"
	read -p "Domain name: " root_host
done

sed -i "s/domain: .*/domain: ${root_host}/g" $HOME/HYO/.env.yml

# TODO.Test
# TODO.Pending implementation
echo
echo "Would you like to use an existing SSH key?"
echo "Press 'n' if you want to generate a new SSH key pair"
echo
read -p "Use existing SSH key? [y/N]: " new_ssh_key_pair
until [[ "$new_ssh_key_pair" =~ ^[yYnN]*$ ]]; do
	echo "$new_ssh_key_pair: invalid selection."
	read -p "[y/N]: " new_ssh_key_pair
done
sed -i "s/enable_ssh_keygen: .*/enable_ssh_keygen: true/g" $HOME/HYO/.env.yml

if [[ "$new_ssh_key_pair" =~ ^[yY]$ ]]; then
	echo
	read -p "Please enter your SSH public key: " ssh_key_pair

	sed -i "s/# ssh_public_key: .*/ssh_public_key: ${ssh_key_pair}/g" $HOME/HYO/.env.yml || echo "Fixing sed error..." && echo "    ssh_public_key: ${ssh_key_pair}" >>$HOME/HYO/.env.yml
fi

echo
echo "Success!"
read -p "Would you like to run the playbook now? [y/N]: " launch_playbook
until [[ "$launch_playbook" =~ ^[yYnN]*$ ]]; do
	echo "$launch_playbook: invalid selection."
	read -p "[y/N]: " launch_playbook
done

if [[ "$launch_playbook" =~ ^[yY]$ ]]; then
	cd $HOME/HYO && ansible-playbook run.yml --extra-vars=@.env.yml
else
	echo "You can run the playbook by executing the following command"
	echo "cd ${HOME}/HYO && ansible-playbook run.yml --extra-vars=@.env.yml"
	exit
fi
