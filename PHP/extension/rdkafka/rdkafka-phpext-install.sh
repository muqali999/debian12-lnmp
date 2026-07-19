#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

# 定义软件名称

#扩展模块名
extModuleName="rdkafka"

#PHP版本发行日期
#releaseDate="20240924"

printf "\n"
printf "===========================\n"
printf "  PHP Extension Install	   \n"
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
if [ ! -f src/librdkafka-2.15.0.tar.gz ]; then
    printf "the file src/librdkafka.tar.gz is not exists!\n"
	exit 1
fi

if [ ! -f src/rdkafka.so ]; then
    printf "the file src/rdkafka.so is not exists!\n"
	exit 1
fi

cd src

#安装软件依懒包: librdkafka
printf "========= librdkafka installed start... =========\n\n"

softwareInstall librdkafka-2.15.0 /usr/local/lib/librdkafka.so
softwareRelink /usr/lib64/librdkafka.so /usr/local/lib/librdkafka.so

ldconfig

printf "\n========= librdkafka installed Completed! =========\n\n"


#安装扩展文件
if [ -s /usr/local/php/lib/php/extensions/no-debug-non-zts-$releaseDate/rdkafka.so ]; then
	#备份已存在的扩展模块
	mv /usr/local/php/lib/php/extensions/no-debug-non-zts-$releaseDate/rdkafka.so /usr/local/php/lib/php/extensions/no-debug-non-zts-$releaseDate/rdkafka.so.bak
fi
mv rdkafka.so /usr/local/php/lib/php/extensions/no-debug-non-zts-$releaseDate/rdkafka.so

#PHP配置文件中开启扩展
isExists=`grep 'extension = "rdkafka.so"' /usr/local/php/etc/php.ini | grep -v ";" | wc -l`
if [ "$isExists" != "1" ]; then
	#添加设置
	sed -i '/;extension_dir = "ext"/ a\extension = "rdkafka.so"' /usr/local/php/etc/php.ini  
fi

systemctl restart php-fpm.service


printf "\n========== PHP install Completed! ========\n\n"

ps aux | grep php | grep -v "grep"
/usr/local/php/bin/php -m | grep rdkafka

printf "============== The End. ==============\n"