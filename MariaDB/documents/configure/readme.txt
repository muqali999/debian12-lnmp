
Mysql主从库设置

一、设置配置文件
主库：
	server-id = 1
	log-bin=mysql-bin

从库：
	server-id = 2
	log-bin=mysql-bin
	relay_log = mysql-relay-bin
	log_slave_updates = 1
	read_only = 1

注：server-id是唯一标识，主从库不可重复。

重启主从库

二、查看主从库的状态
主库：
1、开通同步帐号(一般情况下不用root帐户)
	GRANT REPLICATION SLAVE, RELOAD, SUPER ON *.* TO 用户名@'%' IDENTIFIED BY '帐户密码';
2、查看主库状态
	SHOW MASTER STATUS;

从库：
1、连接主库
	CHANGE MASTER TO MASTER_HOST='主库IP地址', MASTER_USER='用户名', MASTER_PASSWORD='帐户密码', MASTER_LOG_FILE='mysql-bin.00000x', MASTER_LOG_POS=0;
2、启动从库
	START SLAVE (关闭从库即：STOP SLAVE)
3、查看状态
	SHOW SLAVE STATUS\G;
注：Slave_IO及Slave_SQL进程必须正常运行，即YES状态，否则都是错误的状态(如：其中一个NO均属错误)。

三、数据库监控
(略)

四、Mysql初始化脚本(mysql_init.sh)用户说明

用户：
root, mysql默认的系统管理员
web_user,用于web程序
dump_user,用户mysqldump数据备份
getleman,用于root的替补(用于隐藏root用户),主要平时用来查看数据库数据运行状态

root: 5b58b73c0c57e0d0bf07257af70e9f06
gentleman : 953bf29f82b4464e596bf1bb77dac599
web_user : 427b4f3a4e31c8cb75d1521027fdde46
dump_user : 205df44c63c2b20d2663c65dd926f36b

mysqlV5.6的mysqldump数据备份用户名设置
在my.cnf中，添加:

[mysqldump]
user=dump_user
password=205df44c63c2b20d2663c65dd926f36b

则可利用下面命令执行数据备份
/usr/local/mysql/bin/mysqldump dbname > dbbak.sql

crontab 实例
1       4       *       *       *       /bin/sh /www/crontab/mysqlbackup.sh