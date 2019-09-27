# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "jenkins" do |cen|
     cen.vm.box = "centos/7"
     cen.vm.box_check_update = false
     cen.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true 
     cen.vm.network  "forwarded_port", guest: 22, host: 2222, auto_correct: true 
     #cen.vm.synced_folder "./data", "/vagrant_data"
     cen.vm.provision "shell" do |s| 
       s.path = "./provision/jenkins-setup.sh"
       s.args = ["java-1.8.0-openjdk"]
     end
     cen.vm.provider "virtualbox" do |vb|
       vb.name = "jenkins"
       vb.memory = "4096"
     end
   end

  config.vm.define "zabbix" do |zab|
     zab.vm.box = "centos/7"
     zab.vm.box_check_update = false
     zab.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true 
     zab.vm.network  "forwarded_port", guest: 22, host: 2222, auto_correct: true 
     #zab.vm.synced_folder "./data", "/vagrant_data"
     #zab.vm.provision "shell", path: "./provision/zabbix-setup.sh"
     zab.vm.provider "virtualbox" do |vb|
       vb.name = "zabbix"
       vb.memory = "1024"
     end
   end

#https://github.com/kploesser/vagrant-for-tomcat
  config.vm.define "mytomcat" do |tom|
     #tom.vm.box = "centos/7"
     tom.vm.box = "geerlingguy/centos7"
     tom.vm.box_version = "1.2.16"
     #tom.vm.box_check_update = false
     tom.vm.network  "private_network", ip: "192.168.10.2"
     tom.vm.network "forwarded_port", guest: 8080, host: 4000, auto_correct: true
     tom.vm.synced_folder "webapps/", "/home/vagrant/webapps"
     tom.vm.provision "shell" do |s| 
       s.path = "./provision/tomcat-setup.sh"
       s.args = ["java-1.8.0-openjdk", "tomcat-9/v9.0.0.M22/bin/apache-tomcat-9.0.0.M22.tar.gz", "apache-tomcat-9*tar.gz"]
     end
     tom.vm.provider "virtualbox" do |vb|
       vb.name = "mytomcat"
     end
   end

  config.vm.define "apache2" do |apa|
     apa.vm.box = "ubuntu/trusty64"
     #apa.vm.box_check_update = false
     apa.vm.network  "private_network", ip: "192.168.10.3"
     apa.vm.network "forwarded_port", guest: 80, host: 4567
     apa.vm.synced_folder "apache/", "/home/vagrant/"
     apa.vm.provision "shell", path: "./provision/apache-setup.sh"
     apa.vm.provider "virtualbox" do |vb|
       vb.name = "apache"
     end
   end

end
