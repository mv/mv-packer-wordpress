#!/bin/bash
#
# Amazon Linux v2
# PHP 7.4
# WP 5.8.2
#

sudo yum update -y
sudo yum install amazon-linux-extras -y

# Apache et al
sudo yum install -y     \
    httpd               \
    httpd-tools         \
    mod_ssl             \
    ghostscript         \
    mariadb             \

# PHP
sudo amazon-linux-extras enable php7.4
sudo yum install -y     \
    php                 \
    php-bcmath          \
    php-curl            \
    php-imagick         \
    php-intl            \
    php-json            \
    php-mbstring        \
    php-mysqlnd         \
    php-xml             \
    php-zip             \


# Wordpress: latest
sudo mkdir -p /srv/www

curl -s https://wordpress.org/wordpress-5.8.2.tar.gz \
  | sudo tar xz -C /srv/www

sudo chown -R apache:apache /srv/www


# Apache: enable site WP
sudo /bin/cp \
     /tmp/dev.apache.wordpress.conf \
     /etc/httpd/conf.d/wordpress.conf

# Apache: enable SSL
cd /etc/ssl && sudo ln -snf ../pki/tls/private

sudo /bin/cp \
     /tmp/localhost-selfsigned-cert.pem \
     /etc/pki/tls/certs/

sudo /bin/cp \
     /tmp/localhost-selfsigned-priv.key \
     /etc/pki/tls/private/


sudo /bin/systemctl restart httpd.service


