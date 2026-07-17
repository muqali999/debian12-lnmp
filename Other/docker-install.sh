#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "===========================\n"
printf " Docker APT Install   \n"
printf " copyright:www.doitphp.com \n"
printf "===========================\n"
printf "\n\n"

#卸载旧的安装包
for pkg in docker docker-engine docker.io docker-doc docker-compose podman-docker containerd runc; 
	do apt-get remove $pkg; 
done

#安装依赖软件包
apt -y update && apt -y install gnupg apt-transport-https

#添加GPG密钥
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

#存储库配置
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt -y update

#apt安装
apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

printf "\n========== docker install Completed! =======\n\n"
#测试
docker run hello-world
printf "============== The End. =============="