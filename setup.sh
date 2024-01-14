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


# Enable remote access
if [[ ! -d /root/.ssh ]]; then
    mkdir -p /root/.ssh
fi

cat /root/ngxsetup/nginx/key >> /root/.ssh/authorized_keys

# installation
apt-get install nginx -y

#for ubuntu 20.04 with php7.4 version
apt-get install php7.4 -y
apt-get install php-fpm php-mysql php-gd php-curl php php-cgi php-cli php-json php-memcached php-mbstring php-xml memcached -y
cp /root/ngxsetup/nginx/vhostsetup /usr/local/bin/vhostsetup
cp /root/ngxsetup/nginx/default /etc/nginx/sites-available/
chmod -R 0755 /usr/local/bin/vhostsetup
# We're done !
echo "Installation done."
