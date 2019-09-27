#!/usr/bin/env bash
set -x
apt-get update
apt-get install -y apache2

# if ! [ -L /var/www ]; then
#   rm -rf /var/www
#   ln -fs /vagrant/www /var/www
# fi
sudo apt-get install libapache2-mod-proxy-html
a2enmod proxy
a2enmod proxy_html
a2enmod proxy_http
sudo service apache2 restart

cp /vagrant/apache/000-default.conf /etc/apache2/sites-available/
a2ensite 000-default.conf
a2enmod proxy
a2enmod proxy_http
sudo service apache2 restart
