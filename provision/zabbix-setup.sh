#!/usr/bin/env bash
set -x
sudo cp /home/vagrant/selinux /etc/sysconfig/selinux
# cat /etc/selinux/config | grep SELINUX=
#sudo reboot
sudo yum -y install httpd vim
sudo cp /home/vagrant/httpd.conf /etc/httpd/conf/httpd.conf 
# cat /etc/httpd/conf/httpd.conf  | grep ServerName
#systemctl status httpd.service
sudo systemctl start httpd.service
sudo systemctl enable httpd
systemctl status httpd.service
#sudo yum -y install epel-release
#sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
#yum repolist --disableincludes remi-php54
#yum repolist --enablerepo remi-php72
sudo yum -y install php php-pear php-cgi php-common php-mbstring php-snmp php-gd php-xml php-mysql php-gettext php-bcmath
php -v
#sudo yum install -y php php-pear php-cgi php-common php-mbstring php-snmp php-gd php-pecl-mysql php-xml php-mysql php-gettext php-bcmath
sudo sed -i "s/^;date.timezone =$/date.timezone = \"Europe\/Kiev\"/" /etc/php.ini
# cat /etc/php.ini | grep date.timezone
#cat /etc/php.ini | sed 's/;date.timezone =/date.timezone = "Europe\/Kiev"/g'
sudo systemctl restart httpd
sudo yum remove mariadb-server # add y?
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
#  export zabbix_db_pass="StrongPassword"
# mysql -e "grant all privileges on zabbix.* to zabbix@localhost identified by '${zabbix_db_pass}';";
mysql -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'zabbix';";
mysql -e "create database zabbix character set utf8 collate utf8_bin;"
mysql -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';";
mysql -e "FLUSH PRIVILEGES;";
#mysql -u root -psecret
#export zabbix_db_pass="StrongPassword"
#mysql -uroot -psecret <<MYSQL_SCRIPT
#    create database zabbix;
#    grant all privileges on zabbix.* to zabbix@'localhost' identified by '${zabbix_db_pass}';
#    FLUSH PRIVILEGES;
#MYSQL_SCRIPT

sudo yum install -y https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
sudo yum install -y zabbix-server-mysql zabbix-web-mysql zabbix-agent zabbix-get
cd /usr/share/doc/zabbix-server-mysql*
echo $pwd
zcat create.sql.gz | mysql -uzabbix -p"zabbix" zabbix;
# ERROR 1118 (42000) at line 1278: Row size too large (> 8126). Changing some columns to TEXT or BLOB may help. In current row format, BLOB prefix of 0 bytes is stored inline.
sudo sed -i "s/^# DBPassword=/DBPassword=zabbix/g" /etc/zabbix/zabbix_server.conf
sudo systemctl restart httpd zabbix-server
sudo systemctl enable zabbix-server
sudo sed -i "s/^        # php_value date.timezone Europe\/Riga/        php_value date.timezone Europe\/Kiev/g" /etc/httpd/conf.d/zabbix.conf
sudo systemctl restart httpd

exit 0

