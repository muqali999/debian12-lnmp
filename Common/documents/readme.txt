一、防火墙配置
1、查看状态
#sudo ufw status verbose

2、关闭防火墙
#sudo systemctl stop ufw

二、网络配置
1、设置网卡
#vi source /etc/network/interfaces

# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug ens32
iface ens32 inet static

address 192.168.8.109
netmask 255.255.255.0
gateway 192.168.8.1


2、设置DNS
#vi /etc/resolv.conf

nameserver 8.8.8.8
nameserver 8.8.4.4

3、重启网络
#systemctl restart networking.service

4、查看IP
#ip address

5、查看网卡
#lspci | grep -i net

6、设置主机名
sudo hostnamectl set-hostname 新主机名
然后重启服务器或网络服务

sudo hostnamectl status 查看主机名等信息


三、关闭selinux服务
注：Debian12默认没有安装selinux

1、查看状态
#sestatus

2、更改配置文件
#vi /etc/sysconfig/selinux

SELINUX=enforcing --> SELINUX=disabled

SELINUXTYPE=targeted --> #SELINUXTYPE=targeted

3、重启服务器
#systemctl restart networking.service


四、软件升级

1、内核升级
修改apt的配置文件 
vim /etc/apt/sources.list (传统)
或
vim /etc/apt/sources.list.d/debian.sources (新)

#apt -y update
#apt -y upgrade
#apt -y full-upgrade

注：国外服务器请慎重使用,搞不好yum升级后，服务器整日宕机。

五、服务器时间

1、查看时区
#date -R

Sun, 27 Apr 2014 01:10:36 +0800

2、更改时区
#timedatectl set-timezone Asia/Shanghai (推荐)
或
#cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime (传统)

注：

3、时间同步
注：时间同步软件为chrony, 默认没有安装，需手动安装

#apt -y install chrony
#timedatectl set-ntp true

#timedateclt

#手动强制更新本地时间
#chronyc -a makestep

六、配置防火墙
注：Debian 12默认没有安装防火墙。需要手动安装， 推荐ufw防火墙，原因操作简单。

# 安装 UFW
sudo apt install ufw

# 启用防火墙
sudo ufw enable

# 查看状态
sudo ufw status verbose

详见：https://www.debian.club/administration/firewall

七、绑定多个IP
配置文件：/etc/network/interfaces

内容(范文)如下：
auto enp0s3
iface enp0s3 inet static
    address 192.168.1.10/24
    gateway 192.168.1.1

auto enp0s3:0
iface enp0s3:0 inet static
    address 192.168.1.11/24

auto enp0s3:1
iface enp0s3:1 inet static
    address 192.168.1.12/24

附：
查内核:	uname -r


八、数字证书远程登陆(ssh key)

注：Debian 12 默认 root用户不支持远程登陆。需要编辑ssh配置文件

#sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
#sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config


1、生成SSH密钥

#ssh-keygen -t rsa

文件目录：.ssh
id_rsa 私钥(client)
id_rsa.pub 公钥(server)

2、配置文件

mv /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

sed -i 's/^#RSAAuthentication yes/RSAAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

systemctl restart sshd


3、客户端
使用 id_rsa 私钥登陆

/etc/nologin - 如果该文件存在，则只允许 root 帐号登录
/etc/hosts.allow and /etc/hosts.deny : 访问控制定义

/etc/hosts.allow 范例如下：

sshd:10.73.13.100 10.75.3.115 10.75.1.59
sshd:ALL:deny