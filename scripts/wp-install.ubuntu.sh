

#
# https://ubuntu.com/tutorials/install-and-configure-wordpress
#
# Ubuntu Server 21.04 LTS
# PHP 7.4
# WP 5.8.2
#

# install remotely via packer
export DEBIAN_FRONTEND=noninteractive

sudo apt-get -y update
sudo apt-get -y upgrade


# PHP

sudo apt-get -y install \
    apache2             \
    ghostscript         \
    mysql-client        \
    libapache2-mod-php  \
    php                 \
    php-bcmath          \
    php-curl            \
    php-imagick         \
    php-intl            \
    php-json            \
    php-mbstring        \
    php-mysql           \
    php-xml             \
    php-zip             \


sudo echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php


# Wordpress: latest
sudo mkdir -p /srv/www

curl -s https://wordpress.org/wordpress-5.8.2.tar.gz \
  | sudo tar xz -C /srv/www

sudo /bin/cp \
     /tmp/wp-config.php \
     /srv/www/wordpress/wp-config.php

sudo chown -R www-data:www-data /srv/www

# Disable Apache default page
sudo a2dissite 000-default

# Enable WP
sudo /bin/cp \
     /tmp/apache-wordpress.conf \
     /etc/apache2/sites-available/wordpress.conf

sudo a2ensite wordpress
sudo a2enmod rewrite

sudo service apache2 restart


