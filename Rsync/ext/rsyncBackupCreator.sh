#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

printf "\n"
printf "=============================\n"
printf " Rsyc Shell Script maker     \n"
printf " copyright: www.doitphp.com  \n"
printf "=============================\n"
printf "\n\n"

if [ ! -f /usr/local/rsync/bin/rsync ]; then
    printf "Error: rysnc has not installed! Please install nginx first.\n"
    exit 1
fi

echo "Please input the project name:"
read -p "Project name:" project

scriptfile=$project"-data-backup.sh"
passfile=".cmd/.backup/"$project"_rsyncd.pass"
datadir="/home/webbackup/"$project

mkdir -p .cmd/.backup
echo "8683772dc32285552ed132ef816c6a42">$passfile
chmod 0400 $passfile

if [ ! -s /www/crontab ]; then
	mkdir -p /www/crontab
	chown www:www -R /www/crontab
fi
cd /www/crontab
mkdir -p $datadir
chmod 0777 -R $datadir

#create rsyc push shell script
cat >$scriptfile<<EOF
#!/bin/bash

targetip="192.168.1.101"
passwordfile="$passfile"
prefix="$project"

cd /home/webbackup/$project
/usr/local/rsync/bin/rsync -azP --password-file=\$passwordfile datatrustee@\$targetip::databackup

#remove old data
olddate=\$(date +%Y%m%d -d '3 days ago')
oldfile=\$prefix\$olddate"*.sql"

if [ -s \$oldfile ]; then
	rm -rf \$oldfile
fi
EOF

chmod 0755 $scriptfile

printf "============== The End. ==============\n"