#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "================================\n"
printf " create rsa key \n"
printf " copyright:www.doitphp.com      \n"
printf "================================\n"
printf "\n\n"

#当有srakey存在时
if [ -f /root/.ssh/id_rsa.pub ] && [ -f /root/.ssh/authorized_keys ]; then
	echo "/root/.ssh/id_rsa.pub is exists!";
	exit 1
fi

printf "create ssh keys start...\n"

#推荐使用安全性更高的 Ed25519 算法来生成 SSH 密钥
#ssh-keygen -t rsa

ssh-keygen -t ed25519 -C "tommy@doitphp.com"

cd /root/.ssh
pwd
ls -l

printf " === private key has been created === \n"