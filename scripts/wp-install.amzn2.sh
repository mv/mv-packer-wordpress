

#
# https://ubuntu.com/tutorials/install-and-configure-wordpress
#
# Amazon Linux v2
# PHP 7.4
# WP 5.8.2
#

sudo yum update -y
sudo yum install amazon-linux-extras -y


# PHP

sudo yum install -y     \
    httpd               \
    mod_ssl             \
    ghostscript         \
    mariadb             \
    php-mysql           \
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


# Wordpress: latest
sudo mkdir -p /srv/www

curl -s https://wordpress.org/wordpress-5.8.2.tar.gz \
  | sudo tar xz -C /srv/www

sudo chown -R apache:apache /srv/www

# Apache: Disable Apache default page
#udo a2dissite 000-default

# Apache: enable WP
sudo /bin/cp \
     /tmp/dev.apache.wordpress.conf \
     /etc/httpd/conf.d/

# Apache: enable SSL
cd /etc/ssl && sudo ln -snf ../pki/tls/private

sudo /bin/cp \
     /tmp/localhost-selfsigned-cert.pem \
     /etc/pki/tls/certs/

sudo /bin/cp \
     /tmp/localhost-selfsigned-priv.key \
     /etc/pki/tls/private/


sudo service httpd restart


