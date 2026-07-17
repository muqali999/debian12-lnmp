#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "===========================\n"
printf "    Umami Install   \n"
printf " copyright:www.doitphp.com \n"
printf "===========================\n"
printf "\n\n"

#检测是否安装docker
isDocker=`whereis docker|awk '{print $2}'`
if [ "$isDocker" = "" ]; then
	printf "Error: Docker is not installed. Please install Docker first!\n"
	exit 1
fi

#创建数据库目录
if [ ! -s /data/database/postgresql/umami ]; then
	mkdir -p -m 0700 /data/database/postgresql/umami
	chown 999:999 /data/database/postgresql/umami
fi

##
# 创建docker compose配置文件
##

if [ ! -s /usr/local/umami ]; then
	mkdir -m 0775 /usr/local/umami
fi

if [ -s /usr/local/umami/docker-compose.yml ]; then
	mv /usr/local/umami/docker-compose.yml /usr/local/umami/docker-compose.yml.bak
fi

cat >/usr/local/umami/docker-compose.yml<<EOF
services:
  db:
    image: postgres:16
    container_name: umami-db
    restart: always
    environment:
      POSTGRES_DB: umami
      POSTGRES_USER: umamiuser
      POSTGRES_PASSWORD: f9fe911e5f7dd38e011ceb932ed9c15d
    volumes:
      - /data/database/postgresql/umami:/var/lib/postgresql/data

  umami:
    image: ghcr.io/umami-software/umami:latest
    container_name: umami
    restart: always
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgresql://umamiuser:f9fe911e5f7dd38e011ceb932ed9c15d@db:5432/umami
      HASH_SALT: 43e26ba9952b3ff50c4fb03077e5b2ed
    depends_on:
      - db
EOF

#执行安装命令
cd /usr/local/umami

docker compose up -d

cd -

printf "\n========== Umami install Completed! ========\n\n"

netstat -ntlp | grep 3000

printf "============== The End. ==============\n"