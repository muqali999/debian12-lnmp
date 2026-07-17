#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "===============================\n"
printf " based librarys Compile install\n"
printf " copyright : www.doitphp.com   \n"
printf "===============================\n"
printf "\n\n"

#检测src目录是否存在
if [ ! -s src ]; then
    printf "Error: directory src not found.\n"
    exit 1
fi

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

	#parse params
	if [ ! -n "$1" ]; then
		printf "Error: the first parameter: software name cannot be empty!\n"
		exit 1
	fi
	if [ ! -n "$2" ]; then
		printf "Error: the second parameter: software path cannot be empty!\n"
		exit 1
	fi

	if [ -s $1 ]; then
		rm -rf $1
	fi
	ln -s $2 $1

	printf "\n========= $1 relink Completed! =========\n\n"
}

cd src

printf "=== commond library compile install start ===\n\n"

#zlib
softwareInstall zlib-1.3.2 /usr/local/lib/libz.so
softwareRelink /usr/lib64/libz.so /usr/local/lib/libz.so

#pcre2
softwareInstall pcre2-10.47 /usr/local/bin/pcre2grep
softwareRelink /usr/bin/pcre2grep /usr/local/bin/pcre2grep

# libzip
if [ -s /usr/local/lib/libzip.so ]; then
    echo "libzip has been installed.";
else
	if [ -s libzip-1.11.4 ]; then
		rm -rf libzip-1.11.4
	fi
	tar -zxvf libzip-1.11.4.tar.gz
	
    cd libzip-1.11.4/build
    make install
    cd -
fi

softwareRelink /usr/lib64/libzip.so /usr/local/lib/libzip.so

printf "\n=== commond library compile install Completed! ===\n\n"

ldconfig

printf "============== The End. ==============\n"