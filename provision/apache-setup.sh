#!/usr/bin/env bash
set -x
sudo mkdir -p /vagrant/www/html
sudo cd /vagrant/www/html
apt-get update
apt-get install -y apache2
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant/www /var/www
fi
sudo apt-get install libapache2-mod-proxy-html
sudo a2enmod proxy
sudo a2enmod proxy_html
sudo a2enmod proxy_http
sudo service apache2 restart

cp /vagrant/apache/001-mysite.conf /etc/apache2/sites-available/
a2ensite 001-mysite.conf
a2enmod proxy
a2enmod proxy_http
service apache2 restart