
Lsyncd v2.3.1 安装说明

软件用途：多台Linux Server之间的数据同步

一、软件安装

1、安装方式
编译安装

2、安装文件
lsyncd-install.sh

3、安装目录
/usr/local/lsyncd

执行文件: /usr/local/lsyncd/bin/rsync
Pid: /usr/local/lsyncd/var/run/lsyncd.pid

二、配置文件
1、文件目录
/usr/local/lsyncd/etc

2、主配置文件
/usr/local/lsyncd/etc/lsyncd.conf

3、用户配置文件(帐号密码)
/usr/local/lsyncd/etc/lsyncd.pass

三、日志目录
1、日志目录
/data/logs/rsync

2、日志文件
/data/logs/rsync/lsyncd.log

四、控制命令
启动 : systemctl start lsyncd.service
关闭 : systemctl stop lsyncd.service
重启 : systemctl restart lsyncd.service

状态查询 ：systemctl status lsyncd.service

控制文件目录：/etc/systemd/system/lsyncd.service