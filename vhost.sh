#!/usr/bin/env bash

[[ "$(whoami)" != 'root' ]] &&
{
    echo "This script requires sudo privileges"
    exit 1;
}

user="www-data"
group="www-data"
rootpath="/var/www/"

sitesavailable="/etc/apache2/sites-available/"
sitesenabled="/etc/apache2/sites-enabled/"

domain="$1"
relativedocroot="$2"

[[ -z "$domain" ]] &&
{
    read -p "Domain: " domain
}

[[ -z "$relativedocroot" ]] &&
{
    read -p "Document Root: " relativedocroot
}

availableconf="$sitesavailable$domain.conf"
enabledconf="$sitesenabled$domain.conf"
absolutedocroot="$rootpath$relativedocroot"

[[ -e "$availableconf" ]] &&
{
    echo "vhost already created."
    exit 1;
}

[[ ! -d "$absolutedocroot" ]] &&
{
    echo "Document root doesn't exist."
    exit 1;
}

if ! cat << EOF > $availableconf
<VirtualHost *:80>
    ServerName $domain
    ServerAlias www.$domain
    DocumentRoot $absolutedocroot
    <Directory $absolutedocroot>
            Options Indexes FollowSymLinks MultiViews
            AllowOverride all
            Require all granted
    </Directory>
    ErrorLog /var/log/apache2/$domain-error.log
    CustomLog /var/log/apache2/$domain-access.log combined
</VirtualHost>
EOF
then
    echo "error creating vhost."
else
    echo "success, new vhost created."
fi

cat << EOF >> /etc/hosts
127.0.0.1       $domain
EOF

ln -s "$availableconf" "$enabledconf"
systemctl restart apache2.service
