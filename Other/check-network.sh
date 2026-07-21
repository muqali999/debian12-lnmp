#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "==================================\n"
printf " Debian 12.x 64位 check network \n"
printf "  copyright: www.doitphp.com  \n"
printf "==================================\n"
printf "\n\n"

# 显示本机 IP 地址信息
echo "========================================"
echo "本机 IP 地址信息"
echo "========================================"

if command -v ip >/dev/null 2>&1; then
    ip address show
else
    echo "错误：系统中未找到 ip 命令。"
    exit 1
fi

echo

# 检查 networking 服务状态
networking_status="$(systemctl is-active networking 2>/dev/null)"
systemd_networkd_status="$(systemctl is-active systemd-networkd 2>/dev/null)"

echo "========================================"
echo "networking 服务状态"
echo "========================================"
echo "$networking_status"
echo

echo "========================================"
echo "systemd-networkd 服务状态"
echo "========================================"
echo "$systemd_networkd_status"
echo

if [ "$networking_status" = "active" ]; then

    echo "========================================"
    echo "/etc/network/interfaces 文件内容"
    echo "========================================"
    
    if [ -f /etc/network/interfaces ]; then
        cat /etc/network/interfaces
    else
        echo "文件不存在：/etc/network/interfaces"
    fi
fi

if [ "$systemd_networkd_status" = "active" ]; then

    echo "========================================"
    echo "目录：/etc/systemd/network/"
    echo "========================================"

    if [ -d /etc/systemd/network ]; then
        ls -la /etc/systemd/network/
    else
        echo "目录不存在：/etc/systemd/network/"
    fi

    echo

    echo "========================================"
    echo "目录：/run/systemd/network/"
    echo "========================================"

    if [ -d /run/systemd/network ]; then
        ls -la /run/systemd/network/
    else
        echo "目录不存在：/run/systemd/network/"
    fi
fi