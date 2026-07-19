RabbitMQ V4.2.2 安装说明

软件用途：消息队列服务软件

一、安装软件

1、安装方式
APT安装

2、安装文件
rabbitmq-install.sh

3、安装目录
/usr/sbin/

执行文件: /usr/sbin/rabbitmq-server
Pid: /var/run/rabbitmq/pid

二、配置文件

一般情况下，RabbitMQ的默认配置就足够了。如果希望特殊设置的话，有两个途径：
一个是环境变量的配置文件 rabbitmq-env.conf ；
一个是配置信息的配置文件 rabbitmq.config；
注意，这两个文件默认是没有的，如果需要必须自己创建。

rabbitmq-env.conf
这个文件的位置是确定和不能改变的，位于：/etc/rabbitmq目录下（这个目录需要自己创建）。
文件的内容包括了RabbitMQ的一些环境变量，常用的有：
#RABBITMQ_NODE_PORT=    //端口号
#HOSTNAME=
RABBITMQ_NODENAME=mq
RABBITMQ_CONFIG_FILE=        //配置文件的路径
RABBITMQ_MNESIA_BASE=/rabbitmq/data        //需要使用的MNESIA数据库的路径
RABBITMQ_LOG_BASE=/rabbitmq/log        //log的路径
RABBITMQ_PLUGINS_DIR=/rabbitmq/plugins    //插件的路径

具体的列表见：http://www.rabbitmq.com/configure.html#define-environment-variables

rabbitmq.config
这是一个标准的erlang配置文件。它必须符合erlang配置文件的标准。
它既有默认的目录，也可以在rabbitmq-env.conf文件中配置。

文件的内容详见：http://www.rabbitmq.com/configure.html#config-items


监控

主要参考官方文档：http://www.rabbitmq.com/management.html

RabbitMQ提供了一个web的监控页面系统，这个系统是以Plugin的方式进行调用的。

首先，在rabbitmq-env.conf中配置好plugins目录的位置：RABBITMQ_CONFIG_FILE

将监控页面所需要的plugin下载到plugins目录下，这些plugin包括：
  mochiweb
  webmachine
  rabbitmq_mochiweb
  amqp_client
  rabbitmq_management_agent
  rabbitmq_management
下载路径位于：http://www.rabbitmq.com/plugins.html#rabbitmq_management 

三、控制命令

启动 : systemctl start rabbitmq-server.service
关闭 : systemctl stop rabbitmq-server.service
重启 : systemctl restart rabbitmq-server.service

状态查询 ：systemctl status rabbitmq-server.service

控制文件目录：/usr/lib/systemd/system/rabbitmq-server.service

附：
rabbitmqctl list_queues

官方gighub
https://github.com/rabbitmq/