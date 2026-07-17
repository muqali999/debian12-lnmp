#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "===========================\n"
printf "   Laravel Install	   \n"
printf "copyright: www.doitphp.com \n"
printf "===========================\n"
printf "\n\n"

#检查composer是否安装
hasInstalled=`whereis composer|awk '{print $2}'`
if [ "$hasInstalled" = "" ]; then
    printf "Error: Composer installation path not found!\n"
    exit 1
fi

#自定义项目路径
PROJECT_PATH="/data/www/htdocs/treasure/"

#检测项目路径
if [ ! -d "$PROJECT_PATH" ]; then
    printf "Error: Project directory path does not exist!\n"
    exit 1
fi
cd $PROJECT_PATH


#输入项目名称
echo "Please input the project name:"
read -p "Project name:" PROJECT_NAME

if [ -d "$PROJECT_NAME" ]; then
	printf "Error: The project name already exists!\n"
	exit 1
fi

#执行命令：创建项目
composer create-project laravel/laravel $PROJECT_NAME

#安装编辑器代码提示插件
cd $PROJECT_NAME
composer require --dev barryvdh/laravel-ide-helper

php artisan ide-helper:generate
php artisan ide-helper:models -RW
php artisan ide-helper:meta

#安装调试(测试)插件
composer require fruitcake/laravel-debugbar --dev

#配置Debugbar功能是否开启
echo '# 开启（true）/关闭（false） Debugbar功能' >> .env
echo 'DEBUGBAR_ENABLED=false' >> .env

#安装API路由配置
php artisan install:api

#设置跨域访问
php artisan config:publish cors


printf " === Laravel Project install complete. === \n\n"