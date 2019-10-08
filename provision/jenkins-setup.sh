#!/usr/bin/env bash
set -x

sudo yum update -y
echo "Install Java, nginx"
sudo yum install -y $1 epel-release 
sudo yum install -y nginx || exit 1
nginx -v
echo "enable the Jenkins repository"
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo || exit 2
echo "add the repository to your system"
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key || exit 3
echo "install the latest stable version of Jenkins"
sudo yum -y install jenkins || exit 4
echo "start the Jenkins service"
sudo systemctl start jenkins || exit 5
sudo systemctl status jenkins
sudo cp /home/vagrant/nginx.conf /etc/nginx/nginx.conf
sudo systemctl restart nginx
sudo systemctl enable nginx 
sudo systemctl enable jenkins || exit 6
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo systemctl status firewalld
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --reload

sudo yum install -y git wget
git --version

cd /usr/local/src
sudo wget http://apache.ip-connect.vn.ua/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz
sudo tar -xf apache-maven-3.6.1-bin.tar.gz
sudo mv apache-maven-3.6.1/ apache-maven/
sudo cp /home/vagrant/maven.sh /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh
mvn -version
exit 0

