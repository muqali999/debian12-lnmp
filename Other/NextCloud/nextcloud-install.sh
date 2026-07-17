#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "===========================\n"
printf "    NextCloud Install   \n"
printf " copyright:www.doitphp.com \n"
printf "===========================\n"
printf "\n\n"

#检测是否安装docker
isDocker=`whereis docker|awk '{print $2}'`
if [ "$isDocker" = "" ]; then
	printf "Error: Docker is not installed. Please install Docker first!\n"
	exit 1
fi

#配置文件检测
if [ ! -f nextcloud-docker-compose.txt ]; then
    printf "the file nextcloud-docker-compose.txt is not exists!\n"
	exit 1
fi

if [ ! -f nextcloud-env.txt ]; then
    printf "the file nextcloud-env.txt is not exists!\n"
	exit 1
fi

#创建目录
if [ ! -s /data/nextcloud ]; then
	mkdir -p -m 0775 /data/nextcloud
fi

if [ ! -s /usr/local/nextcloud ]; then
	mkdir -m 0775 /usr/local/nextcloud
fi

##
# 创建docker compose配置文件
##

if [ -s /usr/local/nextcloud/docker-compose.yml ]; then
	rm -rf /usr/local/nextcloud/docker-compose.yml
fi
mv nextcloud-docker-compose.txt /usr/local/nextcloud/docker-compose.yml

#设置配置文件
mv nextcloud-env.txt /usr/local/nextcloud/.env

#执行安装命令
cd /usr/local/nextcloud

docker compose up -d

cd -

#防火墙端口设置
sudo ufw allow 8080
sudo ufw reload
sudo ufw status numbered

printf "\n========== Docker install Completed! ========\n\n"

ps aux | grep docker
docker ps

printf "============== The End. ==============\n"