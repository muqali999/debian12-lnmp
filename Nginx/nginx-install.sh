#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "============================\n"
printf "  Nginx-1.30.4 Install    \n"
printf " copyright: www.doitphp.com \n"
printf "============================\n"
printf "\n\n"

#检测src目录是否存在
if [ ! -s src ]; then    
    printf "Error: directory src not found.\n"
    exit 1
fi

if [ ! -f nginx.service.txt ]; then
    printf "the file nginx.service.txt is not exists!\n"
	exit 1
fi

cd src

if [ ! -f nginx-1.30.4.tar.gz ]; then
    printf "the file nginx-1.30.4.tar.gz is not exists!\n"
	exit 1
fi

#创建用户
groupadd www
useradd -g www www -s /bin/false

#创建目录
if [ -s /data/www ]; then
	rm -rf /data/www
fi
mkdir -m 0755 -p /data/www /data/www/htdocs /data/www/crontab /data/www/cache /data/www/runtime
chown -R www:www /data/www

if [ -s /data/logs/nginx ]; then
	rm -rf /data/logs/nginx
fi
mkdir -m 0755 -p /data/logs/nginx
chown www:www -R /data/logs/nginx

if [ ! -s /var/log/nginx ]; then
	ln -s /data/logs/nginx /var/log/nginx
fi

mkdir -m 0777 -p /data/www/cache/nginx_proxy_cache /data/www/cache/nginx_proxy_temp

printf "\n========= Nginx install start... =========\n\n"

if [ ! -f /usr/local/nginx/sbin/nginx ]; then
	if [ -s nginx ]; then
		rm -rf nginx
	fi
	tar -zxvf nginx-1.30.4.tar.gz

	mv nginx /usr/local/nginx

	#设置Nginx文件权限
	if [ -f /usr/local/nginx/sbin/nginx ]; then
		cd /usr/local/nginx

		chown www:www -R client_body_temp fastcgi_temp scgi_temp uwsgi_temp
		chmod 0700 client_body_temp fastcgi_temp scgi_temp uwsgi_temp
		chmod 0755 -R sbin/nginx
		chmod 0644 -R conf/ domains/ ssl/ logs/
		
		#创建pid目录
		if [ -s var/run ]; then
			rm -rf var/run
		fi
		mkdir -m 0666 -p var/run
		chown www:www -R var/run

		cd -
	fi
fi

#创建开机启动脚本
if [ -f /etc/systemd/system/nginx.service ]; then
	rm -rf /etc/systemd/system/nginx.service
fi
mv ../nginx.service.txt /etc/systemd/system/nginx.service

systemctl daemon-reload

systemctl start nginx.service
systemctl status nginx.service

systemctl enable nginx.service

printf "\n========== Nginx install Completed! =======\n\n"

ps aux | grep nginx | grep -v "grep"
lsof -n | grep jemalloc | grep -v "sh"

printf "check Nginx whether to enable startup\n"
systemctl is-enabled nginx.service

#更改Nginx配置文件线程数
cat /proc/cpuinfo | grep "cpu cores" | wc -l
read -p "Input CPU Cores Nums :" coreNum
sed -i "s/^worker_processes  auto;/worker_processes  $coreNum;/g" /usr/local/nginx/conf/nginx.conf
cat /usr/local/nginx/conf/nginx.conf | grep worker_processes

read -p "Do you want to restart Nginx?[y/n]:" isrestart
if [ "$isrestart" = "y" ] || [ "$isrestart" = "Y" ]; then
	systemctl restart nginx.service
fi

systemctl status nginx.service

#创建软链接
if [ -s /usr/bin/nginx ]; then
	rm -rf /usr/bin/nginx
fi
ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx

if [ -s /etc/nginx ]; then
	rm -rf /etc/nginx
fi
ln -s /usr/local/nginx/conf/ /etc/nginx

printf "============== The End. ==============\n"
