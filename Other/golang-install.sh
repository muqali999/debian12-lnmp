#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "=================================\n"
printf " Debian 12.x 64位 install golang \n"
printf "  copyright: www.doitphp.com  \n"
printf "=================================\n"
printf "\n"

INFO=`whereis go|awk '{print $2}'`
if [ "$INFO" != "/usr/bin/go" ]; then
	[ -d "src" ] || mkdir src
	cd src
	wget https://go.dev/dl/go1.24.6.linux-amd64.tar.gz

	if [ -d "/usr/local/go" ]; then
		rm -rf /usr/local/go
	fi
	tar -C /usr/local -zxvf go1.24.6.linux-amd64.tar.gz
	
	if [ -f "/usr/local/go/bin/go" ]; then
		ln -s /usr/local/go/bin/go /usr/bin/go
	fi

	echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.profile
	source ~/.profile
	
	go version
else
	printf "/usr/bin/go already exists.\n"
fi

printf "============== The End. ==============\n"