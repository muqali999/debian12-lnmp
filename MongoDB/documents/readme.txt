
MongoDB 8.0.17 安装说明

软件用途：Database

一、软件安装

1、安装方式
APT安装

2、安装文件
mongodb-install.sh

3、安装目录
/usr/bin

执行文件: /usr/bin/mongod

二、配置文件
1、文件目录
/etc

2、主配置文件
/etc/mongod.conf

三、日志目录
1、日志目录
/data/logs/mongodb

2、日志文件
/data/logs/mongodb/mongod.log

四、控制命令
启动 : systemctl start mongod
关闭 : systemctl stop mongod
重启 : systemctl restart mongod

状态查询 ：systemctl status mongod

控制文件：/usr/lib/systemd/system/mongod.service

五、数据存放目录
/data/mongodb

附：
软件附属信息：
group：mongod
user：mongod

配置文件新格式(YAML)
# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /data/logs/mongodb/mongod.log

# Where and how to store data.
storage:
  dbPath: /data/mongodb

# how the process runs
processManagement:
  timeZoneInfo: /usr/share/zoneinfo
  pidFilePath: /usr/local/mongodb/var/run/mongod.pid

# network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1


配置文件旧格式
# mongod.conf

#数据存放目录
dbpath=/data/mongodb

#连接端口
port=27017

maxConns = 1024

#日志目录
logpath=/data/logs/mongodb/mongodb.log
logappend=true

pidfilepath=/data/mongodb/var/run/mongod.pid

nounixsocket = false
unixSocketPrefix = /data/mongodb/var/run

#访问权限
noauth=true
#auth=true

#守护进程
fork = true

#绑定IP
bind_ip=127.0.0.1


查看状态

#systemctl start mongod

#systemctl status mongod

#systemctl enable mongod

4、更改配置文件
1), 配置文件路径为：/etc/mongod.conf
systemLog, storage

#systemctl restart mongod