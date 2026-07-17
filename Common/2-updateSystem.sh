#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "===============================\n"
printf " Debian 13.x apt update		   \n"
printf " copyright : www.doitphp.com   \n"
printf "===============================\n"
printf "\n\n"

apt clean all
apt -y update

apt upgrade
apt full-upgrade

apt autoremove
apt autoclean

#Operating System information
printf "\nSystem Version:"
lsb_release -a
cat /etc/debian_version

printf "============== The End. ==============\n"