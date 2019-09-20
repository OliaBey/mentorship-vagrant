#!/usr/bin/env bash
set +x

echo "Install Java"
sudo yum -y install java-1.8.0-openjdk-devel || exit 1
echo "enable the Jenkins repository"
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo || exit 2
echo "add the repository to your system"
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key || exit 3
echo "install the latest stable version of Jenkins"
sudo yum -y install jenkins || exit 4
echo "start the Jenkins service"
sudo systemctl start jenkins || exit 5
sudo systemctl status jenkins
echo "enable the Jenkins service to start on system boot"
sudo systemctl enable jenkins || exit 6
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo systemctl status firewalld
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --reload
exit 0

