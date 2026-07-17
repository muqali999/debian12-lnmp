#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "==============================\n"
printf " Debian 12.x 64位 view information \n"
printf "  copyright: www.doitphp.com  \n"
printf "==============================\n"
printf "\n\n"


#查看服务器操作系统信息
printf "\nSystem Version:"
lsb_release -a

cat /etc/os-release
cat /etc/debian_version

printf "\nSystem Bit:"
getconf LONG_BIT

printf "\nLinux Core:"
uname -r

printf "\n"
read -p "Do you want continue?[y/n]:" iscontinue01
if [ "$iscontinue01" = "n" ] || [ "$iscontinue01" = "N" ]; then
    printf "Just finished.\n"
    exit 1
fi

#查看CPU, 内存, 硬盘信息
printf "\nCPU information:\n"
cat /proc/cpuinfo

printf "\nCPU Core Num:\n"
cat /proc/cpuinfo | grep "cpu cores" | wc -l

printf "\n"
read -p "Do you want continue?[y/n]:" iscontinue02
if [ "$iscontinue02" = "n" ] || [ "$iscontinue02" = "N" ]; then
    printf "Just finished.\n"
    exit 1
fi

printf "\nMemery (unit:M):\n"
free -m

printf "\nMemery (unit:G):\n"
free -g

printf "\nDisk information:\n"
df -h

printf "\n"
read -p "Do you want continue?[y/n]:" iscontinue03
if [ "$iscontinue03" = "n" ] || [ "$iscontinue03" = "N" ]; then
    printf "Just finished.\n"
    exit 1
fi

#查看网络配置信息
printf "\ncheck ip configure information:\n"
ip address

printf "\ncheck servername information :\n"
cat /etc/resolv.conf

printf "\ncheck network information :\n"
cat /etc/network/interfaces

#检测DNS解析
nslookup google.com

printf "\n"
read -p "Do you want continue?[y/n]:" iscontinue04
if [ "$iscontinue04" = "n" ] || [ "$iscontinue04" = "N" ]; then
    printf "Just finished.\n"
    exit 1
fi

#系统语言, 时区设置
printf "\ncheck system language :\n"
locale | grep LANG

printf "\ncheck system timezone :\n"
date -R

systemctl status systemd-timesyncd
timedatectl status


printf "\n"
read -p "Do you want continue?[y/n]:" iscontinue05
if [ "$iscontinue05" = "n" ] || [ "$iscontinue05" = "N" ]; then
    printf "Just finished.\n"
    exit 1
fi

#查看SELinux配置信息
printf "\ncheck selinux status :\n"
if [ -s /etc/selinux/config ]; then
	sestatus | grep 'SELinux status' | awk '{print $3}'
else
	printf "\nSELinux is not installed.\n"
fi

printf "\n"
read -p "Do you want continue?[y/n]:" iscontinue06
if [ "$iscontinue06" = "n" ] || [ "$iscontinue06" = "N" ]; then
    printf "Just finished.\n"
    exit 1
fi

isSudo=`whereis sudo|awk '{print $2}'`
if [ "$isSudo" = "" ]; then
    apt -y install sudo
fi

#查看系统防火墙状态
if [ -s /etc/ufw/ufw.conf ]; then
	printf "\ncheck firewall status :\n"
	sudo ufw status verbose
else
	printf "\nufw(firewall) is not installed.\n"
fi

printf "\n"
read -p "Do you want continue?[y/n]:" iscontinue07
if [ "$iscontinue07" = "n" ] || [ "$iscontinue07" = "N" ]; then
    printf "Just finished.\n"
    exit 1
fi

#查看当前进程和网络端口
printf "\ncat ps aux :\n"
ps aux

printf "\n"
read -p "Do you want continue?[y/n]:" iscontinue08
if [ "$iscontinue08" = "n" ] || [ "$iscontinue08" = "N" ]; then
    printf "Just finished.\n"
    exit 1
fi

isNetstat=`whereis netstat|awk '{print $2}'`
if [ "$isNetstat" = "" ]; then
    apt -y install net-tools
fi
printf "\nnetstat -nltp :\n"
netstat -nltp

printf "\n"
read -p "Do you want continue?[y/n]:" iscontinue09
if [ "$iscontinue09" = "n" ] || [ "$iscontinue09" = "N" ]; then
    printf "Just finished.\n"
    exit 1
fi

#查看开机启动服务配置信息
printf "\ncat /etc/rc.local :\n"
if [ -f /etc/rc.local ]; then
	cat /etc/rc.local
else
	printf "\nThe file: /etc/rc.local is not exists.\n"
fi

printf "\n"
read -p "Do you want continue?[y/n]:" iscontinue10
if [ "$iscontinue10" = "n" ] || [ "$iscontinue10" = "N" ]; then
    printf "Just finished.\n"
    exit 1
fi

#查看计划任务配置信息
printf "\ncat /etc/crontab :\n"
cat /etc/crontab

printf "============== The End. ==============\n"