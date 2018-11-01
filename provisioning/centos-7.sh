#!/bin/bash

# Turn SELinux off for provisioning
setenforce 0

# Perform updates
yum -y update

# Update timezone
timedatectl set-timezone "Europe/London"

# Enable EPEL & Remi
yum -y install epel-release
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm 

# Install misc
yum -y install git nano gcc-c++ make

# Update firewall rules
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --zone=public --add-servuce=https --permanent
firewall-cmd --reload

# Enable CodeIT repo
cd /etc/yum.repos.d
wget https://repo.codeit.guru/codeit.el`rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)`.repo

# Install Apache 2.4.37
yum install -y httpd
mkdir /etc/httpd/sites-available
mkdir /etc/httpd/sites-enabled
cat <<EOM >>/etc/httpd/conf/httpd.conf
IncludeOptional sites-enabled/*.conf
EOM
systemctl start httpd.service
systemctl enable httpd.service
httpd -v

# Install MariaDB 10.2.18
touch /etc/yum.repos.d/mariadb.repo
cat <<EOM >/etc/yum.repos.d/mariadb.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.2/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOM
rpm --import 
yum -y install mariadb-server
systemctl start mariadb
systemctl enable mariadb
mysql --version

# Install PHP 7.2.11
yum-config-manager --enable remi-php72
yum -y install php php-cli php-common php-pdo php-mysql php-curl php-bcmath php-mbstring php-zip php-dom php-gd php-xdebug
php -v

# Install Composer 1.7.2
EXP_SIG="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACT_SIG="$(php -r "echo hash_file('SHA384', 'composer-setup.php');")"
if [ "$EXP_SIG" != "$ACT_SIG" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
fi
php composer-setup.php --quiet
rm composer-setup.php

# Install Node & NPM
curl -sL https://rpm.nodesource.com/setup_8.x | bash -
yum -y install nodejs
node -v
npm -v
