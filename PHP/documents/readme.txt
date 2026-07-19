
PHP v8.5.8 安装说明

软件用途：执行PHP文件

一、软件安装

1、安装方式
编译安装

2、安装文件          
php-install.sh

3、安装目录
/usr/local/php

执行文件: /usr/local/php/bin/php
Pid: /usr/local/php/usr/local/php/var/run/php-fpm.pid


二、配置文件
1、文件目录
/usr/local/php/etc

2、主配置文件
/usr/local/php/etc/php.ini
/usr/local/php/etc/php-fpm.conf

三、PHP扩展目录
/usr/local/php/lib/php/extensions/no-debug-zts-20250925

四、控制命令
启动 : systemctl start php-fpm
关闭 : systemctl stop php-fpm
重启 : systemctl restart php-fpm

状态查询 ：systemctl status php-fpm

控制文件目录：/etc/systemd/system/php-fpm

五、运行日志
日志目录：/data/logs/php
错误日志：/data/logs/php/error.log
慢日志：/data/logs/php/slowlog.log

附：
软件附属信息：
group：www
user：www

在CLI环境下执行某PHP文件：
/usr/local/php/bin/php -f /xx/phpfilepath.php

查询所使用的PHP扩展：
/usr/local/php/bin/php -m

查询PHP版本信息：
/usr/local/php/bin/php -v

查询PHP的配置文件路径
/usr/local/php/bin/php --ini


如何使用php-fpm使用unixsocket
更改配置文件
(1)、php-fpm.conf
将
listen = 127.0.0.1:9000
更改为：
listen = /usr/local/php/var/run/php-fpm.sock
listen.mode = 0766

(2)、nginx.conf
将
fastcgi_pass   127.0.0.1:9000;
更改为：
fastcgi_pass   unix:/usr/local/php/var/run/php-fpm.sock;

六、集成扩展
redis、swoole、uuid、yaml、mongodb、amqp(RabbitMQ)、imagick、xhprof

仅有mongodb、amqp(RabbitMQ)、imagick、xhprof扩展根据需要自行安装。可以根据业务需要，酌情开启。

附：
xhprof资料网址
https://github.com/longxinH/xhprof


PHP8.5.8

编译参数 （2020-07-19）
./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --with-fpm-systemd --with-fpm-acl --enable-cgi --with-pcre-jit --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-pgsql --with-pdo-pgsql --with-pdo-sqlite --enable-gd --with-external-gd=/usr/local --with-freetype=/usr/local --with-jpeg=/usr/local --with-webp --with-avif --enable-gd-jis-conv --with-xpm --with-zlib --with-bz2 --with-zip --with-openssl --with-sodium --with-password-argon2 --enable-bcmath --with-curl --enable-sockets --enable-soap --with-ldap --with-ldap-sasl --enable-ipv6 --with-iconv --enable-mbstring --with-gettext --enable-intl --enable-calendar --enable-fileinfo --enable-exif --with-xsl --with-tidy --with-ffi --enable-zts --enable-pcntl --enable-posix --enable-shmop --enable-sysvmsg --enable-sysvsem --enable-sysvshm --without-pear --disable-debug --disable-rpath --enable-shared=yes --with-pic