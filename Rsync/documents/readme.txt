
Rsync v3.4.1 安装说明

软件用途：多台Linux Server之间的数据同步

一、软件安装

1、安装方式
编译安装

2、安装文件
rsync-install.sh

3、安装目录
/usr/local/rsync

执行文件: /usr/local/rsync/bin/rsync
Pid: /usr/local/rsync/var/run/rsyncd.pid

二、配置文件
1、文件目录
/usr/local/rsync/etc

2、主配置文件
/usr/local/rsync/etc/rsyncd.conf

3、用户配置文件(帐号密码)
/usr/local/rsync/etc/rsyncd.pass

三、日志目录
1、日志目录
/data/logs/rsync

2、日志文件
/data/logs/rsync/rsyncd.log

四、控制命令
启动 : systemctl start rsyncd.service
关闭 : systemctl stop rsyncd.service
重启 : systemctl restart rsyncd.service

状态查询 ：systemctl status rsyncd.service

控制文件目录：/etc/systemd/system/rsyncd.service


附：
软件附属信息：
group：nobody
user：nobody

1、推送文件至某服务器
	cd /www/xx;
	rsync -arP --delete --password-file=/xx/user.pass --exclude-from=/xx/not_sync_list.txt * username@10.50.201.187::blockname;
	
2、从某服务器上下载文件
	/usr/local/rsync/bin/rsync -azP --password-file=/xx/sitename.pass goldenman@10.50.201.98::video /www/video;
注：/www/video 为下载后文件存放的目录

3、rsync无法实现chkconfig自动启动，需要在/etc/rc.local中加入如下命令
/usr/local/rsync/bin/rsync --daemon --config=/usr/local/rsync/etc/rsyncd.conf

4、shell实例
(1)、文件推送
cd /www/htdocs/www.mydomains.com
/usr/local/rsync/bin/rsync -arP --delete --password-file=/path/rsyncd.pass --exclude-from=/path/notsync_list.txt * scriptsender@192.168.10.211::webscript;
(2)、文件下载
/usr/local/rsync/bin/rsync -azP --password-file=/path/rsyncd.pass datatrustee@192.168.10.198::databackup /home/webbackup

5、自定义端口
/usr/local/rsync/bin/rsync -arP --port=自定义端口 --delete --password-file=/path/rsyncd.pass --exclude-from=/path/notsync_list.txt * scriptsender@192.168.10.211::webscript;