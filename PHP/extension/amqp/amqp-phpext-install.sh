#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

#PHP版本发行日期
releaseDate="20240924"

printf "\n"
printf "===========================\n"
printf "  PHP Extension：amqp Install	   \n"
printf "copyright: www.doitphp.com \n"
printf "===========================\n"
printf "\n\n"

#检测安装包是否存在
if [ ! -f src/amqp.so ]; then
    printf "the file src/amqp.so is not exists!\n"
	exit 1
fi

cd src

#librabbitmq安装
printf "========= rabbitmq-c installed start... =========\n\n"

apt -y install librabbitmq4 librabbitmq-dev

printf "\n========= rabbitmq-c installed Completed! =========\n\n"

#安装扩展文件
if [ -s /usr/local/php/lib/php/extensions/no-debug-non-zts-$releaseDate/amqp.so ]; then
	mv /usr/local/php/lib/php/extensions/no-debug-non-zts-$releaseDate/amqp.so /usr/local/php/lib/php/extensions/no-debug-non-zts-$releaseDate/amqp.so.bak
fi
mv amqp.so /usr/local/php/lib/php/extensions/no-debug-non-zts-$releaseDate/amqp.so

#PHP配置文件中开启扩展
isExists=`grep 'extension = "amqp.so"' /usr/local/php/etc/php.ini | grep -v ";" | wc -l`
if [ "$isExists" != "1" ]; then
	#添加设置
	sed -i '/;extension_dir = "ext"/ a\extension = "amqp.so"' /usr/local/php/etc/php.ini  
fi

systemctl restart php-fpm.service


printf "\n========== PHP install Completed! ========\n\n"

ps aux | grep php | grep -v "grep"
/usr/local/php/bin/php -m | grep amqp

printf "============== The End. ==============\n"