set -x

# Installing Oracle Java JDK 8
sudo yum update -y || exit 1
sudo yum install -y java-1.8.0-openjdk ||exit 2
java -version
# Add Tomcat user
sudo groupadd tomcat || exit 3
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat || exit 4
# Download Tomcat
cd /home/vagrant
sudo yum -y install curl || exit 5
curl -O --progress-bar http://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M22/bin/apache-tomcat-9.0.0.M22.tar.gz || exit 6
# Extract into target directory 
sudo mkdir /opt/tomcat 
sudo tar xzvf apache-tomcat-9*tar.gz -C /opt/tomcat --strip-components=1
# Assign ownership over target directory
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r /opt/tomcat/conf
sudo chmod g+x /opt/tomcat/conf
sudo chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/
# Copy basic Tomcat configuration files
cd /home/vagrant
sudo cp webapps/config/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml || exit 7
sudo cp webapps/config/context.xml /opt/tomcat/webapps/host-manager/META-INF/context.xml || exit 8
sudo cp webapps/config/tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml || exit 9
# Copy any webapps in the source folder
sudo cp webapps/*.war /opt/tomcat/webapps || exit 10

# Copy service file and reload daemon
sudo cp webapps/config/tomcat.service /etc/systemd/system/ || exit 11
sudo systemctl daemon-reload || exit 12
sudo systemctl start tomcat || exit 13
sudo ufw allow 8080 || exit 14
sudo systemctl enable tomcat || exit 15

# sudo systemctl status tomcat
# sudo sed -i -e 's=<Valve=<!--<Valve=g' /opt/tomcat/webapps/manager/META-INF/context.xml
# sudo sed -i -e 's=</Context>=--></Context>=g' /opt/tomcat/webapps/manager/META-INF/context.xml
# sudo sed -i -e 's=<Valve=<!--<Valve=g' /opt/tomcat/webapps/host-manager/META-INF/context.xml
# sudo sed -i -e 's=</Context>=--></Context>=g' /opt/tomcat/webapps/host-manager/META-INF/context.xml
# sudo update-java-alternatives -l
