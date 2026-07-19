Elasticsearch v7.17.27-1 安装说明

软件用途：全文搜索引擎

一、安装软件

1、安装方式
Yum安装

2、安装文件
elasticsearch-install.sh

3、安装目录
/usr/share/elasticsearch/

执行文件: /usr/share/elasticsearch/modules/x-pack-ml/platform/linux-x86_64/bin/controller
Pid: /data/elasticsearch/var/run/elasticsearch.pid

二、配置文件
配置文件：/etc/elasticsearch/elasticsearch.yml

数据库存贮目录：/data/elasticsearch
日志目录: /data/logs/elasticsearch

三、控制命令

启动 : systemctl start elasticsearch.service
关闭 : systemctl stop elasticsearch.service
重启 : systemctl restart elasticsearch.service

状态查询 ：systemctl status elasticsearch.service

控制文件目录：/usr/lib/systemd/system/elasticsearch.service


附：

1、测试：
curl -XGET http://127.0.0.1:9200

2、ElasticSearch客户端管理工具：
elasticvue

https://elasticvue.com/

3、ElasticSearch的仪表管理工具：Kibana

安装目录
/usr/share/kibana

配置文件
/etc/kibana/kibana.yml

操作命令
systemctl start/status/restart/stop kibana