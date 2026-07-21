#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "==============================\n"
printf " Debian 12.x 64位 install java \n"
printf "  copyright: www.doitphp.com  \n"
printf "==============================\n"
printf "\n"

isjava=`whereis java|awk '{print $2}'`
if [ "$isjava" != "/usr/bin/java" ]; then
	[ -d "src" ] || mkdir src
	cd src
	wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb
	dpkg -i jdk-21_linux-x64_bin.deb
	java -version
	cd -
else
	printf "/usr/bin/java already exists.\n"
fi

printf "============== The End. ==============\n"