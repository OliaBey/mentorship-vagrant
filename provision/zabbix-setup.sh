#!/usr/bin/env bash
set +x

echo "add the repository to your system"
sudo rpm -ivh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm || exit 1
echo "enable optional-rpms"
sudo yum-config-manager --enable rhel-7-server-optional-rpms || exit 2
echo "Install zabbix"
sudo yum install -y zabbix-server-mysql zabbix-web-mysql || exit 3
# yum install zabbix-proxy-mysql
sudo yum install zabbix-web-mysql




sudo yum install -y wget
wget http://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
sudo rpm -Uvh mysql57-community-release-el7-9.noarch.rpm
sudo yum install -y mysql-server
sudo systemctl start mysqld
sudo systemctl status mysqld

sudo cat /var/log/mysqld.log
mysql -uroot -p:I8NqRr?cfa?
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('qaz123WSX!');
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by 'qaz123WSX!';
quit;




exit 0

