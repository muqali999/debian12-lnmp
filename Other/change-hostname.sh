#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "==============================\n"
printf " Debian 12.x 64位 change hostname \n"
printf "  copyright: www.doitphp.com  \n"
printf "==============================\n"
printf "\n\n"

# 查看当前 hostname
current_hostname="$(hostname)"

echo "This Server Hostname：$current_hostname"
printf "\n"

read -p "Do you want to change hostname?[y/n]:" confirm

#当确定更改Hostname
if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
    read -r -p "Please enter new Hostname:" new_hostname

	if [ -z "$new_hostname" ]; then
      echo "Error: Hostname cannot be empty!"
      exit 1
    fi

	# 修改 hostname
	if hostnamectl set-hostname "$new_hostname"; then
		echo
		echo "Hostname changed successfully."
	else
		echo
		echo "Hostname modification failed."
		exit 1
	fi

	# 最后重新查看 hostname
	echo
	echo "The new Hostname：$(hostname)"
	echo "/etc/hostname Hostname：$(hostnamectl --static)"
fi