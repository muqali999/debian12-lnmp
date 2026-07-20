#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "===============================\n"
printf " based librarys APT install    \n"
printf " copyright : www.doitphp.com   \n"
printf "===============================\n"
printf "\n\n"

printf "=== commond library dns install start ===\n\n"

#下载工具
isWget=`whereis wget|awk '{print $2}'`
if [ "$isWget" = "" ]; then
    apt -y install wget
fi

isGit=`whereis git|awk '{print $2}'`
if [ "$isGit" = "" ]; then
    apt -y install git
fi

#解压工具
apt -y install tar unzip

#编译工具
#essential工具集,包含gcc,gcc-c++
apt install build-essential

apt -y install pcre2-utils libpcre2-dev

apt -y install automake cmake
apt -y install dos2unix ncurses-dev libreadline-dev

#网络相关
apt -y install libcurl4-openssl-dev curl openssl

apt -y install libsystemd-dev
apt -y install libevent-dev libpsl-dev
apt -y install bzip2 libbz2-dev zstd

apt -y install libxml2-dev libxslt-dev libsasl2-dev
apt -y install libaio-dev libtool

apt -y install libmcrypt-dev
apt -y install libmhash-dev libmhash2

#内存优化管理
apt -y install libjemalloc2 libjemalloc-dev

#图片GD库相关
apt -y install libzip-dev libjpeg-dev libpng-dev libssl-dev
apt -y install libgd-dev libgd3

#运维管理工具
apt -y install iputils-ping iftop lsof mtr sysstat telnet traceroute network-manager

#编程语言
apt -y install perl

printf "\n=== commond library apt install Completed! ===\n\n"

#创建源码目录, 以备下一步进行软件编译安装
if [ ! -s src ]; then
	mkdir -m 0775 src
fi

printf "============== The End. ==============\n"