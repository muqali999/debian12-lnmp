#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "===============================\n"
printf " Elasticsearch v7.17.27-1 Install \n"
printf "   copyright: www.doitphp.com  \n"
printf "===============================\n"
printf "\n\n"

#安装依赖软件包
apt -y update && apt -y install gnupg apt-transport-https

isjava=`whereis java|awk '{print $2}'`
if [ "$isjava" != "/usr/bin/java" ]; then
	[ -d "src" ] || mkdir src
	cd src
	wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb
	dpkg -i jdk-21_linux-x64_bin.deb
	java -version
	cd -
else
	printf "/usr/bin/java already exists.\n"
fi

#添加公钥
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

#设置下载源列表
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
apt -y update

#安装ElasticSearch
apt -y install elasticsearch

#创建目录
if [ ! -s /data/elasticsearch ]; then
	mkdir -m 0755 -p /data/elasticsearch
	chown elasticsearch:elasticsearch -R /data/elasticsearch
fi

if [ ! -s /data/logs/elasticsearch ]; then
	mkdir -m 0755 -p /data/logs/elasticsearch
	chown elasticsearch:elasticsearch -R /data/logs/elasticsearch
fi

if [ -s /var/log/elasticsearch ]; then
	rm -rf /var/log/elasticsearch
fi
ln -s /data/logs/elasticsearch /var/log/elasticsearch

if [ -s /data/elasticsearch/var/run ]; then
	rm -rf /data/elasticsearch/var/run
fi
mkdir -m 0777 -p /data/elasticsearch/var/run
chown elasticsearch:elasticsearch /data/elasticsearch/var/run

#进程ID(PID)
sed -i 's/^d    \/var\/run\/elasticsearch/d    \/data\/elasticsearch\/var\/run/g' /usr/lib/tmpfiles.d/elasticsearch.conf


#设置配置文件

#ES服务器结点名称
sed -i 's/^#node.name: node-1/node.name: node-1/g' /etc/elasticsearch/elasticsearch.yml
#ES服务器IP绑定及端口
sed -i 's/^#network.host: 192.168.0.1/network.host: 0.0.0.0/g' /etc/elasticsearch/elasticsearch.yml
sed -i 's/^#http.port: 9200/http.port: 9200/g' /etc/elasticsearch/elasticsearch.yml
#ES数据存贮目录和日志目录
sed -i 's/^path.data: \/var\/lib\/elasticsearch/path.data: \/data\/elasticsearch/g' /etc/elasticsearch/elasticsearch.yml
sed -i 's/^path.logs: \/var\/log\/elasticsearch/path.logs: \/data\/logs\/elasticsearch/g' /etc/elasticsearch/elasticsearch.yml
#集群结点
sed -i 's/^#cluster.initial_master_nodes: \["node-1", "node-2"\]/cluster.initial_master_nodes: \["node-1"\]/g' /etc/elasticsearch/elasticsearch.yml

#随机启动服务
systemctl daemon-reload

systemctl enable elasticsearch.service
systemctl start elasticsearch.service

curl -XGET http://127.0.0.1:9200

systemctl restart elasticsearch.service

#设置防火墙,开放端口
firewallStatus=`systemctl is-active ufw`
if [ "$firewallStatus" = "active" ]; then
	printf "Add firewall port 9200:";
	sudo ufw allow 9200
fi

ps aux | grep elasticsearch | grep -v "grep"


read -p "Do you need to install Kibana?[y/n]:" isNecessary
if [ "$isNecessary" = "y" ] || [ "$isNecessary" = "Y" ]; then
	#安装kibana
	apt -y install kibana

	#更改Kibana配置
	if [ ! -f /usr/share/kibana/bin/kibana ]; then
		printf "kibana installation failed.\n"
		exit 1
	fi

	sed -i 's/^#server.port: 5601/server.port: 5601/g' /etc/kibana/kibana.yml
	sed -i 's/^#server.host: "localhost"/server.host: "0.0.0.0"/g' /etc/kibana/kibana.yml
	sed -i 's/^#elasticsearch.hosts: \["http:\/\/localhost:9200"\]/elasticsearch.hosts: \["http:\/\/localhost:9200"\]/g' /etc/kibana/kibana.yml
	sed -i 's/^#i18n.locale: "en"/i18n.locale: "zh-CN"/g' /etc/kibana/kibana.yml

	read -p "Please enter the IP or domain name (without http) to access Kibana :" yourKibanaHost
	sed -i 's/^#server.publicBaseUrl: ""/server.publicBaseUrl: "http:\/\/$yourKibanaHost:5601"/g' /etc/kibana/kibana.yml

	systemctl daemon-reload
	systemctl enable kibana.service

	systemctl start kibana.service
	systemctl status kibana.service

	#设置防火墙,开放端口
	if [ "$firewallStatus" = "active" ]; then
		printf "Add firewall port 5601:";
		sudo ufw allow 5601
	fi

	ps aux | grep kibana | grep -v "grep"
fi

printf "============== The End. ==============\n"