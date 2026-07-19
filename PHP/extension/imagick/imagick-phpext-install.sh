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
printf "  PHP Extension imagick Install	   \n"
printf "copyright: www.doitphp.com \n"
printf "===========================\n"
printf "\n\n"

#检测安装包是否存在
if [ ! -f src/imagick.so ]; then
    printf "the file src/imagick.so is not exists!\n"
	exit 1
fi

cd src

#安装库文件：imagemagick
apt -y install imagemagick libmagickwand-dev

#安装扩展文件
if [ -s /usr/local/php/lib/php/extensions/no-debug-non-zts-$releaseDate/imagick.so ]; then
	mv /usr/local/php/lib/php/extensions/no-debug-non-zts-$releaseDate/imagick.so /usr/local/php/lib/php/extensions/no-debug-non-zts-$releaseDate/imagick.so.bak
fi
mv imagick.so /usr/local/php/lib/php/extensions/no-debug-non-zts-$releaseDate/imagick.so

#PHP配置文件中开启扩展
isExists=`grep 'extension = "imagick.so"' /usr/local/php/etc/php.ini | grep -v ";" | wc -l`
if [ "$isExists" != "1" ]; then
	#添加设置
	sed -i '/;extension_dir = "ext"/ a\extension = "imagick.so"' /usr/local/php/etc/php.ini  
fi

systemctl restart php-fpm.service


printf "\n========== PHP install Completed! ========\n\n"

ps aux | grep php | grep -v "grep"
/usr/local/php/bin/php -m | grep imagick

printf "============== The End. ==============\n"