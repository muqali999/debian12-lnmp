#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "===========================\n"
printf "    Gitlab Install   \n"
printf " copyright:www.doitphp.com \n"
printf "===========================\n"
printf "\n\n"

#检测是否安装docker
isDocker=`whereis docker|awk '{print $2}'`
if [ "$isDocker" = "" ]; then
	printf "Error: Docker is not installed. Please install Docker first!\n"
	exit 1
fi

#创建目录
if [ ! -s /data/gitlab ]; then
	mkdir -p -m 0775 /data/gitlab/config /data/gitlab/logs /data/gitlab/data
fi

##
# 创建docker compose配置文件
##

if [ ! -s /usr/local/gitlab ]; then
	mkdir -m 0775 /usr/local/gitlab
fi

if [ -s /usr/local/gitlab/docker-compose.yml ]; then
	mv /usr/local/gitlab/docker-compose.yml /usr/local/gitlab/docker-compose.yml.bak
fi

cat >/usr/local/gitlab/docker-compose.yml<<EOF
services:
  gitlab:
    image: gitlab/gitlab-ce:latest
    container_name: gitlab
    restart: always
    hostname: 'gitlab.980080.xyz'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
      external_url: 'http://127.0.0.1:9090'
      gitlab_rails['gitlab_shell_ssh_port']: 222
    ports:
      - '9090:80'
      - '222:22'
    volumes:
      - '/data/gitlab/config:/etc/gitlab'
      - '/data/gitlab/logs:/var/log/gitlab'
      - '/data/gitlab/data:/var/opt/gitlab'
    shm_size: '256m'
EOF

read -p "Please enter the access URL or IP address :" gitlabUrl
sed -i "s/^external_url: 'http:\/\/127.0.0.1:9090'/external_url: 'http:\/\/$gitlabUrl:9090'/g" /usr/local/gitlab/docker-compose.yml

#执行安装命令
cd /usr/local/gitlab

docker compose up -d

cd -

#防火墙端口设置
sudo ufw allow 9090
sudo ufw allow 222
sudo ufw reload
sudo ufw status numbered

printf "\n========== Docker install Completed! ========\n\n"

ps aux | grep docker

printf "============== The End. ==============\n"