#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "============================\n"
printf " Debian 13.x Init configure	\n"
printf " copyright: www.doitphp.com \n"
printf "============================\n"
printf "\n\n"

#configure selinux service
printf "\ncheck selinux status :\n"
if [ -s /etc/selinux/config ]; then
	sestatus | grep 'SELinux status' | awk '{print $3}'
else
	printf "\nSELinux is not installed.\n"
fi

if [ -s /etc/sysconfig/selinux ]; then
	#configure selinx
	printf "\nconfigure selinx... \n"

	seStatus=`sestatus | grep 'SELinux status' | awk '{print $3}'`
	if [ "$seStatus" != "disabled" ]; then
		sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
		sed -i 's/SELINUXTYPE=targeted/#SELINUXTYPE=targeted/g' /etc/sysconfig/selinux
	fi

	printf "\nThe result of selinx configure file is :\n\n"
	cat /etc/sysconfig/selinux
fi

if [ -s /etc/selinux/config ]; then
	#configure selinx
	printf "\nconfigure selinx... \n"

	seStatus=`sestatus | grep 'SELinux status' | awk '{print $3}'`
	if [ "$seStatus" != "disabled" ]; then
		sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
		sed -i 's/SELINUXTYPE=targeted/#SELINUXTYPE=targeted/g' /etc/selinux/config
	fi

	printf "\nThe result of selinx configure file is :\n\n"
	cat /etc/selinux/config
fi

printf "\n"
read -p "Do you want continue?[y/n]:" iscontinue01
if [ "$iscontinue01" = "n" ] || [ "$iscontinue01" = "N" ]; then
    printf "Just finished.\n"
    exit 1
fi

if [ -s /etc/ufw/ufw.conf ]; then
	printf "Configuring The Firewall...\n"

	#当防火墙关闭时,启动防火墙
	if systemctl is-active ufw; then
		printf "Firewall is running... \n"
	else
		printf "Firewall is not running! Now start the firewall so that the port settings can be completed\n"
		systemctl start ufw
	fi

	printf "\ncheck firewalld status :\n"
	sudo ufw status verbose

	printf "\n"
	read -p "Do you want to configure firewalld?[y/n]:" isfirewalld
	if [ "$isfirewalld" = "y" ] || [ "$isfirewalld" = "Y" ]; then
		read -p "Do you want to open port 3036 for mysql?[y/n]:" isopen3036
		if [ "$isopen3036" = "y" ] || [ "$isopen3036" = "Y" ]; then
			hasSet=`sudo ufw status verbose | grep 3036 | wc -l`
			if [ "$hasSet" -ge "1" ]; then
				sudo ufw allow 3036
			fi
		fi

		read -p "Do you want to open port 80 for http?[y/n]:" isopen80
		if [ "$isopen80" = "y" ] || [ "$isopen80" = "Y" ]; then
			hasSet=`sudo ufw status verbose | grep 80 | wc -l`
			if [ "$hasSet" -ge "1" ]; then
				sudo ufw allow 80
			fi
		fi

		read -p "Do you want to open port 443 for https?[y/n]:" isopen443
		if [ "$isopen443" = "y" ] || [ "$isopen443" = "Y" ]; then
			hasSet=`sudo ufw status verbose | grep 443 | wc -l`
			if [ "$hasSet" -ge "1" ]; then
				sudo ufw allow 443
			fi
		fi

		read -p "Do you want to open port 873 for rsync?[y/n]:" isopen873
		if [ "$isopen873" = "y" ] || [ "$isopen873" = "Y" ]; then
			hasSet=`sudo ufw status verbose | grep 873 | wc -l`
			if [ "$hasSet" -ge "1" ]; then
				sudo ufw allow 873
			fi
		fi

		#chrony时间同步端口
		hasSet=`sudo ufw status verbose | grep "123/udp" | wc -l`
		if [ "$hasSet" != "1" ]; then
			sudo ufw allow ntp
		fi

		printf "\n"
		read -p "Do you want to restart firewalld?[y/n]:" isrestart
		if [ "$isrestart" = "y" ] || [ "$isrestart" = "Y" ]; then
			sudo ufw reload
		fi
	fi
fi

printf "\n"
read -p "Do you want continue?[y/n]:" iscontinue02
if [ "$iscontinue02" = "n" ] || [ "$iscontinue02" = "N" ]; then
    printf "Just finished.\n"
    exit 1
fi

#configure timezone and rsync time online
printf "\nconfigure timezone :\n"
hasTimeZoneSet=`date -R | grep "+0800" | wc -l`
if [ "$hasTimeZoneSet" != "1" ]; then
	#cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	timedatectl set-timezone Asia/Shanghai
fi


##
## 服务器时间同步设置
##

timedatectl set-ntp true
apt remove systemd-timesyncd

printf "\nInstall chrony...\n"
ischrony=`whereis chronyd | awk '{print $2}'`
if [ "$ischrony" = "" ]; then
    apt -y install chrony
	systemctl start chrony.service
	systemctl status chrony.service
	systemctl enable chrony.service
fi

#设置chrony配置文件
if [ -f /etc/chrony.conf ]; then
	rm -rf /etc/chrony.conf
fi
cat >/etc/chrony.conf<<EOF
# Use public servers from the pool.ntp.org project.
server time1.google.com iburst
server time1.google.com iburst
server time3.google.com iburst
server time4.google.com iburst

# Use NTP servers from DHCP.
sourcedir /run/chrony-dhcp

# Record the rate at which the system clock gains/losses time.
driftfile /var/lib/chrony/drift

# Allow the system clock to be stepped in the first three updates
# if its offset is larger than 1 second.
makestep 1.0 3

# Enable kernel synchronization of the real-time clock (RTC).
rtcsync

# Enable hardware timestamping on all interfaces that support it.
hwtimestamp *

# Increase the minimum number of selectable sources required to adjust
# the system clock.
#minsources 2

# Allow NTP client access from local network.
#allow 192.168.0.0/16

# Serve time even if not synchronized to a time source.
local stratum 10

# Require authentication (nts or key option) for all NTP sources.
#authselectmode require

# Specify file containing keys for NTP authentication.
keyfile /etc/chrony.keys

# Save NTS keys and cookies.
ntsdumpdir /var/lib/chrony

# Insert/delete leap seconds by slewing instead of stepping.
#leapsecmode slew

# Get TAI-UTC offset and leap seconds from the system tz database.
leapsectz right/UTC

# Specify directory for log files.
logdir /var/log/chrony

# Select which information is logged.
#log measurements statistics tracking

EOF

printf "\nThe result of chrony :\n"
systemctl restart chrony.service

#手动同步时间
chronyc sourcestats
chronyc makestep
timedatectl

printf "\n*********************\n"

printf "\n"
read -p "Do you want continue?[y/n]:" iscontinue03
if [ "$iscontinue03" = "n" ] || [ "$iscontinue03" = "N" ]; then
    printf "Just finished.\n"
    exit 1
fi

#set vim editor 1tab=4space
apt -y install vim
printf "\nconfigure vim editor 1tab=4space :\n"

if [ ! -f /root/.vimrc ]; then
cat >/root/.vimrc<<EOF
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
set nu
set autoindent
set cindent
EOF
fi

#close Control-Alt-Deletepressed shutdown server
if [ -f /etc/init/control-alt-delete.conf ]; then
  rm -rf /etc/init/control-alt-delete.conf
fi

isExists=`grep '* soft nofile 65535' /etc/security/limits.conf | wc -l`
if [ "$isExists" != "1" ]; then
cat >> /etc/security/limits.conf <<EOF
* soft nproc 65535
* hard nproc 65535
* soft nofile 65535
* hard nofile 65535
EOF
fi

if [ -f /etc/init/control-alt-delete.conf ]; then
  rm -rf /etc/init/control-alt-delete.conf
fi


#设置任务计划: 每小时手动执行一次时间同步
crontabFile="/etc/crontab"
crontabContent="/usr/bin/chronyc makestep"
if grep -q "$crontabContent" "$crontabFile"; then
	echo "/etc/crontab has configured already"
else
	echo '0 * * * * root /usr/bin/chronyc makestep /dev/null 2>&1' >> /etc/crontab
fi
printf "\ncat /etc/crontab :\n"
cat /etc/crontab

printf "\n*********************\n"

#开通root的ssh远程登录
printf "\n"
read -p "Do you want to enable root SSH remote login?[y/n]:" isOpenRoot
if [ "$isOpenRoot" = "y" ] || [ "$isOpenRoot" = "Y" ]; then
	sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
	sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
	printf "\nSSH remote login for root has been successfully enabled.\n"
fi

#Shell命令更名
printf "\nCreate common Linux alias command :\n"

cat <<EOF >>.bashrc
alias ll='ls -l'
alias la='ls -la'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias home='cd ~'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias reboot='systemctl reboot'
alias update='apt update && apt upgrade'
EOF

cat <<EOF >>/root/.bashrc
alias ll='ls -l'
alias la='ls -la'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias home='cd ~'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias reboot='systemctl reboot'
alias update='apt update && apt upgrade'
EOF

printf "\nYou need to manually execute the command: source .bashrc and source /root/.bashrc\n"

printf "============== The End. ==============\n"