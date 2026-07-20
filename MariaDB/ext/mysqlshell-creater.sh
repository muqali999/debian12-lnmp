#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "=============================\n"
printf " mariadb-10.11.11 Shell Script maker\n"
printf " copyright: www.doitphp.com  \n"
printf "=============================\n"
printf "\n\n"

#set mysqldump user
if [ -s /etc/my.cnf ]; then
	isExists=`grep '\[mysqldump\]' /etc/my.cnf  | wc -l`
	if [ "$isExists" != "1" ]; then
		echo "">>/etc/my.cnf
		echo "[mysqldump]">>/etc/my.cnf
	fi	
	echo "user=dump_user">>/etc/my.cnf
	echo "password=c9c3a312089f628ede1bad7f560bcbe9">>/etc/my.cnf
	systemctl restart mysqld.service
	cat /etc/my.cnf
fi

mkdir -m 0666 /data/backup
mkdir -p .cmd
cd .cmd

#create mysql connetc shell script
cat >mysql-connect.sh<<EOF
#!/bin/bash
/usr/local/mysql/bin/mariadb -hlocalhost -ugentleman -p1f066e52329503694f92512c6bcab726
EOF

#create mysqldump shell script
cat >mysql-dump.sh<<EOF
#!/bin/bash
database="test"

newdate=\$(date +%Y%m%d)
dbfile="/root/"\$database\$newdate".sql"

if [ -s \$dbfile ]; then
	echo "mysql backup file is exists!"
	exit 0
fi

/usr/local/mysql/bin/mariadb-dump \$database > \$dbfile

printf "success!\n";
EOF

printf "============== The End. ==============\n"