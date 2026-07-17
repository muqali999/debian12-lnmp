#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "===========================\n"
printf "    Mindoc Install   \n"
printf " copyright:www.doitphp.com \n"
printf "===========================\n"
printf "\n\n"


#检测软件是否安装
if [ -f /usr/local/mindoc/mindoc_linux_amd64 ]; then
    printf "MinDoc is installed.!\n"
	exit 1
fi

#软件包检测
if [ ! -s src ]; then    
    printf "Error: directory src not found.\n"
    exit 1
fi

cd src

if [ ! -f mindoc_linux_amd64.zip ]; then
    printf "the mindoc_linux_amd64.zip is not exists!\n"
	exit 1
fi

#解压软件
unzip mindoc_linux_amd64.zip -d /usr/local/mindoc
cd -

cd /usr/local/mindoc
chmod +x mindoc_linux_amd64


#配置数据库:Sqlite3
sed -i 's/^db_adapter=/#db_adapter=/g' /usr/local/mindoc/conf/app.conf
sed -i 's/^db_host=/#db_host=/g' /usr/local/mindoc/conf/app.conf
sed -i 's/^db_port=/#db_port=/g' /usr/local/mindoc/conf/app.conf
sed -i 's/^db_database=/#db_database=/g' /usr/local/mindoc/conf/app.conf
sed -i 's/^db_username=/#db_username=/g' /usr/local/mindoc/conf/app.conf
sed -i 's/^db_password=/#db_password=/g' /usr/local/mindoc/conf/app.conf

sed -i 's/^#db_adapter=sqlite3/db_adapter=sqlite3/g' /usr/local/mindoc/conf/app.conf
sed -i 's/^#db_database=.\/database\/mindoc.db/db_database=.\/database\/mindoc.db/g' /usr/local/mindoc/conf/app.conf


#软件安装
./mindoc_linux_amd64 install


#安装服务
./mindoc_linux_amd64 service install
systemctl start mindocd


#防火墙端口设置
sudo ufw allow 8181
sudo ufw reload
sudo ufw status numbered

printf "\n========== Docker install Completed! ========\n\n"

ps aux | grep docker
docker ps

echo "Access port: 8181, Default administrator username: admin, Password: 123456"

printf "============== The End. ==============\n"