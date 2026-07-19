#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "===========================\n"
printf " mongodb-8.0.17 Install   \n"
printf " copyright:www.doitphp.com \n"
printf "===========================\n"
printf "\n\n"

#安装依赖软件包
apt -y update && apt -y install gnupg apt-transport-https

curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor

echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/debian bookworm/mongodb-org/8.0 main" | tee /etc/apt/sources.list.d/mongodb-org-8.0.list
apt -y update

apt -y install mongodb-org

#创建目录
mkdir -m 0755 -p /data/mongodb /data/logs/mongodb
chown -R mongodb:mongodb /data/mongodb /data/logs/mongodb

#更改配置文件
sed -i 's/path: \/var\/log\/mongodb\/mongod.log/path: \/data\/logs\/mongodb\/mongod.log/g' /etc/mongod.conf
sed -i 's/dbPath: \/var\/lib\/mongodb/dbPath: \/data\/mongodb/g' /etc/mongod.conf

#启动程序
systemctl start mongod
systemctl status mongod

systemctl enable mongod
systemctl is-enabled mongod

printf "\n========== mongo install Completed! =======\n\n"
ps aux | grep mongod | grep -v "grep"
printf "============== The End. =============="
