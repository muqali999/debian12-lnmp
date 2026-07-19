
Redis-7.4.2 安装说明

软件用途：NoSql Database

一、软件安装

1、安装方式
编译安装

2、安装文件
redis-install.sh

3、安装目录
/usr/local/redis

执行文件: /usr/local/redis/bin/redis-server

pid:	  /usr/local/redis/var/run/redis.pid
套接文件：/usr/local/redis/var/run/redis.sock

二、配置文件
1、文件目录
/usr/local/redis/etc/

2、主配置文件
/usr/local/redis/etc/redis.conf

三、日志文件
日志目录：
/data/logs/redis/
日志文件：
/data/logs/redis/redislog

四、控制命令
启动 : systemctl start redis.service
关闭 : systemctl stop redis.service
重启 : systemctl restart redis.service

状态查询 ：systemctl status redis.service

控制文件目录：/etc/systemd/system/redis.service

五、数据存放目录
/data/redis

六、开启密码验证
配置文件(#450) #requirepass 去掉#, 设置密码, 重启Redis. 如下所示，
requirepass "xiaoke@2022"
或
requirepass xiaoke@2022

七、开启远程访问
配置文件中,第61行
将bind 127.0.0.1 注释掉, 重启redis

八、主从复制
只需在从Redis Server上配置文件更改两处设置
(1)、第264行
更改为：slaveof 主库IP 6379
(2)、第271行
更改为：masterauth 主库密码
(3)、重启redis


附:CLI操作命令
登陆：/usr/local/redis/bin/redis-cli -h localhost -p 6379 -a "password"
查询所有的key:->keys *
设置数据:     ->set test.name tommy
获取数据：    ->get test.name

ssdb(Redis替代品)
http://ssdb.io/zh_cn/