#!/usr/bin/env bash
set -x

sudo yum update -y
sudo cp /home/vagrant/selinux /etc/sysconfig/selinux
cat /etc/selinux/config | grep SELINUX=
sudo yum -y install httpd vim
sudo cp /home/vagrant/httpd.conf /etc/httpd/conf/httpd.conf 
cat /etc/httpd/conf/httpd.conf  | grep ServerName
sudo systemctl start httpd.service
sudo systemctl enable httpd
systemctl status httpd.service
sudo yum -y install php php-pear php-cgi php-common php-mbstring php-snmp php-gd php-xml php-mysql php-gettext php-bcmath
php -v
sudo sed -i "s/^;date.timezone =$/date.timezone = \"Europe\/Kiev\"/" /etc/php.ini
cat /etc/php.ini | grep date.timezone
sudo systemctl restart httpd

sudo yum --enablerepo="base" -y install yum-utils
sudo rpm -ivh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
sudo yum-config-manager --enable rhel-7-server-optional-rpms
sudo yum install -y zabbix-server-mysql zabbix-web-mysql
sudo sed -i "s/^# DBPassword=/DBPassword=zabbix/" /etc/zabbix/zabbix_server.conf


sudo yum remove -y mariadb-server
cat <<EOF | sudo tee /etc/yum.repos.d/MariaDB.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.4/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
innodb-strict-mode=0
innodb_page_size=65536
innodb_log_buffer_size=33554432
innodb_buffer_pool_size=536870912
innodb_default_row_format=dynamic
EOF
sudo yum makecache fast
sudo yum -y install MariaDB-server MariaDB-client
rpm -qi MariaDB-server
sudo systemctl enable --now mariadb
sudo mysql_secure_installation <<EOF

y
y
secret
secret
y
y
y
y
EOF

#export zabbix_db_pass="zabbix"
sudo mysql -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'zabbix';";
sudo mysql -e "create database zabbix;"; 
#character set utf8 collate utf8_bin;"
sudo mysql -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';";
sudo mysql -e "FLUSH PRIVILEGES;";
#sudo mysql -e "SET FOREIGN_KEY_CHECKS = 0;"
#sudo mysql -e "DROP TABLE zabbix.users, zabbix.maintenances, zabbix.hosts, zabbix.group_prototype, zabbix.group_discovery, zabbix.screens, ;"

zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -pzabbix zabbix
#ERROR 1118 (42000) at line 1278: Row size too large (> 8126). Changing some columns to TEXT or BLOB may help. In current row format, BLOB prefix of 0 bytes is stored inline
#zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix
#ERROR 1050 (42S01) at line 1: Table 'users' already exists

sudo systemctl start zabbix-server
sudo systemctl enable zabbix-server
sudo chkconfig --level 12345 zabbix-server on

sudo setsebool -P httpd_can_connect_zabbix on
sudo setsebool -P httpd_can_network_connect_db on
sudo service httpd restart
sudo yum install -y zabbix-agent
sudo service zabbix-agent start

