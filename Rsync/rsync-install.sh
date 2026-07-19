#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "===========================\n"
printf "   rsync-3.4.4 Install   \n"
printf " copyright:www.doitphp.com \n"
printf "===========================\n"
printf "\n\n"

if [ ! -f rsyncd.service.txt ]; then
    printf "the file rsyncd.service.txt is not exists!\n"
	exit 1
fi

#检测src目录是否存在
if [ ! -s src ]; then    
    printf "Error: directory src not found.\n"
    exit 1
fi

cd src

if [ ! -f rsync-3.4.4.tar.gz ]; then
    printf "Error: rsync-3.4.4.tar.gz not found!\n"
    exit 1
fi

#删除yum安装过的软件旧版本
#apt -y remove rsync

#安装依赖软件包
apt -y install libxxhash0 xxhash libxxhash-dev
apt -y install lz4 liblz4-1 liblz4-dev

printf "========= Rsync install start... =========\n\n"

if [ -s rsync ]; then
    rm -rf rsync
fi
tar zxvf rsync-3.4.4.tar.gz

mv rsync /usr/local/rsync

if [ ! -f /usr/local/rsync/bin/rsync ]; then
    printf "Error: rsync install failed!\n"
    exit 1
fi

#PID目录分析
if [ -s /usr/local/rsync/var/run ]; then
	rm -rf /usr/local/rsync/var/run
fi
mkdir -m 0777 -p /usr/local/rsync/var/run

#日志目录分析
if [ ! -s /data/logs/rsync ]; then
	mkdir -m 0666 -p /data/logs/rsync
fi

if [ ! -s /var/log/rsync ]; then
	ln -s /data/logs/rsync /var/log/rsync
fi

#更改文件权限
chmod 0755 /usr/local/rsync/bin/rsync
chmod 0644 -R /usr/local/rsync/etc
chmod 0600 /usr/local/rsync/etc/rsyncd.pass

ldconfig

#/usr/local/rsync/bin/rsync --daemon --config=/usr/local/rsync/etc/rsyncd.conf

if [ -f /etc/systemd/system/rsyncd.service ]; then
    rm -rf /etc/systemd/system/rsyncd.service
fi
mv ../rsyncd.service.txt /etc/systemd/system/rsyncd.service

systemctl daemon-reload
systemctl enable rsyncd.service

systemctl start rsyncd.service
systemctl status rsyncd.service

#创建软链接
if [ -f /usr/bin/rsync ]; then
    rm -rf /usr/bin/rsync	
fi
ln -s /usr/local/rsync/bin/rsync /usr/bin/rsync

if [ -f /etc/rsync ]; then
	rm -rf /etc/rsync
fi
ln -s /usr/local/rsync/etc /etc/rsync

printf "\n========== Rsync install Completed! =======\n\n"

ps aux | grep rsync | grep -v "grep"
systemctl status rsyncd.service

printf "check rsyncd.service automatic start up:"
systemctl is-enabled rsyncd.service

printf "============== The End. ==============\n"