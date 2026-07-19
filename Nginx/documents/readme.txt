
Nginx 安装说明

软件用途：Web Server

一、软件安装

1、安装方式
编译安装

2、安装文件
nginx-Install.sh

3、安装目录
/usr/local/nginx

执行文件: /usr/local/nginx/sbin/nginx
Pid: /usr/local/nginx/var/run/nginx.pid

二、配置文件

1、文件目录
/usr/local/nginx/conf/

2、主配置文件
/usr/local/nginx/conf/nginx.conf

三、代码存放目录设计规划

1、总体规划
/data/www/htdocs/  用于存放web代码
/data/www/crontab/ 用于存放crontab代码
/data/www/cache	用于存放web程序生成的缓存文件
/data/www/tmp	用于存放web相关程序生成的临时文件
/data/logs/nginx/    用于存放代码运行的日志文件

2、具体规划
例：htdocs目录分配
/usr/local/nginx/html/为web服务器默认的文档目录
/data/www/htdocs/项目访问域名

同理crontab，logs目录亦然

四、日志文件
1、默认目录
其默认日志文件目录还要看配置文件具体的设置，如果没有设置则默认：
/data/logs/nginx/
安装程序为nginx创建了一个新的日志目录: /var/log/nginx/ 在设置nginx日志文件时请统一使用此目录

注：
access.log 为访问日志(access_log)
error.log  为错误日志(error_log)

2、目录设置
通过nginx主配置文件来设置
如：
access_log  logs/access.log  main;
关闭访问日志
access_log off;

error_log logs/error.log  main;
关闭错误日志
error_log off;


五、控制命令
启动 : systemctl start nginx
关闭 : systemctl stop nginx
重启 : systemctl restart nginx 或 systemctl reload nginx

状态查询 ：systemctl status nginx

控制文件目录：/etc/systemd/system/nginx.service


附：
软件附属信息：
group：www
user：www

检测nginx配置文件：
/usr/local/nginx/sbin/nginx -t -c /usr/local/nginx/conf/nginx.conf

查nginx版本号
/usr/local/nginx/sbin/nginx -v
/usr/local/nginx/sbin/nginx -V (信息全面)

Apache与Nginx重写规则转换工具网址：
http://www.anilcetin.com/convert-apache-htaccess-to-nginx/

查看CPU核数:
cat /proc/cpuinfo | grep "cpu cores" | wc -l


