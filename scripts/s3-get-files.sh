#!/bin/bash
#


# Get files from S3 private bucket (Vault)

if [ "$1" == "" ]
then
    echo "Error: expected 'src' as a parameter"
    exit 1
fi

_src="${1}"
_env="${2}"

echo_cp() {

  echo "    Copy: [${1}] to [${2}] "

  # get local copy
  /usr/bin/aws s3 cp ${_src}/${_env}.${1} /tmp/

  # final destination
  sudo /bin/cp /tmp/${_env}.${1} ${2}
  echo

}

#cho_cp apache.wordpress.conf   /etc/apache2/sites-available/wordpress.conf
echo_cp apache.wordpress.conf   /etc/httpd/conf.d/wordpress.conf
echo_cp wp-config.php           /srv/www/wordpress/wp-config.php
echo_cp wp-config.db-access.php /srv/www/wordpress/wp-config.db-access.php
echo_cp wp-config.salt-keys.php /srv/www/wordpress/wp-config.salt-keys.php

#echo_cp ${_env}.ssl-cert.pem /etc/ssl/certs/
#echo_cp ${_env}.ssl-priv.key /etc/ssl/private/

#ervice apache2 restart
service httpd restart

