#!/bin/bash
# Variables here
VER=$(lsb_release  -r | awk '{print $2}' | cut -d . -f1)

# function 1
check_user () {
if [[ "$EUID" -ne 0 ]]; then
	echo -e "Sorry, you need to run this as root"
	exit 1
fi
}
# function 2
check_pwd () {
if [ "$PWD" != "/root/ngxsetup" ]; then
	echo -e "your pwd should be /root/ngxsetup to run this script. Please clone this git in /root"
	exit 1
fi
}

check_user
check_pwd

# generate temp ssl 
openssl req -subj '/CN=example.com/O=Temp SSL/C=IN' -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt

# Enable remote access
if [[ ! -d /root/.ssh ]]; then
    mkdir -p /root/.ssh
fi

cat /root/ngxsetup/nginx/key >> /root/.ssh/authorized_keys

# installation
apt-get install nginx -y

#for ubuntu 20.04 with php7.4 version
apt install php7.4-{fpm,common,mysql,xml,xmlrpc,curl,gd,imagick,cli,dev,imap,mbstring,opcache,soap,zip} unzip -y
cp /root/ngxsetup/nginx/default /etc/nginx/sites-available/
cp /root/ngxsetup/nginx/defaultssl /etc/nginx/sites-available/
cp /root/ngxsetup/nginx/vhostsetup /usr/local/bin/vhostsetup
chmod -R 0755 /usr/local/bin/vhostsetup
# We're done !
echo "Installation done."
