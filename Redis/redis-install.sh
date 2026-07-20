#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "===========================\n"
printf " valkey-9.1.0 Install	   \n"
printf " copyright:www.doitphp.com \n"
printf "===========================\n"
printf "\n\n"

if [ ! -f redis.service.txt ]; then
    printf "the file redis.service.txt is not exists!\n"
	exit 1
fi

#检测src目录是否存在
if [ ! -s src ]; then    
    printf "Error: directory src not found.\n"
    exit 1
fi

cd src

if [ ! -f valkey-9.1.0.tar.gz ]; then
    printf "the file valkey-9.1.0.tar.gz is not exists!\n"
	exit 1
fi

#安装依懒库文件
apt -y install tcl tcl-dev

printf "========= redis install start... =========\n\n"

groupadd redis
useradd -g redis redis -s /bin/false

#创建数据存贮目录
mkdir -m 0755 -p /data/database/redis
chown -R redis:redis /data/database/redis

#创建日志目录
mkdir -m 0755 -p /data/logs/redis
chown -R redis:redis /data/logs/redis

if [ ! -s /var/log/redis ]; then
	ln -s /data/logs/redis /var/log/redis
fi

if [ -s redis ]; then
    rm -rf redis
fi
tar zxvf valkey-9.1.0.tar.gz

mv redis /usr/local/redis

if [ ! -f /usr/local/redis/bin/valkey-server ]; then
    printf "Error: redis compile install failed!\n"
    exit 1
fi

#创建进程ID目录
if [ ! -s /usr/local/redis/var/run ]; then
	mkdir -m 0755 -p /usr/local/redis/var/run
	chown -R redis:redis /usr/local/redis/var/run
fi

#设置启动脚本
if [ -s /etc/systemd/system/redis.service ]; then
    rm -rf /etc/systemd/system/redis.service
fi
mv ../redis.service.txt /etc/systemd/system/redis.service

systemctl daemon-reload

systemctl start redis.service
systemctl enable redis.service

#内存优化设置
isExists=`grep 'vm.overcommit_memory' /etc/sysctl.conf | wc -l`
if [ "$isExists" != "1" ]; then
	echo "vm.overcommit_memory = 1">>/etc/sysctl.conf
	sysctl -p
fi

#创建软链接
if [ -f /usr/bin/redis-server ]; then
	rm -rf /usr/bin/redis-server
fi
ln -s /usr/local/redis/bin/valkey-server /usr/bin/redis-server

if [ -f /usr/local/redis/bin/valkey-server ]; then
	rm -rf /usr/bin/redis
fi
ln -s /usr/local/redis/bin/valkey-cli /usr/bin/redis

if [ -s /etc/redis ]; then
	rm -rf /etc/redis
fi
ln -s /usr/local/redis/etc /etc/redis

systemctl restart redis.service

printf "\n========== redis install Completed! =======\n\n"

ps aux | grep redis | grep -v "grep"
netstat -ntlp

printf "============== The End. ==============\n"