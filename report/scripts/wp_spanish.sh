#!/bin/bash
su -
wget https://es.wordpress.org/wordpress-4.3.1-es_ES.zip
unzip wordpress-4.3.1-es_ES.zip
cd wordpress/wp-content/languages/
mkdir -p /var/www/html/wordpress/wp-content/languages
mv *.mo *.po /var/www/html/wordpress/wp-content/languages/
cd && rm -rf wordpress-4.3.1-es_ES.zip wordpress
service httpd restart