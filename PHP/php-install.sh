#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

# 定义软件名称

#软件包名称
packageName="php-8.5.8.tar.gz"

printf "\n"
printf "===========================\n"
printf "   PHP 8.5.8 Install	   \n"
printf "copyright: www.doitphp.com \n"
printf "===========================\n"
printf "\n\n"

#安装依赖软件函数, 用法: softwareInstall 软件名 校验文件路径
softwareInstall(){
	printf "========= $1 installed start... =========\n\n"

	#parse params
	if [ ! -n "$1" ]; then
		printf "Error: the first parameter: software name cannot be empty!\n"
		exit 1
	fi
	if [ ! -n "$2" ]; then
		printf "Error: the second parameter: software path cannot be empty!\n"
		exit 1
	fi

	if [ -s $2 ]; then
		echo "$1 has been installed.";
	else
		#parse whether the software installation package exists
		if [ ! -s $1.tar.gz ]; then
			printf "Error: $1.tar.gz does not exist!\n"
			exit 1
		fi

		if [ -s $1 ]; then
			rm -rf $1
		fi
		tar -zxvf $1.tar.gz

		cd $1
		make install
		cd -

		#parse whether the software is successfully installed
		if [ ! -s $2 ]; then
			printf "Error: $1 compile install failed!\n"
			exit 1
		fi
	fi

	printf "\n========= $1 installed Completed! =========\n\n"
}

#重新链接, 将旧的链接文件删除，然后重新链接。用法：softwareRelink 旧链接文件 新文件路径
softwareRelink(){
	printf "========= $1 relink start... =========\n\n"

	#参数分析
	if [ ! -n "$1" ]; then
		printf "Error: the first parameter: software name cannot be empty!\n"
		exit 1
	fi
	if [ ! -n "$2" ]; then
		printf "Error: the second parameter: software path cannot be empty!\n"
		exit 1
	fi

	#删除旧的软件或软链接
	if [ -s $1 ]; then
		rm -rf $1
	fi
	#创建软链接
	ln -s $2 $1

	printf "\n========= $1 relink Completed! =========\n\n"
}

#检测安装包是否存在
if [ ! -f src/$packageName ]; then
    printf "the file src/$packageName is not exists!\n"
	exit 1
fi

if [ ! -f php-fpm.service.txt ]; then
    printf "the file php-fpm.service.txt is not exists!\n"
	exit 1
fi

cd src

#安装libpng
printf "========= libpng-1.6.58 installed start... =========\n\n"

softwareInstall libpng-1.6.58 /usr/local/lib/libpng.so
softwareRelink /usr/lib64/libpng.so /usr/local/lib/libpng.so

printf "\n========= libpng-1.6.58 installed Completed! =========\n\n"

#安装freetype
printf "========= freetype-2.14.3 installed start... =========\n\n"

softwareInstall freetype-2.14.3 /usr/local/lib/libfreetype.so
softwareRelink /usr/lib64/libfreetype.so /usr/local/lib/libfreetype.so

printf "\n========= freetype-2.14.3 installed Completed! =========\n\n"

#安装jpeg
printf "========= jpeg-10 installed start... =========\n\n"

softwareInstall jpeg-10 /usr/local/lib/libjpeg.so
softwareRelink /usr/lib64/libjpeg.so /usr/local/lib/libjpeg.so

printf "\n========= jpeg-10 installed Completed! =========\n\n"

#安装libgd
printf "========= libgd-2.3.3 installed start... =========\n\n"

softwareInstall libgd-2.3.3 /usr/local/lib/libgd.so
softwareRelink /usr/lib64/libgd.so /usr/local/lib/libgd.so

printf "\n========= libgd-2.3.3 installed Completed! =========\n\n"

#安装onig
printf "========= onig-6.9.10 installed start... =========\n\n"

softwareInstall onig-6.9.10 /usr/local/lib/libonig.so

printf "\n========= onig-6.9.10 installed Completed! =========\n\n"

#安装Curl
printf "========= curl-8.21.0 installed start... =========\n\n"

softwareInstall curl-8.21.0 /usr/local/bin/curl
softwareRelink /usr/bin/curl /usr/local/bin/curl

printf "\n========= curl-8.21.0 installed Completed! =========\n\n"

ldconfig


#安装PHP扩展所需的软件依赖包
apt -y install bzip2 libbz2-dev
apt -y install libsqlite3-dev libpq-dev libonig-dev libsasl2-dev libyaml-dev
apt -y install libsystemd-dev libsodium-dev libargon2-dev
apt -y install libtidy-dev libicu-dev libffi-dev
apt -y install libldap2-dev libpq-dev

#安装abbitmq
apt -y install librabbitmq4 librabbitmq-dev

#安装imagemagick
apt -y install imagemagick libmagickwand-dev

printf "========= PHP install start... =========\n\n"

if [ -s php ]; then
    rm -rf php
fi
tar zxvf $packageName

mv php /usr/local/php

if [ ! -f /usr/local/php/bin/php ]; then
    printf "Error: php make install failed!\n"
    exit 1
fi

#创建软链接
if [ -f /etc/php.ini ]; then
	rm -rf /etc/php.ini
fi
ln -s /usr/local/php/etc/php.ini /etc/php.ini

if [ -f /usr/bin/php ]; then
	rm -rf /usr/bin/php
fi
ln -s /usr/local/php/bin/php /usr/bin/php

if [ -f /usr/bin/composer ]; then
	rm -rf /usr/bin/composer
fi
ln -s /usr/local/php/bin/composer /usr/bin/composer

#创建目录
if [ ! -s /data/logs/php ]; then
	mkdir -m 0755 -p /data/logs/php
	chown www:www -R /data/logs/php
fi

if [ ! -s /var/log/php ]; then
	ln -s /data/logs/php /var/log/php
fi

if [ ! -s /data/www/runtime/session ]; then
	mkdir -m 0777 -p /data/www/runtime/session /data/www/runtime/xhprof
	chown www:www -R /data/www/runtime/session /data/www/runtime/xhprof
fi

if [ -s /usr/local/php/var/run ]; then
	rm -rf /usr/local/php/var/run
fi
mkdir -m 0777 -p /usr/local/php/var/run
chown www:www -R /usr/local/php/var/run

if [ -f /etc/systemd/system/php-fpm.service ]; then
	rm -rf /etc/systemd/system/php-fpm.service
fi
mv ../php-fpm.service.txt /etc/systemd/system/php-fpm.service

systemctl daemon-reload

systemctl start php-fpm.service
systemctl enable php-fpm.service

/usr/local/php/bin/php --ini

#配置文件创建软链接
if [ -s /etc/php ]; then
	rm -rf /etc/php
fi
ln -s /usr/local/php/etc /etc/php

#开启错误信息显示
read -p "Do you want open display_errors?[y/n]:" isDisplayErrors
if [ "$isDisplayErrors" = "y" ] || [ "$isDisplayErrors" = "Y" ]; then
	sed -i 's/^display_errors = Off/display_errors = On/g' /usr/local/php/etc/php.ini
fi

#关闭opcache缓存
read -p "Do you want close opcache?[y/n]:" isCloseOpcache
if [ "$isCloseOpcache" = "y" ] || [ "$isCloseOpcache" = "Y" ]; then
	sed -i 's/^;opcache.enable=1/opcache.enable=0/g' /usr/local/php/etc/php.ini
fi

#是否使用phpinfo函数
read -p "Do you want allow use phpinfo function?[y/n]:" isPHPInfo
if [ "$isPHPInfo" = "y" ] || [ "$isPHPInfo" = "Y" ]; then
	sed -i 's/^disable_functions = system,passthru,exec,shell_exec,popen,phpinfo/disable_functions = system,passthru,exec,shell_exec,popen/g' /usr/local/php/etc/php.ini
fi

#Mysql host是否支持localhost
read -p "Does the MySQL host support localhost?[y/n]:" hasInstalledMySQL
if [ "$hasInstalledMySQL" = "y" ] || [ "$hasInstalledMySQL" = "Y" ]; then
	sed -i 's/^mysqli.default_socket =/mysqli.default_socket = \/usr\/local\/mysql\/var\/run\/mysql.sock/g' /usr/local/php/etc/php.ini
	sed -i 's/^pdo_mysql.default_socket=\/usr\/local\/mysql\/var\/run\/mysql.sock/pdo_mysql.default_socket=/g' /usr/local/php/etc/php.ini
fi

#更改php-fpm进程数
free -g | awk '/Mem:/{print $2}'

read -p "Input Your System Mem Size(G) Number 2, 4, 8, 16 :" isMemSize
if [ $isMemSize = 4 ]; then
	sed -i 's/^pm.max_children = 128/pm.max_children = 256/g' /usr/local/php/etc/php-fpm.conf
	sed -i 's/^pm.start_servers = 32/pm.start_servers = 64/g' /usr/local/php/etc/php-fpm.conf
fi
if [ $isMemSize = 8 ]; then
	sed -i 's/^pm = dynamic/pm = static/g' /usr/local/php/etc/php-fpm.conf
	sed -i 's/^pm.max_children = 128/pm.max_children = 512/g' /usr/local/php/etc/php-fpm.conf
	sed -i 's/^pm.start_servers = 32/pm.start_servers = 128/g' /usr/local/php/etc/php-fpm.conf
fi
if [ $isMemSize = 16 ]; then
	sed -i 's/^pm = dynamic/pm = static/g' /usr/local/php/etc/php-fpm.conf
	sed -i 's/^pm.max_children = 128/pm.max_children = 1024/g' /usr/local/php/etc/php-fpm.conf
	sed -i 's/^pm.start_servers = 32/pm.start_servers = 256/g' /usr/local/php/etc/php-fpm.conf
fi

read -p "Do you want to restart php-fpm?[y/n]:" isrestart
if [ "$isrestart" = "y" ] || [ "$isrestart" = "Y" ]; then
	systemctl restart php-fpm.service
fi
systemctl status php-fpm.service

printf "\n========== PHP install Completed! ========\n\n"

ps aux | grep php | grep -v "grep"
systemctl list-units | grep php-fpm.service

printf "============== The End. ==============\n"