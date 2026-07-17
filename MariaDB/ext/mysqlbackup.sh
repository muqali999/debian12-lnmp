#!/bin/bash
database="test"

cd /data/backup
newdate=$(date +%Y%m%d%H)
olddate=$(date +%Y%m%d -d '3 days ago')
newfile=$database$newdate".sql"
oldfile=$database$olddate"*.sql"

if [ -s $newfile ]; then
	echo "mysql data has been backuped!"
	exit 0
fi

/usr/local/mysql/bin/mariadb-dump $database > $newfile

if [ -s $oldfile ]; then
	rm -rf $oldfile
fi

printf "success!\n";