#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "===========================\n"
printf " php session redis config  \n"
printf " copyright:www.doitphp.com \n"
printf "===========================\n"
printf "\n\n"

#更改redis的默认端口
read -p "Input redis port(default 16861) :" redisPort
sed -i "s/^port 6379/port $redisPort/g" /usr/local/redis/etc/redis.conf
sed -i "s/^pidfile \/usr\/local\/redis\/var\/run\/redis_6379.pid/pidfile \/usr\/local\/redis\/var\/run\/redis_$redisPort.pid/g" /usr/local/redis/etc/redis.conf
sed -i "s/^# cluster-config-file nodes-6379.conf/# cluster-config-file nodes-$redisPort.conf/g" /usr/local/redis/etc/redis.conf

#开启redis密码访问
read -p "Input redis password :" redisPasswd
sed -i "s/^# requirepass foobared/requirepass $redisPasswd/g" /usr/local/redis/etc/redis.conf

systemctl restart redis.service
ps aux | grep redis

#更改php.ini相关的session设置
sed -i 's/^session.save_handler = files/session.save_handler = redis/g' /usr/local/php7/etc/php.ini
sed -i "s/\/www\/tmp\/php\/session/tcp:\/\/127.0.0.1:$redisPort?auth=$redisPasswd/g" /usr/local/php7/etc/php.ini

service php-fpm restart

printf "============== The End. ==============\n"