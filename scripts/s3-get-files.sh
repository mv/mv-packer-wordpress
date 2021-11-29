#!/bin/bash
#


# Get files from S3 private bucket (Vault)

if [ "$1" == "" ]
then
    echo "Error: expected 'src' as a parameter"
    exit 1
fi

src="$1"

echo_cp() {

  echo "  Copy: [${1}] to [${2}] "

  # get local copy
  /usr/bin/aws s3 cp ${1} /srv/

  # final destination
  /bin/cp /srv/${1} ${2}

}

echo_cp ${src}.apache.wordpress.conf   /etc/apache2/sites-available/wordpress.conf
echo_cp ${src}.wp-config.php           /srv/www/wordpress/wp-config.php
echo_cp ${src}.wp-config.db-access.php /srv/www/wordpress/wp-config.db-access.php
echo_cp ${src}.wp-config.salt-keys.php /srv/www/wordpress/wp-config.salt-keys.php

#echo_cp ${src}.ssl-cert.pem /etc/ssl/certs/
#echo_cp ${src}.ssl-priv.key /etc/ssl/private/

service apache2 restart



