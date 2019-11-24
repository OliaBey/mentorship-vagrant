#!/usr/bin/env bash
set -x

#https://github.com/kploesser/vagrant-for-tomcat
# Installing Oracle Java JDK 8
sudo yum update -y || exit 1
sudo yum install -y $1 ||exit 2
mv /usr/lib/jvm/$1* /usr/lib/jvm/java-8-openjdk
java -version
# Add Tomcat user
sudo groupadd tomcat || exit 3
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat || exit 4
# Download Tomcat
cd /home/vagrant
sudo yum -y install curl || exit 5
curl -O --progress-bar http://archive.apache.org/dist/tomcat/$2 || exit 6
# Extract into target directory 
sudo mkdir /opt/tomcat 
sudo tar xzvf $3 -C /opt/tomcat --strip-components=1
# Assign ownership over target directory
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r /opt/tomcat/conf
sudo chmod g+x /opt/tomcat/conf
sudo chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/
# Copy basic Tomcat configuration files
sudo cp /home/vagrant/config/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml || exit 7
sudo cp /home/vagrant/config/context.xml /opt/tomcat/webapps/host-manager/META-INF/context.xml || exit 8
sudo cp /home/vagrant/config/tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml || exit 9
# Copy any webapps in the source folder
#sudo cp webapps/*.war /opt/tomcat/webapps || exit 10

# Copy service file and reload daemon
sudo cp /home/vagrant/config/tomcat.service /etc/systemd/system/ || exit 11
sudo systemctl daemon-reload || exit 12
sudo systemctl start tomcat || exit 13
sudo systemctl enable tomcat
sudo systemctl status tomcat || exit 15

# sudo systemctl status tomcat
# sudo sed -i -e 's=<Valve=<!--<Valve=g' /opt/tomcat/webapps/manager/META-INF/context.xml
# sudo sed -i -e 's=</Context>=--></Context>=g' /opt/tomcat/webapps/manager/META-INF/context.xml
# sudo sed -i -e 's=<Valve=<!--<Valve=g' /opt/tomcat/webapps/host-manager/META-INF/context.xml
# sudo sed -i -e 's=</Context>=--></Context>=g' /opt/tomcat/webapps/host-manager/META-INF/context.xml
# sudo update-java-alternatives -l

yum update -y httpd
sudo yum install -y httpd
#sudo cp /home/vagrant/000-default.conf /etc/httpd/conf.d/default-site.conf
sudo systemctl start httpd
sudo systemctl status httpd

sudo rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-2.el7.noarch.rpm
sudo yum install -y zabbix-agent
sudo sed -i "s/^Server=127.0.0.1/Server=192.168.50.5/" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^ServerActive=127.0.0.1/ServerActive=192.168.50.5:10051/" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^Hostname=Zabbix server/Hostname=zabbix_tomcat/" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/^# HostMetadata=/HostMetadata=linux.autoreg/" /etc/zabbix/zabbix_agentd.conf
sudo service zabbix-agent start
