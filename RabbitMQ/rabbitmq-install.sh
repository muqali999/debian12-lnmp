#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

# 自定义RabbitMQ管理工具的管理员用户名及管理密码
adminUserName="admin"
adminPassword="qwe123"

printf "\n"
printf "============================\n"
printf "   RabbitMQ V4.2.2 Install \n"
printf " copyright: www.doitphp.com \n"
printf "============================\n"
printf "\n\n"

if [ ! -s src ]; then    
    printf "Error: directory src not found.\n"
    exit 1
fi

cd src

#安装依赖软件包
apt -y install gnupg apt-transport-https


#安装Erlang

## Team RabbitMQ's signing key
curl -1sLf "https://keys.openpgp.org/vks/v1/by-fingerprint/0A9AF2115F4687BD29803A206B73A36E6026DFCA" | sudo gpg --dearmor | sudo tee /usr/share/keyrings/com.rabbitmq.team.gpg > /dev/null

sudo tee /etc/apt/sources.list.d/rabbitmq.list <<EOF
## Modern Erlang/OTP releases
##
deb [arch=amd64 signed-by=/usr/share/keyrings/com.rabbitmq.team.gpg] https://deb1.rabbitmq.com/rabbitmq-erlang/ubuntu/noble noble main
deb [arch=amd64 signed-by=/usr/share/keyrings/com.rabbitmq.team.gpg] https://deb2.rabbitmq.com/rabbitmq-erlang/ubuntu/noble noble main

## Provides modern RabbitMQ releases
##
deb [arch=amd64 signed-by=/usr/share/keyrings/com.rabbitmq.team.gpg] https://deb1.rabbitmq.com/rabbitmq-server/ubuntu/noble noble main
deb [arch=amd64 signed-by=/usr/share/keyrings/com.rabbitmq.team.gpg] https://deb2.rabbitmq.com/rabbitmq-server/ubuntu/noble noble main
EOF

apt -y update

## Install Erlang packages
apt -y install erlang-base erlang-asn1 erlang-crypto erlang-eldap erlang-ftp erlang-inets erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key erlang-runtime-tools erlang-snmp erlang-ssl erlang-syntax-tools erlang-tftp erlang-tools erlang-xmerl

## APT安装 rabbitmq-server
apt -y install rabbitmq-server --fix-missing

## dpkg包安装rabbitmq-server
##
#if [ ! -f rabbitmq-server_4.2.2-1_all.deb ]; then
#    wget https://github.com/rabbitmq/rabbitmq-server/releases/download/v4.2.2/rabbitmq-server_4.2.2-1_all.deb
#fi
#dpkg -i rabbitmq-server_4.2.2-1_all.deb


#管理工具设置
rabbitmq-plugins enable rabbitmq_management

# 添加用户
rabbitmqctl add_user $adminUserName $adminPassword

# 设置为超级管理员
rabbitmqctl set_user_tags $adminUserName administrator

# 授权远程访问
rabbitmqctl set_permissions -p / $adminUserName "." "." ".*"

#管理员用户列表
rabbitmqctl list-users

#创建启动服务
systemctl daemon-reload
systemctl start rabbitmq-server.service
systemctl status rabbitmq-server.service

systemctl enable rabbitmq-server.service
systemctl restart rabbitmq-server.service

#添加防火墙规则
#if [ -s /etc/ufw/ufw.conf ]; then
#	sudo ufw allow 5672
#	sudo ufw allow 15672
#fi

printf "\nrabbitmq-server version:\n"
rabbitmqctl version

ps aux | grep rabbitmq | grep -v "grep"

#管理后台访问网址: IP:15672

printf "============== The End. ==============\n"