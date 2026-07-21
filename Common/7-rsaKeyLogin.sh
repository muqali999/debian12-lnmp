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

mv /root/.ssh/id_ed25519.pub /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

sed -i 's/^#RSAAuthentication yes/RSAAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

#更改SSL端口
read -p "Do you want update ssh port?[y/n]:" confirmSSHPort
if [ "$confirmSSHPort" = "y" ] || [ "$confirmSSHPort" = "Y" ]; then
	read -p "Input your customize ssh port :" sshPort
	#更改sshd配置文件
	sed -i "s/^#Port 22/Port $sshPort/g" /etc/ssh/sshd_config
	cat /etc/ssh/sshd_config | grep $sshPort
	
	#更改防火墙配置
	if [ -f /etc/ufw/ufw.conf ]; then
		sudo ufw allow $sshPort
		sudo ufw status verbose | grep $sshPort
		sudo ufw reload
	fi
fi

systemctl restart sshd

printf " === sshd_config has been update success. Please login use ssh private key === \n"