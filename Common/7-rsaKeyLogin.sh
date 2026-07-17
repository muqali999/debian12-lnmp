#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "================================\n"
printf " Update SSH Login(use ssh key) 	\n"
printf " copyright:www.doitphp.com      \n"
printf "================================\n"
printf "\n\n"

printf "Please check ssh private key saved client? \n"
read -p "ssh private key is saved [y/n]:" isset
if [ $isset != 'y' ]; then
    echo "Please save ssh private key first.";
	exit 1
fi

mv /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

sed -i 's/^#RSAAuthentication yes/RSAAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

#更改SSL端口
read -p "Do you want update ssh port?[y/n]:" confirmSSHPort
if [ "$confirmSSHPort" = "y" ] || [ "$confirmSSHPort" = "Y" ]; then
	read -p "Input your customize ssh port :" sshPort
	if [ -f /etc/firewalld/firewalld.conf ]; then
		firewall-cmd --zone=public --add-port=$sshPort/tcp --permanent
		cat /etc/firewalld/zones/public.xml | grep $sshPort
		systemctl restart firewalld
	fi
	sed -i "s/^#Port 22/Port $sshPort/g" /etc/ssh/sshd_config
	cat /etc/ssh/sshd_config | grep $sshPort
fi

systemctl restart sshd

printf " === sshd_config has been update success. Please login use ssh private key === \n"