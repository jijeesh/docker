#!/usr/bin/env bash
# This script is used for create virtual hosts on CentOs.
# Created by Jijeesh K A
# Improved by Jijeesh K A
# Feel free to modify it
#   PARAMETERS
#
# $usr          - User
# $dir          - directory of web files
# $servn        - webserver address without www.
# $cname        - cname of webserver
# $SSL_DIR      -  ssl storing locatin
# EXAMPLE
# Web directory = /var/www/
# ServerName    = domain.com
# cname            = devel
#
#
#
# Check if you execute the script as root user
#
# This will check if directory already exist then create it with path : /directory/you/choose/domain.com
# Set the ownership, permissions and create a test index.php file
# Create a vhost file domain in your /etc/httpd/conf.d/ directory.
# And add the new vhost to the hosts.
#
#
if [ "$(whoami)" != 'root' ]; then
    echo "You have to execute this script as root user"
    exit 1;
fi
yum install -y httpd openssl mod_ssl
#if you want to add it dynamically uncomment the bellow lines
#read -p "Enter the server name your want (without www) : " servn
#read -p "Enter a CNAME (e.g. :www or dev for dev.website.com) : " cname
#read -p "Enter the path of directory you wanna use (e.g. : /var/www/, dont forget the /): " dir
#read -p "Enter the user you wanna use (e.g. : apache) : " usr
#read -p "Enter the listened IP for the server (e.g. : *): " listen
servn="example.com"
cname="www"
dir="/var/www/"
user="apache"
listen="*"

if ! mkdir -p $dir$cname_$servn; then
    echo "Web directory already Exist !"
else
    echo "Web directory created with success !"
fi
echo "<?php echo '<h1>$cname $servn</h1>'; ?>" > $dir$cname_$servn/index.php
chown -R $usr:$usr $dir$cname_$servn
chmod -R '755' $dir$cname_$servn
mkdir /var/log/$cname_$servn

alias=$cname.$servn
if [[ "${cname}" == "" ]]; then
    alias=$servn
fi

echo "#### $cname $servn
<VirtualHost $listen:80>
ServerName $servn
ServerAlias $alias
DocumentRoot $dir$cname_$servn
<Directory $dir$cname_$servn>
Options Indexes FollowSymLinks MultiViews
AllowOverride All
Order allow,deny
Allow from all
Require all granted
</Directory>
</VirtualHost>" > /etc/httpd/conf.d/$cname_$servn.conf
if ! echo -e /etc/httpd/conf.d/$cname_$servn.conf; then
    echo "Virtual host wasn't created !"
else
    echo "Virtual host created !"
fi

    # the  certificate
    SSL_DIR="/etc/httpd/conf.d"
    # Set the wildcarded domain
    # we want to use
    DOMAIN="*.$servn"
    # A blank passphrase
    PASSPHRASE=""
    # Set our CSR variables

    SUBJ="/C=US/ST=Connecticut/L=New Haven/commonName=$DOMAIN"
    # Create our SSL directory
    # in case it doesn't exist
    mkdir -p "$SSL_DIR"

    # Generate our Private Key, CSR and Certificate
    openssl genrsa -out "$SSL_DIR/$cname_$servn.key" 2048

    openssl req -new -subj "$SUBJ" -key "$SSL_DIR/$cname_$servn.key" -out $SSL_DIR/$cname_$servn.csr -passin pass:$PASSPHRASE

    openssl x509 -req -days 365 -in "$SSL_DIR/$cname_$servn.csr" -signkey "$SSL_DIR/$cname_$servn.key" -out "$SSL_DIR/$cname_$servn.crt"

    if ! echo -e /etc/httpd/conf.d/$cname_$servn.key; then
        echo "Certificate key wasn't created !"
    else
        echo "Certificate key created !"
    fi
    if ! echo -e /etc/httpd/conf.d/$cname_$servn.crt; then
        echo "Certificate wasn't created !"
    else
        echo "Certificate created !"
    fi

echo "#### ssl $cname $servn
<VirtualHost $listen:443>
SSLEngine on
SSLCertificateFile /etc/httpd/conf.d/$cname_$servn.crt
SSLCertificateKeyFile /etc/httpd/conf.d/$cname_$servn.key
ServerName $servn
ServerAlias $alias
DocumentRoot $dir$cname_$servn
<Directory $dir$cname_$servn>
Options Indexes FollowSymLinks MultiViews
AllowOverride All
Order allow,deny
Allow from all
Satisfy Any
</Directory>
</VirtualHost>" > /etc/httpd/conf.d/ssl.$cname_$servn.conf
    if ! echo -e /etc/httpd/conf.d/ssl.$cname_$servn.conf; then
        echo "SSL Virtual host wasn't created !"
    else
        echo "SSL Virtual host created !"
    fi

echo "======================================"
echo "All works done! You should be able to see your website at http://$servn"
echo "======================================="
echo "docker run -v phalcon:$dir$cname_$servn -p 81:80 -p 444:443 -d centos7/httpd:test"
echo ""
    echo "127.0.0.1 $servn into your system or in dns  /etc/hosts"
    echo " Connect your site with http://$servn:81 https://$servn:444"
if [ "$alias" != "$servn" ]; then
    echo "127.0.0.1 $alias into your system or in dns /etc/hosts"
    echo " Connect your site with http://$alias:81 https://$alias:444"
fi
echo " Connect your site with http://ipaddress:81 https://ipaddress:444"

echo "========================================="
echo "Share the love! <3"
echo "======================================"
echo ""
echo "Wanna contribute to improve this script? Found a bug? "