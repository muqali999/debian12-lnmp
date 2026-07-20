#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "=======================================\n"
printf "	   Mariadb-10.11.18  Install          \n"
printf "       copyright:www.doitphp.com       \n"
printf "=======================================\n"
printf "\n\n"

if [ ! -s src ]; then    
    printf "Error: directory src not found.\n"
    exit 1
fi

if [ ! -f mariadb.service.txt ]; then
    printf "the file mariadb.service.txt is not exists!\n"
	exit 1
fi

#新建用户
groupadd mysql
useradd -g mysql mysql -s /bin/false

#创建目录
if [ ! -d /data/database/mysql ]; then
    mkdir -m 0755 -p /data/database/mysql
    chown -R mysql:mysql /data/database/mysql
fi

if [ ! -d /data/logs/mysql ]; then
	mkdir -m 0755 -p /data/logs/mysql
	chown -R mysql:mysql /data/logs/mysql
fi

if [ ! -s /var/log/mysql ]; then
	ln -s /data/logs/mysql /var/log/mysql
fi

cd src

printf "========= MySql install start... =========\n\n"

if [ ! -f mariadb-10.11.18.tar.gz ]; then
	printf "the file mariadb-10.11.18.tar.gz is not exists!\n"
	exit 1
fi

#安装依赖软件库
#apt -y install libcurl4-openssl-dev libtirpc-dev libncurses-dev 

if [ -s mysql ]; then
    rm -rf mysql
fi
tar -zxvf mariadb-10.11.18.tar.gz

mv mysql /usr/local/mysql

if [ ! -f /usr/local/mysql/bin/mysql ]; then
    printf "Error: mysql compile install failed!\n"
    exit 1
fi

#删除旧的配置文件
if [ -f /etc/my.cnf ]; then
	rm -rf /etc/my.cnf
fi

cat >/etc/my.cnf<<EOF
# Mysql config file

# The MySQL server
[mysqld]
user = mysql
port = 3306
basedir = /usr/local/mysql
datadir = /data/database/mysql
socket	= /usr/local/mysql/var/run/mysql.sock
pid-file = /usr/local/mysql/var/run/mysqld.pid

#数据编码
character-set-server = utf8mb4
collation-server = utf8mb4_general_ci

#默认存贮引擎设置
default_storage_engine = InnoDB
innodb_file_per_table = 1
#默认值为128M,当MySql服务器配置较低时,可以将参数设小一点.
#innodb_buffer_pool_size = 64M

#binlog设置
#log-bin = mysql-bin
#binlog_format = mixed
#设置binlog日志清理时间,默认：604800秒(7天)
#binlog_expire_logs_seconds = 604800
#max_binlog_size = 100m
#binlog_cache_size = 4m
#max_binlog_cache_size = 512m

#MySql服务器ID,用于主从同步或集群管理
#server-id = 1

#查询缓存设置
query_cache_type = on
query_cache_strip_comments = on
query_cache_size = 64M
query_cache_limit = 2M

tmp_table_size = 256M
max_heap_table_size = 256M
table_open_cache = 512
open_files_limit = 8192

#慢日志设置
log_error = /data/logs/mysql/mysql-error.log
long_query_time = 2
slow_query_log = on
slow_query_log_file = /data/logs/mysql/mysql-slow.log

#连接设置
max_connections = 512
bind-address = 0.0.0.0
init_connect = 'SET NAMES utf8mb4'

[client]
default-character-set = utf8mb4
port = 3306
socket = /usr/local/mysql/var/run/mysql.sock

[mysqldump]
EOF

mkdir -m 0775 -p /usr/local/mysql/var/run
chown -R mysql:mysql /usr/local/mysql/var/run

#启动Mysql
/usr/local/mysql/scripts/mariadb-install-db --user=mysql --group=mysql --datadir=/data/database/mysql

ln -s /usr/local/mysql/lib/mysql /usr/lib/mysql
ln -s /usr/local/mysql/include/mysql /usr/include/mysql

ln -s /usr/local/mysql/bin/mariadb /usr/bin/mysql
ln -s /usr/local/mysql/bin/mariadb-dump /usr/bin/mysqldump

#设置启动脚本
if [ -f /etc/systemd/system/mysqld.service ]; then
	rm -rf /etc/systemd/system/mysqld.service
fi
mv ../mariadb.service.txt /etc/systemd/system/mysqld.service

systemctl daemon-reload

systemctl start mysqld.service
systemctl enable mysqld.service

cd -

#更改缓存设置,当服务器内存较小时,将缓存大小适当调小,防止服务宕机
read -p "Are you Sure Current is Virtual Server and Memery is 2G? [y/n]:" isInnodbpool
if [ "$isInnodbpool" = "y" ] || [ "$isInnodbpool" = "Y" ]; then
	sed -i 's/^#innodb_buffer_pool_size = 64M/innodb_buffer_pool_size = 64M/g' /etc/my.cnf
fi

#当使用云主机(VPS)时,在磁盘上创建虚拟内存.防止MySQL内存消耗太大出现宕机
cat /etc/fstab | grep /swapfile
read -p "Do you want create swap partitions?[y/n]:" isSwap
if [ "$isSwap" = "y" ] || [ "$isSwap" = "Y" ]; then
	dd if=/dev/zero of=/swapfile bs=1M count=1024
	mkswap /swapfile
	swapon /swapfile
	echo '/swapfile               swap                    swap    defaults        0 0' >> /etc/fstab
fi

printf "\n========== MySql install Completed! ========\n\n"
ps aux | grep mysql | grep -v "grep"
lsof -n | grep jemalloc | grep -v "sh"
systemctl status mysqld.service
printf "============== The End. ==============\n"