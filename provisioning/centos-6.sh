#!/bin/bash

echo "Setting up secure iptables"
# Flush all current rules from iptables
iptables -F

# Drop null packets
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# Reject syn-flood attacks
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# Allow SSH connections on tcp port 22
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Set default policies for INPUT, FORWARD and OUTPUT chains
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Set access for localhost
iptables -A INPUT -i lo -j ACCEPT

# Accept packets belonging to established and related connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Save settings
/sbin/service iptables save
/sbin/service iptables restart

# List rules
echo "iptables setup"
iptables -L -v

echo "Adding EPEL repo"
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh epel-release-6*.rpm

echo "Adding REMI repo"
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm 
rpm -Uvh remi-release-6*.rpm

echo "Enabling EPEL & REMI repo"
yum install -y yum-utils
yum-config-manager --enable remi
yum-config-manager --enable remi-php71
yum-config-manager --enable epel
yum update

echo "Adding ports 80 & 443 to iptables"
iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
iptables -I INPUT 1 -p tcp --dport 443 -j ACCEPT
service iptables save


echo "Installing Apache"
yum install -y httpd httpd-tools


echo "Adding Apache service to autostart"
chkconfig httpd on

# symlink mounted shared folder to webroot
echo "Mounting webroot"
if [ -d /vagrant ]
then
	ln -s /vagrant/* /var/www/
fi

# install MySQL
echo "Installing MySQL Server"
yum install -y mysql-server
service mysqld start

# enter root password [ ]
# set root password? [y]
# set password [secret]
# confirm password [secret]
# remove anonymous users? [y]
# disallow root login remotely? [y]
# remove test database and access to it? [y]
# reload privilege tables? [y]
echo "Running MySQL secure installation"
/usr/bin/mysql_secure_installation <<EOF	

y
secret
secret
y
y
y
y
EOF

echo "Adding MySQL service to autostart"
chkconfig mysqld on

# set ownership on PHP sessions dir
if [ -d /var/lib/php/session ]
then
	chown -R vagrant: /var/lib/php/session
fi

echo "Installing PHP and common modules"
yum install -y php php-cli php-common php-devel php-gd php-imap php-mbstring php-mcrypt php-mssql php-mysqlnd php-pdo php-pear php-pecl-apc php-pecl-igbinary php-pecl-memcache php-pecl-memcached php-pecl-ssh2 php-soap php-tidy php-xml 

echo "Installing Image Magick"
yum install -y ImageMagick-devel 

echo "Installing XDebug dependencies"
yum install -y gcc gcc-c++ autoconf automake

echo "Installing XDebug"
pecl install Xdebug

echo "Ensuring XDebug is executable"
chmod +x /usr/lib64/php/modules/xdebug.so

echo "[xdebug]" >> /etc/php.ini
echo "zend_extension=/usr/lib64/php/modules/xdebug.so" >> /etc/php.ini

echo "Installing Imagick extension"
pecl install imagick

echo "php installed"

# Install composer
echo "Installing Composer"
wget https://raw.githubusercontent.com/composer/getcomposer.org/f3333f3bc20ab8334f7f3dada808b8dfbfc46088/web/installer -O - -q | php -- --quiet
mv composer.phar /usr/local/bin/composer

#Fixing slow curl requests (ipv6 resolving timeouts causing issue)
#See: https://github.com/mitchellh/vagrant/issues/1172
if [ ! "$(grep single-request-reopen /etc/resolv.conf)" ]
then 
	echo 'options single-request-reopen' >> /etc/resolv.conf && service network restart
fi

echo 'installing and configuring NTP'
yum install -y wget ntp
chkconfig ntpd on
ntpdate pool.ntp.org
/etc/init.d/ntpd start
# Set timezone
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/UTC /etc/localtime
echo 'NTP is setup and configured'
echo 'Below should be the correct date:'
date
# Replace centos pool with regular NTP pool
sed -i 's/centos.pool.ntp.org/pool.ntp.org iburst/g' /etc/ntp.conf
# Add this to not fail on big time gaps ( VMs that resume/pause )
echo "tinker panic 0" >> /etc/ntp.conf
# Create a script to update time.
cat >/usr/bin/updatetime <<EOL
/etc/init.d/ntpd stop
ntpdate pool.ntp.org
/etc/init.d/ntpd start
EOL
# now we can just run "updatetime" to restart and sync time servers:
chmod +x /usr/bin/updatetime

# change ownership of logs
chown -R vagrant:vagrant /var/log/

echo "Starting Apache"
service httpd restart
