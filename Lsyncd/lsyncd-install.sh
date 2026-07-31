#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "===========================\n"
printf "   lsyncd-2.3.1 Install   \n"
printf " copyright:www.doitphp.com \n"
printf "===========================\n"
printf "\n\n"

if [ ! -f lsyncd.service.txt ]; then
    printf "the file lsyncd.service.txt is not exists!\n"
	exit 1
fi

#检测src目录是否存在
if [ ! -s src ]; then    
    printf "Error: directory src not found.\n"
    exit 1
fi
cd src

if [ ! -f lsyncd-2.3.1.tar.gz ]; then
    printf "Error: lsyncd-2.3.1.tar.gz not found!\n"
    exit 1
fi

#安装依赖软件包
apt -y install lua5.3 liblua5.3-dev

printf "========= Lsyncd install start... =========\n\n"

if [ -s lsyncd ]; then
    rm -rf lsyncd
fi
tar zxvf lsyncd-2.3.1.tar.gz

mv lsyncd /usr/local/lsyncd

if [ ! -f /usr/local/lsyncd/bin/lsyncd ]; then
    printf "Error: lsyncd install failed!\n"
    exit 1
fi

#PID目录分析
if [ -s /usr/local/lsyncd/var/run ]; then
	rm -rf /usr/local/lsyncd/var/run
fi
mkdir -m 0777 -p /usr/local/lsyncd/var/run

#日志目录分析
if [ ! -s /data/logs/lsyncd ]; then
	mkdir -m 0666 -p /data/logs/lsyncd
fi

if [ ! -s /var/log/lsyncd ]; then
	ln -s /data/logs/lsyncd /var/log/lsyncd
fi

#更改文件权限
chmod 0755 /usr/local/lsyncd/bin/lsyncd
chmod 0644 -R /usr/local/lsyncd/etc
chmod 0600 /usr/local/lsyncd/etc/rsync.pass

ldconfig

if [ -f /etc/systemd/system/lsyncd.service ]; then
    rm -rf /etc/systemd/system/lsyncd.service
fi
mv ../lsyncd.service.txt /etc/systemd/system/lsyncd.service
chmod +x /etc/systemd/system/lsyncd.service

systemctl daemon-reload
systemctl enable lsyncd.service

systemctl start lsyncd.service
systemctl status lsyncd.service

#创建软链接
if [ -f /usr/bin/lsyncd ]; then
    rm -rf /usr/bin/lsyncd	
fi
ln -s /usr/local/lsyncd/bin/lsyncd /usr/bin/lsyncd

if [ -f /etc/lsyncd ]; then
	rm -rf /etc/lsyncd
fi
ln -s /usr/local/lsyncd/etc /etc/lsyncd

printf "\n========== Lsyncd install Completed! =======\n\n"

ps aux | grep lsyncd | grep -v "grep"
systemctl status lsyncd.service

printf "check lsyncd.service automatic start up:"
systemctl is-enabled lsyncd.service

printf "============== The End. ==============\n"