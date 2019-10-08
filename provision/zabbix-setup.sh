#!/usr/bin/env bash
set -x
sudo cp /home/vagrant/selinux /etc/sysconfig/selinux
#sudo reboot
sudo yum -y install httpd
systemctl status httpd.service
sudo systemctl start httpd.service
sudo systemctl enable httpd
systemctl status httpd.service
sudo yum -y install epel-release
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum repolist --disableincludes remi-php54
yum repolist --enablerepo remi-php72
sudo yum install -y php php-pear php-cgi php-common php-mbstring php-snmp php-gd php-pecl-mysql php-xml php-mysql php-gettext php-bcmath
cat /etc/php.ini | sed 's/;date.timezone =/date.timezone = "Europe\/Kiev"/g'
sudo yum --enablerepo=remi -y install mariadb-server
sudo systemctl start mariadb.service
sudo systemctl enable mariadb
#mysql_secure_installation
mysql -u root -p
Create database fosslinuxzabbix;
create user 'zabbixuser'@'localhost' identified BY '@dfEr234KliT90';
grant all privileges on fosslinuxzabbix.* to zabbixuser@localhost ;
flush privileges;
#sudo rpm -ivh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-agent-4.0.0-2.el7.x86_64.rpm
#sudo yum -y install zabbix-server-mysql  zabbix-web-mysql zabbix-agent zabbix-get
#yum makecache
# https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch

#sudo wget http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm
#sudo rpm -ihv http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm

sudo rpm -ihv https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-get-4.0.1-1.el7.x86_64.rpm
sudo rpm -ihv https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-agent-4.0.1-1.el7.x86_64.rpm
sudo rpm -ihv https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-web-mysql-4.0.1-1.el7.noarch.rpm
sudo rpm -ihv https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-server-mysql-4.0.1-1.el7.x86_64.rpm


exit 0

