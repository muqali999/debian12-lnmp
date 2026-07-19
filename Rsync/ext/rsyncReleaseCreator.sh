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

echo "Please input the domain name:"
read -p "Domain name:" domain

scriptfile=$domain"-script-release.sh"
passfile=".cmd/.release/"$domain"_rsyncd.pass"
blockfile=".cmd/.release/"$domain"_exclude.txt"

mkdir -p .cmd/.release
echo "189bae5255c2f4f28b6d0cab43a929e6">$passfile
chmod 0400 $passfile
echo ".svn">$blockfile
echo ".git">$blockfile
chmod 0600 $blockfile

cd .cmd

#create rsyc push shell script
cat >$scriptfile<<EOF
#!/bin/bash
targetip="192.168.1.101"
scriptpath="/www/htdocs/$domain"

passwordfile="$passfile"
excludefile="$blockfile"

cd \$scriptpath
/usr/local/rsync/bin/rsync -arP --delete --password-file=\$passwordfile --exclude-from=\$excludefile * scriptsender@\$targetip::webscript
EOF

chmod 0755 $scriptfile

printf "============== The End. ==============\n"