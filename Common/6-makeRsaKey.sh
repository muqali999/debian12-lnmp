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

ssh-keygen -t rsa

cd /root/.ssh
pwd
ls -l

printf " === private key has been created === \n"